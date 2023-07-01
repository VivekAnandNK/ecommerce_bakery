import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/screens/cart_summary.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';
import '../widgets/progressDialog.dart';
import 'cakeItemScreen.dart';
import 'home_screen.dart';
import 'itemScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  LatLng source = LatLng(0, 0);
  // LatLng destination = LatLng(15.9470771, 75.2901629);
  LatLng destination = LatLng(coordinates[locationName][0], coordinates[locationName][1]);

  bool checkout = true;
  bool loaded = false;
  double deliveryCharge = 0.0;

  List orderQuantity = [];

  Future<void> sendWhatsAppMessage(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
    }
  }

  _getTotalCost() {
    // To get the total cost we have to loop throw all orders
    // quantity multiply by each food price
    double total = 0.0;
    currentUser.cart.forEach((order) => total += order.food == null ? (order.cake!.price * order.quantity) : (order.quantity * order.food!.price));

    return total.toStringAsFixed(2); // To round the price in cents(0.0)
  }

  Future<double> getDistance(LatLng place1, LatLng place2) async {
    String apiUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${place1.latitude},${place1.longitude}&destinations=${place2.latitude},${place2.longitude}&key=<api_KEY)";

    var response = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(response.body);

    double distance = (data['rows'][0]['elements'][0]['distance']['value'].toDouble() / 1000).ceilToDouble();
    return distance;
  }

  Future<bool> checkLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    bool settings = false;
    if (!serviceEnabled) {
      bool result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Services Disabled"),
          content: Text("Please enable Location Services to use this feature."),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("SETTINGS"),
              onPressed: () {
                settings = true;
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      ).then((value) {
        if (!settings) {
          Navigator.of(context).pop();
          return false;
        } else {
          Navigator.of(context).pop();
          return true;
        }

      });
      if (result) {
        await Geolocator.openLocationSettings();
      }
    }

    if (serviceEnabled) {
      return true;
    }
    return false;

    // print(_getTotalCost());
  }

  Future<Position> getLocationFromUser() async{
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Location Permission Denied"),
            content: Text("Please enable Location Services to use this feature."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(false),
              )
            ],
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Location Permission Denied Forever"),
          content: Text("Please enable Location Services to use this feature."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(false),
            )
          ],
        ),
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  Widget _buildCartItem(Order order, int index) {
    orderQuantity.add(order.quantity);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      height: 130.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: order.food == null ?
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(cake: order.cakeGlobal!, categoryId: order.cakeChildCategory!.firebaseId, categoryMainId: order.categoryMain!.firebaseId,)),);
                    },
                    child: CachedNetworkImage(
                      imageUrl: order.cake!.imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    //   Image(
                    //     image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${order.cake!.imageUrl}/image_asset/${order.cake!.firebaseId}.jpg"),
                    //     width: 130.0,
                    //     height: 130.0,
                    //     fit: BoxFit.cover,
                    //   ),
                  ) :
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: order.category!, food: order.category!.items[order.category!.items.indexWhere((element) => element.firebaseId == order.food!.firebaseId)], categoryMain: order.categoryMain,)),);
                    },
                    child: CachedNetworkImage(
                      imageUrl: "https://res.cloudinary.com/maharani/image/upload/${order.food!.imageUrl}/image_asset/${order.food!.firebaseId}.jpg",
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Image(
                    //   image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${order.food!.imageUrl}/image_asset/${order.food!.firebaseId}.jpg"),
                    //   width: 130.0,
                    //   height: 130.0,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          //color: Colors.blue,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      order.food == null ? Text(
                                        order.cake!.name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ) : Text(
                                        order.food!.name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      order.category == null ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   order.cakeChildCategory!.name,
                                          //   style: TextStyle(
                                          //       fontSize: 10,
                                          //       fontWeight: FontWeight.w400),
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                          order.food == null ?
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order.cake!.type.toString(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                order.cake!.weight.toString() + " Kg",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],

                                          ) :
                                          Container(),
                                        ],
                                      ) :
                                      Text(
                                        order.category!.name,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      // Dec or Inc Quantity //
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: (){
                                      currentUser.cart.remove(order);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child: order.food == null ? Text(
                                      'Rs. ${(order.cake!.price * order.quantity).toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ) : Text(
                                      'Rs. ${(order.quantity * order.food!.priceOffer).toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            border: Border.all(
                              width: 1.5,
                              color: Theme.of(context).primaryColor,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OperationButton(
                              context: context,
                              iconData: Icons.remove,
                              onPressed: () {
                                initDetails();
                                if(orderQuantity[index] > 0){
                                  order.quantity = order.quantity - 1;
                                  setState(() {
                                    orderQuantity[index]--;
                                  });
                                }
                              },
                            ),
                            Text(
                              orderQuantity[index].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            OperationButton(
                              context: context,
                              iconData: Icons.add,
                              onPressed: () {
                                initDetails();
                                order.quantity = order.quantity + 1;

                                setState(() {
                                  orderQuantity[index]++;
                                });

                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  initDetails() async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context){
    //
    //       String messageString = "Calculating delivery charge..";
    //       return ProgressDialog(message: messageString,);
    //     }
    // );
    setState(() {
      loaded = false;
    });

    if (await checkLocationServiceEnabled()) {
      Position pos = await getLocationFromUser();

      setState(() {
        source = LatLng(pos.latitude, pos.longitude);

      });

      double distance = await getDistance(source, destination);
      int finalDistance = (distance - double.parse(deliveryDetails["deliveryFree"])).toInt();

      if (distance > 0) {
        setState(() {
          deliveryCharge = finalDistance.toDouble() * double.parse(deliveryDetails["deliveryCharge"]);
        });
      }

    }

    if (double.parse(_getTotalCost()) >= deliveryDetails["deliveryMinAmount"]) {
      setState(() {
        deliveryCharge = 0.0;
      });
    }

    setState(() {
      loaded = true;
    });

    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    initDetails();



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart(${currentUser.cart.length})',
          style: TextStyle(
              color: brandGold
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
        foregroundColor: brandGold,
        iconTheme: IconThemeData(
            color: brandGold
        ),
      ),
      body: Stack(
        children: [
          currentUser.cart.length > 0 ? ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index < currentUser.cart.length) {
                  Order order = currentUser.cart[index];
                  return _buildCartItem(order, index);
                }
                return Column(
                  children: [
                    CartSummary(
                      title: 'Subtotal :',
                      value: 'Rs. ${_getTotalCost()}',
                      valueColor: Colors.black, titleSize: 17.0, valueSize: 17.0,
                    ),
                    CartSummary(
                      title: 'Delivery Charge :',
                      value: loaded ? 'Rs. $deliveryCharge' : "Rs. 0.0",
                      valueColor: Colors.black, titleSize: 17.0, valueSize: 17.0,
                    ),
                    CartSummary(
                      title: 'Total Price :',
                      value: 'Rs. ${double.parse(_getTotalCost()) + deliveryCharge}',
                      valueColor: Colors.teal, titleSize: 20.0, valueSize: 20.0,
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Divider(
                    color: Colors.black12,
                    height: 1.0,
                  ),
                );
              },
              itemCount: currentUser.cart.length + 1
          ) : Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/empty_cart.gif",
                  height: 150,
                ),
                const SizedBox(height: 10.0,),
                Text("Your cart is empty.", style: TextStyle(color: Colors.black, fontFamily: "AwanZaman", fontSize: 20.0),),

                SizedBox(height: 100.0,),
                Expanded(
                  child: Column(
                    children: [
                      CartSummary(
                        title: 'Subtotal :',
                        value: 'Rs. ${_getTotalCost()}',
                        valueColor: Colors.black, titleSize: 17.0, valueSize: 17.0,
                      ),
                      CartSummary(
                        title: 'Delivery Charge :',
                        value: loaded ? 'Rs. $deliveryCharge' : "Rs. 0.0",
                        valueColor: Colors.black, titleSize: 17.0, valueSize: 17.0,
                      ),
                      CartSummary(
                        title: 'Total Price :',
                        value: 'Rs. ${double.parse(_getTotalCost()) + deliveryCharge}',
                        valueColor: Colors.teal, titleSize: 20.0, valueSize: 20.0,
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          !loaded ? ProgressDialog(message: "Calculating delivery charge",) : Container(),
        ],
      ),

      bottomSheet: Container(
        // UI for the checkout logic //
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, -1),
                blurRadius: 6.0,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        child: Center(
          child: TextButton(
              onPressed: !loaded ? null : () async{
                if (loaded) {

                  if(currentUser.cart.length > 0) {
                    setState(() {
                      checkout = false;
                    });

                    String finalOrderString = "Hi I would like to place an order please. Please find my order details below:\n\nDate: ${DateFormat.yMEd().add_jms().format(DateTime.now()).toString()}\n\n";

                    for(var elements in currentUser.cart){
                      if (elements.food != null) {
                        finalOrderString += "Number: ${elements.food!.number}\nName: ${elements.food!.name}\nQuantity: ${elements.quantity}\nPrice: ${elements.food!.priceOffer}\n\n";

                      } else {
                        finalOrderString += "Number: ${elements.cake!.id}\nName: ${elements.cake!.name}\nQuantity: ${elements.quantity}\nWeight: ${elements.cake!.weight} KG\nType: ${elements.cake!.type}\nPrice: ${elements.cake!.price}\n\n";

                      }
                    }

                    String endString = "\nSubtotal: Rs. ${_getTotalCost()}\nDelivery Charge: Rs. $deliveryCharge\nTotal Price: Rs. ${double.parse(_getTotalCost()) + deliveryCharge}";


                    String message = finalOrderString + endString + "\n\nYou can track me here : https://www.google.com/maps/search/?api=1&query=${source.latitude},${source.longitude}";
                    String encodedMessage = Uri.encodeComponent(message);
                    String url = "whatsapp://send?phone=${phoneNumber[locationName]}&text=$encodedMessage";
                    currentUser = User(name: "Maharani", location: "Karnataka", orders: [], cart: []);

                    Navigator.pushNamedAndRemoveUntil(context, Home.idScreen, (route) => false);
                    sendWhatsAppMessage(Uri.parse(url));
                    setState(() {
                      checkout = true;

                    });
                  } else {
                    displayToastMessage("Nothing in cart.", context);
                  }


                } else {
                  displayToastMessage("Calculating delivery charge...", context);
                }
              },
              child: checkout ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Checkout',
                    style: TextStyle(
                        letterSpacing: 2.0, color: brandGold, fontSize: 24),
                  ),
                  !deliveryDetails["homeDelivery"] ? Text(
                    '** No home delivery available today **',
                    style: TextStyle(
                        letterSpacing: 2.0, color: brandGold, fontSize: 15, fontWeight: FontWeight.bold),
                  ) : Container(),
                ],
              ) : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(brandGold),
              )
          ),
        ),
      ),
    );
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

class OperationButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  const OperationButton({
    Key? key,
    required this.context,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Icon(
          iconData,
          color: Theme.of(context).primaryColor,
        ));
  }
}
