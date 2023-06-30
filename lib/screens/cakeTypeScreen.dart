import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/bottomWidget.dart';
import 'package:maharani_bakery_app/widgets/cakeCategories.dart';
import 'package:maharani_bakery_app/widgets/categories.dart';
import 'package:maharani_bakery_app/widgets/header.dart';
import 'package:maharani_bakery_app/widgets/header_second.dart';
import 'package:maharani_bakery_app/widgets/navigationBar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';
class CakeTypeScreen extends StatefulWidget {
  static const String idScreen = "cakeType";
  final List categoriesGlobal;
  final dynamic category;
  CakeTypeScreen({Key? key, required this.categoriesGlobal, required this.category}) : super(key: key);

  @override
  _CakeTypeScreenState createState() => _CakeTypeScreenState();
}

class _CakeTypeScreenState extends State<CakeTypeScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  final List<Category> categoryList = [];
  final List<CakeCategory> cakeCategoryList = [];
  Map cakeData = {};
  Map slideShow = {};
  Map categoriesMap = {};
  bool loaded = false;
  double pointerDown = 0.0;
  double headerHeight = 0.0;

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

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: null,
      key: _scaffoldKey,
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

            AnimateIfVisibleWrapper(
              showItemInterval: Duration(milliseconds: 150),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [


                  SizedBox(height: 90.0,),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                        child: Text(
                          widget.category.description,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              fontFamily: "Candarai"
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),


                  SizedBox(height: 20.0,),



                  CategoriesItems(categoryMain: widget.category, categoriesGlobal: widget.categoriesGlobal),

                  SizedBox(height: 70.0,),

                  BottomWidget(),
                  SizedBox(height: 60.0,),

                ],
              ),
            ),
            HeaderSecond(idScreen: "header", scaffoldKey: _scaffoldKey,),
            NavigationsBar(idScreen: "cakeType",),


          ]
      ),

    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

