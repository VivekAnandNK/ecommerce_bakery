import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maharani_bakery_app/components/build_rating.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeItem.dart';
import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/screens/cart_screen.dart';
import 'package:maharani_bakery_app/screens/privacyPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/returnAndRefundPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
import 'package:maharani_bakery_app/screens/viewImage.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/Divider.dart';
import 'package:maharani_bakery_app/widgets/header_second.dart';
import 'package:maharani_bakery_app/widgets/navigationBar.dart';
import 'package:maharani_bakery_app/widgets/similiarCakeOrder.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/progressDialog.dart';
import 'cakeTypeScreen.dart';

class CakeItemScreen extends StatefulWidget {
  final Cake cake;
  final String categoryId;
  final String categoryMainId;

  const CakeItemScreen({Key? key, required this.cake, required this.categoryId, required this.categoryMainId}) : super(key: key);

  @override
  _CakeItemScreenState createState() => _CakeItemScreenState();
}

class _CakeItemScreenState extends State<CakeItemScreen> {
  bool isFavourite = false;
  List comments = [];
  bool commentsLoaded = true;
  bool addToCartClicked = false;
  bool commentAddContainer = false;
  double value = 1;
  double selectedWeight = 0.0;
  String selectedType = "Egg";
  String addToCartText = "Add to cart";
  Map selectedWeightBool = {};
  Map selectedTypeBool = {
    "Egg" : true,
    "Egg Less" : false
  };

  TextEditingController nameTextEditingController = new TextEditingController(text: currentUser.name);
  TextEditingController locationTextEditingController = new TextEditingController(text: currentUser.location);
  TextEditingController commentTextEditingController = new TextEditingController();

  String resultId = "";
  int orderCount = 1;

  _swapFavourite() async{

    showDialog(
        context: context, builder: (BuildContext context) {
      return ProgressDialog(message: "Updating Wishlist",);
    });

    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList("wishlist");

    if (isFavourite) {

      if (items != null) {
        items.remove(items.firstWhere((element) => element.split("<sepMAIN>")[0] == widget.cake.firebaseId));
      }
      wishList = items;
      await prefs.setStringList("wishlist", items!);

    } else {
      String favoriteCake = "${widget.cake.firebaseId}<sepMAIN>${widget.cake.imageUrl.join(',')}<sepMAIN>${widget.cake.name}<sepMAIN>${widget.cake.specs}<sepMAIN>${widget.cake.number}<sepMAIN>${widget.cake.weightPrice.entries.map((entry) => "${entry.key}<sep>${entry.value}").join(',')}<sepMAIN>${widget.cake.weightPriceOffer.entries.map((entry) => "${entry.key}<sep>${entry.value}").join(',')}<sepMAIN>${widget.cake.offerAvailable}<sepMAIN>${widget.cake.inStock}<sepMAIN>${widget.cake.description}<sepMAIN>cake<sepMAIN>${widget.categoryMainId}<sepMAIN>${widget.categoryId}";

      if (items == null) {
        await prefs.setStringList("wishlist", [favoriteCake]);
      } else {
        items.add(favoriteCake);
        wishList = items;
        // print("added")
        await prefs.setStringList("wishlist", items);
      }
      // await prefs.setStringList("favourites", favoriteCake);
    }

    // prefs.remove("wishlist");

    print(prefs.getStringList("wishlist"));

    setState(() {
      isFavourite = !isFavourite;
    });

    Navigator.of(context).pop();
  }

  void checkFavorites() {

    // final prefs = await SharedPreferences.getInstance();
    // final List<String>? items = prefs.getStringList("wishlist");

    if (wishList != null) {
      for (var item in wishList!) {
        print(item.split("<sepMAIN>")[0]);
        print(widget.cake.firebaseId);
        if (item.split("<sepMAIN>")[0] == widget.cake.firebaseId) {
          setState(() {
            isFavourite = true;
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedWeight = widget.cake.weightPrice.keys.toList()[0];
    selectedWeightBool[selectedWeight] = true;
    cakeType = "Egg";

    checkFavorites();

  }
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
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: 110.0,),
                    Stack(
                      children: [
                        Container(


                          child: ImageSlideshow(
                            width: double.infinity,
                            height: 300,
                            initialPage: 0,
                            indicatorColor: Colors.black,
                            indicatorBackgroundColor: Colors.white,
                            children: [
                              for(var elements=0; elements<widget.cake.imageUrl.length; elements++)
                                OptimizedCacheImage(
                                  imageBuilder: (context, imageProvider) => GestureDetector(
                                    onTap: () {
                                      elements == 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(imageUrl: widget.cake.imageUrl[elements], firebaseId: widget.cake.firebaseId.replaceAll(" ", ""), type: 'cake', item: widget.cake,),)) : Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(imageUrl: widget.cake.imageUrl[elements], firebaseId: widget.cake.firebaseId.replaceAll(" ", "") + elements.toString(), type: 'cake', item: widget.cake,),));
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  imageUrl: widget.cake.imageUrl[elements],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset("assets/images/load.gif"),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                            ],
                            onPageChanged: (value) {
                              // print('Page changed: $value');
                            },
                            autoPlayInterval: 3000,
                            isLoop: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                // Back to the Home screen
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                              IconButton(
                                // Add to or remove from favourite
                                  onPressed: _swapFavourite,
                                  icon: Icon(
                                    isFavourite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavourite
                                        ? Colors.red
                                        : Colors.white,
                                    size: 30.0,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.cake.name,
                                  style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Candarai"),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 6.0,
                          ),
                          widget.cake.description.split("//").length > 1 ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "--${widget.cake.description.split("//")[1]}--",
                              style: TextStyle(fontSize: 18, fontFamily: "Candarai", ),
                            ),
                          ) : Container(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0,),
                              Text(
                                "Weight",
                                style:
                                TextStyle(fontSize: 15, fontFamily: "Candarai"),
                              ),
                              SizedBox(height: 10.0,),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [

                                    for(var elements in widget.cake.weightPrice.entries)
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 35.0,
                                            child: TextButton(
                                              onPressed: (){
                                                setState(() {
                                                  selectedWeight = elements.key;
                                                  for(var weights in widget.cake.weightPrice.entries){
                                                    selectedWeightBool[weights.key] = false;
                                                  }
                                                  selectedWeightBool[selectedWeight] = true;
                                                });
                                              },
                                              child: Text("${elements.key} Kg", style: TextStyle(color: selectedWeightBool[elements.key] == null ? Colors.black : selectedWeightBool[elements.key] ? Colors.red : Colors.black, fontSize: 14.0)),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.grey.withOpacity(0.2),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    width: selectedWeightBool[elements.key] == null ? 1.0 : selectedWeightBool[elements.key] ? 2.0 : 1.0,
                                                    color: selectedWeightBool[elements.key] == null ? Colors.black : selectedWeightBool[elements.key] ? Colors.red : Colors.black,
                                                  ),
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Type",
                                style:
                                TextStyle(fontSize: 15, fontFamily: "Candarai"),
                              ),
                              SizedBox(height: 10.0,),

                              Row(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 35.0,
                                        child: TextButton(
                                          onPressed: (){
                                            setState(() {
                                              selectedType = "Egg";
                                              selectedTypeBool["Egg Less"] = false;

                                              selectedTypeBool["Egg"] = true;
                                            });
                                          },
                                          child: Text("Egg", style: TextStyle(color: selectedTypeBool["Egg"] == null ? Colors.black : selectedTypeBool["Egg"] ? Colors.red : Colors.black, fontSize: 14.0)),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.grey.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: selectedTypeBool["Egg"] == null ? 1.0 : selectedTypeBool["Egg"] ? 2.0 : 1.0,
                                                color: selectedTypeBool["Egg"] == null ? Colors.black : selectedTypeBool["Egg"] ? Colors.red : Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 35.0,
                                        child: TextButton(
                                          onPressed: (){
                                            setState(() {
                                              selectedType = "Egg Less";
                                              selectedTypeBool["Egg"] = false;

                                              selectedTypeBool["Egg Less"] = true;
                                            });
                                          },
                                          child: Text("Egg Less", style: TextStyle(color: selectedTypeBool["Egg Less"] == null ? Colors.black : selectedTypeBool["Egg Less"] ? Colors.red : Colors.black, fontSize: 14.0)),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.grey.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: selectedTypeBool["Egg Less"] == null ? 1.0 : selectedTypeBool["Egg Less"] ? 2.0 : 1.0,
                                                color: selectedTypeBool["Egg Less"] == null ? Colors.black : selectedTypeBool["Egg Less"] ? Colors.red : Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),

                              // Container(
                              //   decoration: BoxDecoration(
                              //       color: Colors.grey[500],
                              //     borderRadius: BorderRadius.circular(5.0),
                              //   ),
                              //   width: 200.0,
                              //   height: 35.0,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //     children: [
                              //       Container(
                              //         child: Text(
                              //           "Egg",
                              //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              //         ),
                              //       ),
                              //       VerticalDivider(
                              //         color: Colors.black,
                              //         thickness: 1,
                              //         width: 1,
                              //       ),
                              //       Text(
                              //         "Egg Less",
                              //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              //
                              //       ),
                              //     ],
                              //   ),
                              //
                              // ),


                              SizedBox(
                                height: 20.0,
                              ),

                              widget.cake.inStock ? widget.cake.offerAvailable ? Row(
                                children: [

                                  Text(
                                    "\u{20B9} ${(orderCount == 0 ? selectedType == "Egg" ? widget.cake.weightPrice[selectedWeight] : widget.cake.weightPrice[selectedWeight] + 100 * selectedWeight : selectedType == "Egg" ? widget.cake.weightPrice[selectedWeight] * orderCount : widget.cake.weightPrice[selectedWeight] * orderCount + 100 * selectedWeight).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                  SizedBox(width: 5.0,),

                                  Text(
                                    "\u{20B9} ${(orderCount == 0 ? selectedType == "Egg" ? widget.cake.weightPriceOffer[selectedWeight] : widget.cake.weightPriceOffer[selectedWeight] + 100 * selectedWeight : selectedType == "Egg" ? widget.cake.weightPriceOffer[selectedWeight] * orderCount : widget.cake.weightPriceOffer[selectedWeight] * orderCount + 100 * selectedWeight).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),

                                  SizedBox(width: 5.0,),



                                  // Text(
                                  //   "${(((widget.cake.weightPrice[selectedWeight] - widget.cake.weightPriceOffer[selectedWeight]) /  widget.cake.weightPrice[selectedWeight]) * 100).toInt()}% OFF",
                                  //   style: TextStyle(
                                  //     fontSize: 20.0,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Colors.green,
                                  //   ),
                                  // ),


                                ],
                              ) : Row(
                                children: [
                                  Text(
                                    "\u{20B9} ${(orderCount == 0 ? selectedType == "Egg" ? widget.cake.weightPrice[selectedWeight] : widget.cake.weightPrice[selectedWeight] + 100 * selectedWeight : selectedType == "Egg" ? widget.cake.weightPrice[selectedWeight] * orderCount : widget.cake.weightPrice[selectedWeight] * orderCount + 100 * selectedWeight).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal
                                    ),
                                  ),
                                ],
                              ) : Row(
                                children: [
                                  Text(
                                    'OUT OF STOCK',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),

                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                          width: addToCartClicked ? 2.0 : 1.0,
                                          color: addToCartClicked ? Colors.red : Colors.black,
                                        )
                                    ),
                                    child: GestureDetector(
                                      child:  Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(addToCartText, style: TextStyle(color: addToCartClicked ? Colors.red : Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      onTap: () {
                                        if (addToCartClicked) {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (_) => CartScreen()));
                                        } else {
                                          if(orderCount < 1){
                                            displayToastMessage("Please order at least 1 quantity", context);
                                          }
                                          else{
                                            print(selectedWeight);
                                            print(widget.cake.weightPriceOffer);

                                            print(widget.cake.weightPriceOffer[selectedWeight]);

                                            if (widget.cake.inStock) {
                                              dynamic category = cakeCategories.firstWhere((element) => element.firebaseId == widget.categoryMainId);
                                              dynamic childCategory = category.childCategories.firstWhere((element) => element.firebaseId == widget.categoryId);
                                              currentUser.cart.add(
                                                  Order(
                                                    // cakeChildCategory: widget.category,
                                                    cake: CakeItem(
                                                      firebaseId: widget.cake.firebaseId,
                                                      identifierString: "${widget.categoryId}<sep>${widget.categoryMainId}",
                                                      id: widget.cake.number,
                                                      type: selectedType,
                                                      imageUrl: widget.cake.imageUrl.length > 0 ? widget.cake.imageUrl[0] : "",
                                                      weight: selectedWeight,
                                                      name: widget.cake.name,

                                                      price: selectedType == "Egg" ? widget.cake.weightPriceOffer[selectedWeight] : widget.cake.weightPrice[selectedWeight] + 100 * selectedWeight, typeMain: 'cake',
                                                    ),
                                                    cakeChildCategory: childCategory,
                                                    date: DateTime.now().toString().split(" ")[0],
                                                    quantity: orderCount,
                                                    categoryMain: category,
                                                    cakeGlobal: widget.cake
                                                  )
                                              );
                                              setState(() {
                                                addToCartClicked = true;
                                                addToCartText = "VIEW CART";
                                              });
                                              displayToastMessage("Added to cart !!", context);
                                            } else {
                                              displayToastMessage("Out of stock. Cannot add to cart !!", context);

                                            }


                                          }
                                        }


                                      },
                                    ),
                                  ),

                                  // SizedBox(
                                  //   width: 100,
                                  //   height: 30,
                                  //   child: ElevatedButton(
                                  //     onPressed: () {
                                  //       if(orderCount < 1){
                                  //         displayToastMessage("Please order at least 1 quantity", context);
                                  //       }
                                  //       else{
                                  //         print(cakeType);
                                  //
                                  //         if (widget.cake.inStock) {
                                  //           currentUser.cart.add(
                                  //               Order(
                                  //                   cakeChildCategory: widget.category,
                                  //                   cake: CakeItem(
                                  //                     firebaseId: widget.cake.firebaseId,
                                  //                     id: widget.cake.number,
                                  //                     type: selectedType,
                                  //                     imageUrl: "",
                                  //                     weight: selectedWeight,
                                  //                     name: widget.cake.name,
                                  //                     price: selectedType == "Egg" ? widget.cake.weightPriceOffer[selectedWeight] : widget.cake.weightPrice[selectedWeight] + 100 * selectedWeight, typeMain: 'cake',
                                  //                   ),
                                  //                   date: DateTime.now().toString().split(" ")[0],
                                  //                   quantity: orderCount, categoryMain: widget.categoryMain
                                  //               )
                                  //           );
                                  //           displayToastMessage("Added to cart !!", context);
                                  //         } else {
                                  //           displayToastMessage("Out of stock. Cannot add to cart !!", context);
                                  //
                                  //         }
                                  //
                                  //
                                  //       }
                                  //
                                  //     },
                                  //     style: ButtonStyle(
                                  //       backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                  //       minimumSize: MaterialStateProperty.resolveWith((states) => const Size(double.infinity, 50)),
                                  //       shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       )),
                                  //       side: MaterialStateProperty.resolveWith((states) => BorderSide(color: Colors.grey)),
                                  //     ),
                                  //     child: Text(
                                  //       'VIEW',
                                  //       style: TextStyle(
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  Container(
                                    width: 140,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.black,
                                        )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: Icon(Icons.remove),
                                          onTap: () {
                                            setState(() {
                                              if(orderCount > 0){
                                                orderCount--;
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          "$orderCount",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                        ),
                                        GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            setState(() {
                                              if(orderCount >= 0){
                                                orderCount++;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),


                    SizedBox(
                      height: 20.0,
                    ),
                    DividerWidget(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Specifications',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    DividerWidget(),

                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Table(
                            defaultColumnWidth: FixedColumnWidth(200.0),
                            border: TableBorder.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 0.5,
                            ),
                            children: [
                              TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Item No"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${widget.cake.number}"),
                                    )
                                  ]
                              ),
                              for(var elements in widget.cake.specs.entries)
                                TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${elements.key}"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${elements.value}"),
                                      )
                                    ]
                                ),
                              TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Egg Less"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("${selectedType == "Egg" ? "No" : "Yes"}"),
                                    )
                                  ]
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    DividerWidget(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.cake.description == "" ? "" : "Please Note : ",
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Candarai"),
                        ),
                      ),
                    ),
                    for (var k=0; k<widget.cake.description.split("//")[0].split("*").length; k++)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 3.0, right: 8.0),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            widget.cake.description.split("//")[0] == "" ? "" : "• ${widget.cake.description.split("//")[0].split("*")[k]}",
                            style: TextStyle(fontSize: 15, fontFamily: "Candarai", ),
                          ),
                        ),
                      ),
                    DividerWidget(),

                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Comments',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    DividerWidget(),
                    commentsLoaded ?
                    comments.isNotEmpty ?
                    Container(
                      height: 250.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: List.generate(comments.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${comments[index]["Name"]}",
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                  Text("${comments[index]["Location"]}"),
                                  SizedBox(height: 8.0,),
                                  Rating(rating: int.parse(comments[index]["Rating"])),
                                  SizedBox(height: 8.0,),
                                  Text("${comments[index]["Comment"]}"),
                                  SizedBox(height: 20.0,),

                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50.0,),
                        Container(
                          child: Text("No comments"),
                        ),
                      ],
                    ) :
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                        ],
                      ),
                    ),
                    DividerWidget(),
                    SizedBox(height: 10.0,),
                    Text(
                      'Similiar Cakes',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    SimilarCakeOrder(cakeChildCategoryId: widget.categoryId),
                    // SimilarCakeOrder(cakeCategory: widget.category, cakeCategoryMain: widget.categoryMain,),

                    // BottomWidget(),

                    SizedBox(height: 60.0,),

                  ],
                ),
              ),
            ),
            HeaderSecond(idScreen: "header", scaffoldKey: _scaffoldKey,),
            NavigationsBar(idScreen: "cakeItem"),
            commentAddContainer ?
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  width: double.infinity,
                  height: 380.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
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
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: (){
                                  setState(() {
                                    commentAddContainer = false;
                                  });

                                },
                                child: Icon(Icons.close, color: Colors.black,)
                            ),
                            Text(
                              "Add a Comment",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),



                          ],
                        ),
                        SizedBox(height: 20.0,),
                        DividerWidget(),
                        DividerWidget(),
                        SizedBox(height: 10.0,),
                        TextField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        TextField(
                          controller: locationTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Location",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Rating : ",
                              style: TextStyle(fontSize: 15.0),),
                            SizedBox(width: 10.0,),

                            RatingStars(
                              value: value,
                              onValueChanged: (v) {
                                //
                                setState(() {
                                  value = v;
                                });
                              },
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 20,
                              maxValue: 5,
                              starSpacing: 2,
                              starOffColor: Colors.black26,
                              starColor: Colors.black,
                            ),
                          ],
                        ),
                        TextField(
                          controller: commentTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Comment",
                            labelStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () async{
                                  // String commentsTemp = "";
                                  //
                                  // if(nameTextEditingController.text.trim() == ""){
                                  //   displayToastMessage("Name cannot be empty", context);
                                  // }
                                  // else if(locationTextEditingController.text.trim() == ""){
                                  //   displayToastMessage("Location cannot be empty", context);
                                  // }
                                  // else if(commentTextEditingController.text.trim() == ""){
                                  //   displayToastMessage("Comment cannot be empty", context);
                                  // }
                                  // else{
                                  //   for(var elements in comments){
                                  //     commentsTemp += "<lsep>${elements["Name"]}<sep>${elements["Location"]}<sep>${elements["Rating"]}<sep>${elements["Comment"]}";
                                  //   }
                                  // }
                                  //
                                  // commentsTemp += "<lsep>${nameTextEditingController.text.trim()}<sep>${locationTextEditingController.text.trim()}<sep>${value.toString().split(".")[0]}<sep>${commentTextEditingController.text.trim()}";
                                  //
                                  //
                                  // setState(() {
                                  //   commentAddContainer = false;
                                  // });
                                  //
                                  //
                                  // // SharedPreferences preferences = await SharedPreferences();
                                  //
                                  // Future.delayed(Duration(seconds: 2));
                                  //
                                  // getComments();

                                },
                                child: Icon(Icons.check, color: Colors.black,)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ) :
            Container(),
          ]
      ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: Visibility(
      //   visible: !commentAddContainer,
      //   child: Padding(
      //     padding: const EdgeInsets.only(bottom: 40.0),
      //     child: new FloatingActionButton(
      //         elevation: 0.0,
      //         child: new Icon(Icons.comment),
      //         backgroundColor: Colors.black,
      //         onPressed: () {
      //           setState(() {
      //             commentAddContainer = true;
      //           });
      //
      //         }
      //     ),
      //   ),
      // ),
    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
