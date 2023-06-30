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

import '../screens/wishlistScreen.dart';

class NavigationsBar extends StatelessWidget {
  final idScreen;
  NavigationsBar({Key? key, required this.idScreen}) : super(key: key);

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
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        height: 35.0,
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
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    if(idScreen == "home"){
                      displayToastMessage("You are already home.", context);
                    }
                    else{
                      Navigator.pushNamedAndRemoveUntil(context, Home.idScreen, (route) => false);
                    }
                  },
                  icon: Icon(
                    Icons.home_outlined,
                    size: 20,
                    color: brandGold,
                  )
              ),

              IconButton(
                  onPressed: () {
                    if(idScreen != "cakeType"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CakeTypeScreen(category: cakeCategories[0], categoriesGlobal: cakeCategories[0].childCategories,))
                      );
                    }
                  },
                  icon: FaIcon(
                    Icons.cake_outlined,
                    size: 20,
                    color: brandGold,

                  )
              ),
              IconButton(
                  onPressed: () async{

                    await _makePhoneCall("tel:${phoneNumber[locationName]}", context);

                  },
                  icon: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: brandGold,

                  )
              ),
              IconButton(
                  onPressed: () {

                    if(idScreen != "wishlist"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WishlistScreen())
                      );
                    }
                  },
                  icon: Icon(
                    Icons.favorite_border_outlined,
                    size: 20,
                    color: brandGold,

                  )
              ),
              Stack(
                children: [
                  IconButton(
                      onPressed: () {

                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => CartScreen()));
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        size: 20,
                        color: brandGold,

                      )
                  ),
                  currentUser.cart.length > 0 ? Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        currentUser.cart.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ) : Container(),
                ],
              ),


              // Search screen
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
