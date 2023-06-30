import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maharani_bakery_app/components/build_rating.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/screens/cakeTypeScreen.dart';
import 'package:maharani_bakery_app/screens/cart_screen.dart';
import 'package:maharani_bakery_app/screens/categoryScreen.dart';
import 'package:maharani_bakery_app/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/searchScreen.dart';
import '../screens/wishlistScreen.dart';

class HeaderSecond extends StatelessWidget {
  final idScreen;
  dynamic scaffoldKey;
  HeaderSecond({Key? key, required this.idScreen, required this.scaffoldKey}) : super(key: key);

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
    }
  }

  _makePhoneCall(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      displayToastMessage("Cant make the phone call.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      top: -20,
      child: Container(
        height: 130.0,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 16.0,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: IconButton(
                            onPressed: () {
                              scaffoldKey.currentState!.openDrawer();

                            },
                            icon: Icon(
                              Icons.menu,
                              size: 30,
                              color: brandGold,
                            )
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Image.asset("assets/images/1.png",
                                    height: 80,),
                                ),

                                // Container(
                                //   child: Text("Maharani Bakery",
                                //     style: TextStyle(
                                //         fontFamily: "Candarai",
                                //         fontSize: 30.0,
                                //         fontWeight: FontWeight.bold
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextButton(
                          onPressed: () {
                            if(idScreen != "wishlist"){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => WishlistScreen())
                              );
                            }
                          } ,
                          child: Stack(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 30,
                                color: brandGold,
                                // color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Search screen
                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
              //   child: GestureDetector(
              //       onTap: (){
              //         Navigator.push(
              //             context, MaterialPageRoute(builder: (_) => SearchScreen(allData: [cakeCategories, categories],)));
              //       },
              //       child : Container(
              //         decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(5.0),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.black26,
              //               blurRadius: 6.0,
              //               spreadRadius: 0.5,
              //             ),
              //           ],
              //         ),
              //         height: 35.0,
              //         width: double.infinity,
              //         child: Row(
              //           children: [
              //             SizedBox(width: 7.0,),
              //             Icon(Icons.search, color: Colors.black,),
              //             SizedBox(width: 10.0,),
              //             Text(
              //               "Search",
              //             ),
              //           ],
              //         ),
              //       )
              //
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
