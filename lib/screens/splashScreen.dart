import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeCategory.dart';
import 'package:maharani_bakery_app/models/cakeChildCategory.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/screens/locationSelectScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/childCategory.dart';
import 'home_screen.dart';
import 'package:dio/dio.dart';
class SplashScreen extends StatefulWidget {
  static String idScreen = "splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  final List<Category> categoryList = [];
  final List<CakeCategory> cakeCategoryList = [];
  Map cakeData = {};
  Map categoriesMap = {};
  String idList = "";
  bool loaded = false;
  bool internetAccess = true;
  double pointerDown = 0.0;
  double headerHeight = 0.0;
  bool locationFound = false;

  Future<bool> checkInternetConnection() async {
    try {
      Response response = await Dio().get("https://www.google.com");
      if (response.statusCode == 200) {
        setState(() {
          internetAccess = true;
        });
      } else {
        setState(() {
          internetAccess = false;
        });
      }

      return response.statusCode == 200;
    } catch (e) {
      setState(() {
        internetAccess = false;
      });
      return false;
    }
  }

  void updateFoodDetails() async{

    setState(() {
      loaded = false;
    });

    List<Food> foodListTemp = [];
    List<Cake> cakeList = [];


    final event = await referenceGlobal.once(DatabaseEventType.value);
    Map dataSnapshot = event.snapshot.value as Map<dynamic, dynamic>;

    // await referenceGlobal.once().then((DataSnapshot dataSnapshot) {
    if(dataSnapshot != null){
      if(dataSnapshot.containsKey("Settings")) {

        deliveryDetails = dataSnapshot["Settings"];

      } else {
        deliveryDetails = {
          "homeDelivery" : true,
          "deliveryFree" : "n/a",
          "deliveryTime" : "n/a",
          "deliveryDetails" : 0.0,
          "deliveryMinAmount" : 0,
        };

      }
      if (dataSnapshot.containsKey("Slideshow")) {
        for (var slides in dataSnapshot["Slideshow"].entries) {
          slideShow.addAll(
              {
                slides.key: slides.value
              });
        }

      }
      if (dataSnapshot.containsKey("Categories")) {
        for (var category in dataSnapshot["Categories"].entries) {
          if (category.key == "CakesCategories") {
            List<CakeChildCategory> cakeChildCategoriesTemp = [];
            if (category.value.containsKey("ChildCategories")) {
              for (var childCategory in category.value["ChildCategories"].entries) {
                // cakeList = [];
                // if (childCategory.value.containsKey("Items")) {
                //   for(var cake in childCategory.value["Items"].entries){
                //     Map tempWeightPrice = {};
                //     Map tempWeightPriceOffer = {};
                //     for(var weights in cake.value["WeightPrice"]){
                //       tempWeightPrice[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
                //     }
                //     if (cake.value.containsKey("offerWeight")) {
                //       for(var weights in cake.value["offerWeight"]){
                //         tempWeightPriceOffer[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
                //       }
                //     } else {
                //       tempWeightPriceOffer = tempWeightPrice;
                //     }
                //     List<String> cakeImages = [];
                //     if (cake.value["Image"].runtimeType.toString() == "String") {
                //       cakeImages = ["https://res.cloudinary.com/maharani/image/upload/${cake.value["Image"].toString()}/image_asset/${cake.key}.jpg"];
                //     } else {
                //       for (var images in cake.value["Image"]) {
                //         if (images != "") {
                //           cakeImages.add(images.toString());
                //
                //         }
                //       }
                //     }
                //
                //     cakeImages.sort((a, b) => a.compareTo(b));
                //
                //     Cake tempCake = Cake(
                //         firebaseId: cake.key,
                //         imageUrl: cakeImages,
                //         name: cake.value["Name"],
                //         specs: cake.value["Specs"],
                //         number: cake.value["No"],
                //         weightPrice: tempWeightPrice,
                //         weightPriceOffer: tempWeightPriceOffer,
                //         offerAvailable: cake.value["offerApplicable"] ?? false,
                //         inStock: cake.value["inStock"] ?? true,
                //         description: cake.value["description"] ?? ""
                //     );
                //     cakeList.add(
                //         tempCake
                //     );
                //
                //   }
                // }
                //
                // cakeList.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));

                cakeChildCategoriesTemp.add(
                    CakeChildCategory(
                        imageUrl: childCategory.value["Image"] ?? "",
                        firebaseId: childCategory.key,
                        description: childCategory.value["Description"] ?? "",
                        name: childCategory.value["Name"] ?? "",
                        number: (childCategory.value["No"] ?? "0").toString(),
                        // items: cakeList
                    )
                );
              }
            }

            cakeChildCategoriesTemp.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));


            cakeCategories.add(
                CakeCategory(
                    imageUrl: category.value["Image"] ?? "",
                    firebaseId: "CakesCategories",
                    description: category.value["Description"] ?? "",
                    name: category.value["Name"] ?? "",
                    number: (category.value["No"] ?? "").toString(),
                    childCategories: cakeChildCategoriesTemp
                )
            );

          } else {
            List<ChildCategory> childCategoriesTemp = [];
            if (category.value.containsKey("ChildCategories")) {
              for (var childCategory in category.value["ChildCategories"].entries) {
                foodListTemp = [];
                if(childCategory.value.containsKey("Items")){
                  for(var items in childCategory.value["Items"].entries){


                    bool isFavourite = wishList!.any((item) => item.contains(items.key));


                    foodListTemp.add(
                        Food(
                            firebaseId: items.key,
                            number: (items.value["No"] ?? "0").toString(),
                            imageUrl: items.value["Image"],
                            name: items.value["Name"],
                            price: double.parse(items.value["Price"].toString()),
                            specs: items.value["Specs"],
                            priceOffer: double.parse(items.value["offerPrice"] ?? items.value["Price"]),
                            offerAvailable: items.value["offerApplicable"] ?? false,
                            inStock: items.value["inStock"] ?? true, type: 'food',
                            description: items.value["description"] ?? "", isFavourite: isFavourite

                        )
                    );

                  }
                }

                foodListTemp.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));


                childCategoriesTemp.add(
                    ChildCategory(
                        imageUrl: childCategory.value["Image"] ?? "",
                        firebaseId: childCategory.key,
                        description: childCategory.value["Description"] ?? "",
                        name: childCategory.value["Name"] ?? "",
                        number: (childCategory.value["No"] ?? "0").toString(),
                        items: foodListTemp
                    )
                );
              }
            }


            childCategoriesTemp.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));


            categories.add(
                Category(
                    imageUrl: category.value["Image"] ?? "",
                    firebaseId: category.key,
                    description: category.value["Description"] ?? "",
                    name: category.value["Name"] ?? "",
                    number: category.value["No"].toString() ?? "",

                    childCategories: childCategoriesTemp
                )
            );
          }
        }
      }

    }
    categories.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));


    if (locationFound) {
      Navigator.pushNamedAndRemoveUntil(context, Home.idScreen, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, LocationSelectScreen.idScreen, (route) => false);
    }

  }

  Future<void> _initSharedPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String>? wishListTemp = [];

    if (_prefs.containsKey("wishlist")) {
      wishListTemp = _prefs.getStringList('wishlist');
      wishList = wishListTemp;
    }

    if (_prefs.containsKey("selectedLocation")) {
      locationName = _prefs.getString('selectedLocation')!.toLowerCase();

      setState(() {
        locationFound = true;
      });
    } else {

      setState(() {
        locationFound = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([]);
    _initSharedPreferences().whenComplete(() => updateFoodDetails());

    checkInternetConnection();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: internetAccess ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("assets/images/splash.png", width: 395.0,),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(brandGold),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text(
              "Please Wait..",
              style: TextStyle(
                color: brandGold
              ),
            )
          )

        ],
      ) : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset("assets/images/splash.png", width: 395.0,),
          ),
          Center(
              child: Text(
                "No internet connection",
                style: TextStyle(
                    color: brandGold
                ),
              )
          )

        ],
      ),
    );
  }
}
