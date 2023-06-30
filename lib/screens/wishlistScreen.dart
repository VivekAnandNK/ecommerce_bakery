import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/screens/cart_summary.dart';
import 'package:maharani_bakery_app/widgets/cart_operation.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cake.dart';
import '../models/user.dart';
import '../widgets/navigationBar.dart';
import '../widgets/progressDialog.dart';
import 'cakeItemScreen.dart';
import 'home_screen.dart';
import 'itemScreen.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class WishlistScreen extends StatefulWidget {
  static const String idScreen = "wishlist";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {


  bool loaded = false;
  List allCakes = [];

  Cake _processCakes(Map cake, String id) {

    Map tempWeightPrice = {};
    Map tempWeightPriceOffer = {};
    for(var weights in cake["WeightPrice"]){
      tempWeightPrice[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
    }
    if (cake.containsKey("offerWeight")) {
      for(var weights in cake["offerWeight"]){
        tempWeightPriceOffer[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
      }
    } else {
      tempWeightPriceOffer = tempWeightPrice;
    }
    List<String> cakeImages = [];
    if (cake["Image"].runtimeType.toString() == "String") {
      cakeImages = ["https://res.cloudinary.com/maharani/image/upload/${cake["Image"].toString()}/image_asset/${cake}.jpg"];
    } else {
      for (var images in cake["Image"]) {
        if (images != "") {
          cakeImages.add(images.toString());

        }
      }
    }

    cakeImages.sort((a, b) => a.compareTo(b));

    // bool isFavourite = false;
    //
    // try {
    //   if (wishList!.firstWhere((element) => element.split("<sepMAIN>")[0] == cake.key).length > 0) {
    //     isFavourite = true;
    //   }
    // } catch(e) {
    //   isFavourite = false;
    // }

    bool isFavourite = wishList!.any((item) => item.contains(id));

    return Cake(
        firebaseId: id,
        imageUrl: cakeImages,
        name: cake["Name"],
        specs: cake["Specs"],
        number: cake["No"],
        weightPrice: tempWeightPrice,
        weightPriceOffer: tempWeightPriceOffer,
        offerAvailable: cake["offerApplicable"] ?? false,
        inStock: cake["inStock"] ?? true,
        description: cake["description"] ?? "",
        isFavourite: isFavourite
    );

  }

  getItemsFromFirebase() async{

    // final event = await referenceGlobal.once(DatabaseEventType.value);
    // Map dataSnapshot = event.snapshot.value as Map<dynamic, dynamic>;

    setState(() {
      loaded = false;
    });

    dynamic category = "";

    List allItems = [];

    for (var item in wishList!){

      if (item.split("<sepMAIN>")[10] == "cake") {
        try {
          category = categories.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[11]);

        } catch(e) {
          category = cakeCategories.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[11]);

        }
        dynamic childCategory = category.childCategories.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[12]);

        DatabaseEvent? event = await referenceGlobal
            .child("Categories")
            .child(category.firebaseId)
            .child("ChildCategories")
            .child(childCategory.firebaseId)
            .child("Items")// limit to the first 20 items
            .child(item.split("<sepMAIN")[0])
            .once(DatabaseEventType.value);

        Map? dataSnapshot = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;

        print(dataSnapshot);

        allItems.add(_processCakes(dataSnapshot, item.split("<sepMAIN")[0]));
      }

    }


    setState(() {
      allCakes = allItems;
    });

    setState(() {
      loaded = true;
    });


  }


  Widget _buildCartItem(String item, int index) {

    for (var k in categories) {
      print(k.firebaseId);
    }

    dynamic category = "";

    try {
      category = categories.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[11]);

    } catch(e) {
      category = cakeCategories.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[11]);

    }
    dynamic childCategory = category.childCategories.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[12]);

    print(category.firebaseId);
    print(childCategory.firebaseId);

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
                  child: item.split("<sepMAIN>")[10] == "cake" ?
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(cake: allCakes.firstWhere((element) => element.firebaseId == item.split("<sepMAIN>")[0]), categoryId: item.split("<sepMAIN>")[12], categoryMainId: item.split("<sepMAIN>")[11],)),);
                    },
                    child: CachedNetworkImage(
                      imageUrl: item.split("<sepMAIN>")[1].split(",")[0],
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: childCategory, food: childCategory.items[childCategory!.items.indexWhere((element) => element.firebaseId == item.split("<sepMAIN>")[0])], categoryMain: category,)),);
                    },
                    child: CachedNetworkImage(
                      imageUrl: "https://res.cloudinary.com/maharani/image/upload/${item.split("<sepMAIN>")[1]}/image_asset/${item.split("<sepMAIN>")[0]}.jpg",
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
                                      Text(
                                        "No. ${item.split("<sepMAIN>")[4]}",
                                        style: TextStyle(
                                            fontSize: 12,
                                        ),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        item.split("<sepMAIN>")[2],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      // order.category == null ? Column(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     // Text(
                                      //     //   order.cakeChildCategory!.name,
                                      //     //   style: TextStyle(
                                      //     //       fontSize: 10,
                                      //     //       fontWeight: FontWeight.w400),
                                      //     //   overflow: TextOverflow.ellipsis,
                                      //     // ),
                                      //     order.food == null ?
                                      //     Column(
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         Text(
                                      //           order.cake!.type.toString(),
                                      //           style: TextStyle(
                                      //               fontSize: 10,
                                      //               fontWeight: FontWeight.w400),
                                      //           overflow: TextOverflow.ellipsis,
                                      //         ),
                                      //         Text(
                                      //           order.cake!.weight.toString() + " Kg",
                                      //           style: TextStyle(
                                      //               fontSize: 10,
                                      //               fontWeight: FontWeight.w400),
                                      //           overflow: TextOverflow.ellipsis,
                                      //         ),
                                      //       ],
                                      //
                                      //     ) :
                                      //     Container(),
                                      //   ],
                                      // ) :
                                      Text(
                                        category.name,
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
                                    onPressed: () async{
                                      final prefs = await SharedPreferences.getInstance();
                                      final List<String>? items = prefs.getStringList("wishlist");

                                      if (items != null) {
                                        items.remove(items.firstWhere((element) => element.split("<sepMAIN>")[0] == item.split("<sepMAIN>")[0]));
                                      }
                                      wishList = items;
                                      await prefs.setStringList("wishlist", items!);
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
                                    child: item.split("<sepMAIN>")[10] == "cake" ? Text(
                                      'Rs. ${item.split("<sepMAIN>")[6].split("<sep>")[1].split(",")[0]}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ) : Text(
                                      'Rs. ${item.split("<sepMAIN>")[6]}',
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
    getItemsFromFirebase();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist(${wishList!.length})',
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
          wishList!.length > 0 ? ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index < wishList!.length) {
                  // Order order = currentUser.cart[index];
                  if (!loaded) {
                    return Container();
                  }
                  return _buildCartItem(wishList![index], index);
                }
                return Column(
                  children: [

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
              itemCount: wishList!.length + 1
          ) : Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/empty_cake.gif",
                    height: 200,
                  ),
                  const SizedBox(height: 10.0,),
                  Text("Your wish list is empty.", style: TextStyle(color: Colors.black, fontFamily: "AwanZaman", fontSize: 20.0),),
                ],
              ),
            ),
          ),

          !loaded ? ProgressDialog(message: "Loading Wish List",) : Container(),

          NavigationsBar(idScreen: "wishlist",),
        ],
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
