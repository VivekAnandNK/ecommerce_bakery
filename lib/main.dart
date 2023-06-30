import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:maharani_bakery_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maharani_bakery_app/screens/locationSelectScreen.dart';
import 'package:maharani_bakery_app/screens/splashScreen.dart';

Future<void> secureScreen() async {
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}

late AndroidNotificationChannel channel;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

bool isFlutterLocalNotificationsInitialized = false;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void showFlutterNotification(RemoteMessage message) async{
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // isFlutterLocalNotificationsInitialized = true;

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // notificationItemId = notification.body!.split("<sep>")[1];
  print("HELLOOOOs");

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // // TODO add a proper drawable resource to android, for now using
          // //      one that already exists in example app.
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  secureScreen();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Request permission for receiving notifications
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  await _firebaseMessaging.subscribeToTopic('example');
  runApp(MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("BACKGROUNDDDDD");
  await Firebase.initializeApp();
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  // notificationItemId = notification.body!.split("<sep>")[1];

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // // TODO add a proper drawable resource to android, for now using
          // //      one that already exists in example app.
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }
  // showFlutterNotification(message);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? _token;
  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
          _resolved = true;
          initialMessage = value?.data.toString();
        },
      ),
    );

    // FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamedAndRemoveUntil(context, SplashScreen.idScreen, (route) => false);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("YESS");
      showFlutterNotification(message);
    });

    // _firebaseMessaging.getToken().then((token) {
    //   // Handle notification when the app is in the background
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maharani Bakery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        primaryColor: Colors.grey,
      ),
      initialRoute: SplashScreen.idScreen,
      routes:{
        SplashScreen.idScreen: (context) => SplashScreen(),
        Home.idScreen: (context) => Home(),
        LocationSelectScreen.idScreen: (context) => LocationSelectScreen(),
      },
    );
  }
}

