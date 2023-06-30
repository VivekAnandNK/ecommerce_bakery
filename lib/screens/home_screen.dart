import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/models/user.dart';
import 'package:maharani_bakery_app/screens/cart_screen.dart';
import 'package:maharani_bakery_app/screens/privacyPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/returnAndRefundPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/searchScreen.dart';
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/bottomWidget.dart';
import 'package:maharani_bakery_app/widgets/categories.dart';
import 'package:maharani_bakery_app/widgets/header.dart';
import 'package:maharani_bakery_app/widgets/navigationBar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cakeTypeScreen.dart';
import 'categoryScreen.dart';

class Home extends StatefulWidget {
  static const String idScreen = "home";
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController searchTextEditingController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _makePhoneCall(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      displayToastMessage("Cant make the phone call.", context);
    }
  }

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([]);


    // updateFoodDetails();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    OutlineInputBorder _focus_and_enabled_border_style = OutlineInputBorder(
      borderSide: BorderSide(width: 0.8, color: Colors.black),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      drawer: Drawer(
        backgroundColor: Colors.black,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Image.asset('assets/images/1.png', color: brandGold,)
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: brandGold,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CakeTypeScreen(category: cakeCategories[0], categoriesGlobal: cakeCategories[0].childCategories,))
                );

              },
              child: ListTile(
                leading: Icon(Icons.cake, color: brandGold,),
                title: Text('Cakes', style: TextStyle(color: brandGold),),
              ),
            ),
            GestureDetector(
              onTap: () async{
                await _makePhoneCall("tel:${phoneNumber[locationName]}", context);
              },
              child: ListTile(
                leading: Icon(Icons.phone, color: brandGold,),
                title: Text('Contact', style: TextStyle(color: brandGold),),
              ),
            ),
            GestureDetector(
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WishlistScreen())
                );

              },
              child: ListTile(
                leading: Icon(Icons.favorite, color: brandGold,),
                title: Text('Wishlist', style: TextStyle(color: brandGold),),
              ),
            ),
            GestureDetector(
              onTap: () {

                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CartScreen()));
              },
              child: ListTile(
                leading: Icon(Icons.shopping_cart_outlined, color: brandGold,),
                title: Text('Cart', style: TextStyle(color: brandGold),),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PrivacyPolicyPage())
                );

              },
              child: ListTile(
                leading: Icon(Icons.policy_outlined, color: brandGold,),
                title: Text('Privacy Policy', style: TextStyle(color: brandGold),),
              ),
            ),
            GestureDetector(
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReturnRefundPolicyPage())
                );

              },
              child: ListTile(
                leading: Icon(Icons.policy_outlined, color: brandGold,),
                title: Text('Returns and Refunds', style: TextStyle(color: brandGold),),
              ),
            ),
            GestureDetector(
              onTap: () {


                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TermsAndConditionsPage())
                );
              },
              child: ListTile(
                leading: Icon(Icons.policy_outlined, color: brandGold,),
                title: Text('Terms and Conditions', style: TextStyle(color: brandGold),),
              ),
            ),
            SizedBox(height: 20.0,),
          ],
        ),
      ),
      body: Stack(
          children: [
            Listener(
              child: AnimateIfVisibleWrapper(
                showItemInterval: Duration(milliseconds: 150),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: 150.0,),
                    ImageSlideshow(
                      width: double.infinity,
                      height: 200,
                      initialPage: 0,
                      indicatorColor: Colors.black,
                      indicatorBackgroundColor: Colors.white,
                      children: [
                        for(var elements in slideShow.entries)
                          OptimizedCacheImage(
                            imageUrl: 'https://res.cloudinary.com/maharani/image/upload/${elements.value}/image_asset/${elements.key.replaceAll(" ", "")}.jpg',

                          ),
                      ],
                      onPageChanged: (value) {
                      },
                      autoPlayInterval: 3000,
                      isLoop: true,
                    ),

                    SizedBox(height: 20.0,),

                    Center(
                        child: Text(
                          "Items baked with Love",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                              fontFamily: "Candarai"
                          ),
                        )
                    ),

                    SizedBox(height: 20.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Candarai",
                            letterSpacing: 1.2),
                      ),
                    ),

                    for (var elements in cakeCategories)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CakeTypeScreen(categoriesGlobal: elements.childCategories, category: elements,))
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.black12,
                            ),
                          ),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  child: Image(
                                    image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${elements.imageUrl}/image_asset/${elements.firebaseId}.jpg"),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),

                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        elements.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Candarai"
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        elements.description,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Candarai"
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    for (var elements in categories)
                      GestureDetector(
                        onTap: () {
                          if (elements.childCategories.length > 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => CakeTypeScreen(category: elements, categoriesGlobal: elements.childCategories,))
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => CategoryScreen(category: elements.childCategories[0], categoryMain: elements,)));
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              width: 1.0,
                              color: Colors.black12,
                            ),
                          ),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  child: Image(
                                    image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${elements.imageUrl}/image_asset/${elements.firebaseId}.jpg"),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        elements.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Candarai"
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        elements.description,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Candarai"
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    BottomWidget(),
                    SizedBox(height: 70.0,),
                  ],
                ),
              ),
            ),
            Header(idScreen: "header", scaffoldKey: _scaffoldKey,),

            NavigationsBar(idScreen: "home",),

          ]
      ),

    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

