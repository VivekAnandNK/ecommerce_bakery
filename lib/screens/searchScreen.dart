import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/screens/cart_screen.dart';
import 'package:maharani_bakery_app/screens/privacyPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/returnAndRefundPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/Divider.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cakeItemScreen.dart';
import 'cakeTypeScreen.dart';
import 'itemScreen.dart';

class SearchScreen extends StatefulWidget {
  static const String idScreen = "search";
  final List allData;
  const SearchScreen({Key? key, required this.allData}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const String idScreen = "home";

  TextEditingController searchTextEditingController = new TextEditingController();

  List cakeCategory = [];
  List category = [];
  List searchResults = [];
  bool loading = false;

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

  void createData(List data){
    setState(() {
      cakeCategory = data[0];
      category = data[1];
    });

  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createData(widget.allData);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
    super.dispose();
    // SystemChrome.setEnabledSystemUIOverlays([]);


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
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: 160.0,),
                  loading ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.black,),
                  ) : Container(),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchTextEditingController.text.trim() == "" ? 0 : searchResults.length,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            // showDialog(
                            //     context: context, builder: (BuildContext context) {
                            //   return AlertDialog(
                            //     content: Row(
                            //       children: [
                            //         CircularProgressIndicator()
                            //       ],
                            //     ),
                            //   );
                            // }
                            // );
                            if(searchResults[index]["Cake"] == null){
                              print(searchResults[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: searchResults[index]["ChildCategory"], food: searchResults[index]["Food"], categoryMain: searchResults[index]["Category"],)),);
                            }
                            else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(cake: searchResults[index]["Cake"], categoryId: searchResults[index]["Category"], categoryMainId: searchResults[index]["ChildCategory"],)),);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: OptimizedCacheImage(
                                          imageUrl: searchResults[index]["Cake"] == null ? "https://res.cloudinary.com/maharani/image/upload/${searchResults[index]["Food"].imageUrl}/image_asset/${searchResults[index]["Food"].firebaseId}.jpg" : searchResults[index]["Cake"].imageUrl[0],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${searchResults[index]["Cake"] == null ? searchResults[index]["Food"].number : searchResults[index]["Cake"].number}. ${searchResults[index]["Cake"] == null ? searchResults[index]["Food"].name : searchResults[index]["Cake"].name}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Candarai"
                                                ),
                                              ),
                                              Text(
                                                "\u{20B9} ${searchResults[index]["Cake"] == null ? searchResults[index]["Food"].price : searchResults[index]["Cake"].weightPrice[searchResults[index]["Cake"].weightPrice.keys.toList()[0]]}",
                                                style: TextStyle(
                                                  color: Color(0xFF3F3F42),
                                                  fontSize: 17.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                DividerWidget(),
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                  SizedBox(height: 80.0,),

                ],
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: -30,
              child: Container(
                height: 185.0,
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
                              IconButton(
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openDrawer();

                                  },
                                  icon: Icon(
                                    Icons.menu,
                                    size: 30,
                                    color: brandGold,
                                  )),

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
                              TextButton(
                                onPressed: () => Navigator.push(
                                    context, MaterialPageRoute(builder: (_) => CartScreen())),
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 30,
                                      color: brandGold,
                                    ),
                                  ],
                                ),
                              ),
                              // Search screen
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 13.0,
                              height: 1.0
                          ),
                          onChanged: (val){

                          },
                          autofocus: true,
                          controller: searchTextEditingController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Search Cakes, Chocolates..',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            focusedBorder: _focus_and_enabled_border_style,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.8),
                            ),
                            enabledBorder: _focus_and_enabled_border_style,
                            suffixIcon: GestureDetector(
                              onTap: (){
                                searchTextEditingController.text = "";
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.black38,
                                //size: 20.0,
                              ),
                            ),
                          ),
                          onSubmitted: (val) async{

                            int count = 0;

                            setState(() {
                              searchResults = [];
                              loading = true;
                            });

                            DatabaseEvent? event = await referenceGlobal
                                .child("Categories")
                                .once(DatabaseEventType.value);

                            Map? dataSnapshot = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;

                            for (var categoriesTemp in dataSnapshot.entries) {
                              if (categoriesTemp.value.containsKey("ChildCategories")) {
                                for (var childCat in categoriesTemp.value["ChildCategories"].entries) {
                                  if (childCat.value.containsKey("Items")) {
                                    for (var items in childCat.value["Items"].entries) {

                                      if ("CakesCategories" == categoriesTemp.key) {
                                        // print(categories.key);
                                        if (items.value["Name"].toLowerCase().contains(val.toLowerCase()) || items.value["No"].toString() == val) {
                                          Map tempWeightPrice = {};
                                          Map tempWeightPriceOffer = {};
                                          for(var weights in items.value["WeightPrice"]){
                                            tempWeightPrice[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
                                          }
                                          if (items.value.containsKey("offerWeight")) {
                                            for(var weights in items.value["offerWeight"]){
                                              tempWeightPriceOffer[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
                                            }
                                          } else {
                                            tempWeightPriceOffer = tempWeightPrice;
                                          }
                                          List<String> cakeImages = [];
                                          if (items.value["Image"].runtimeType.toString() == "String") {
                                            cakeImages = ["https://res.cloudinary.com/maharani/image/upload/${items.value["Image"].toString()}/image_asset/${items.key}.jpg"];
                                          } else {
                                            for (var images in items.value["Image"]) {
                                              if (images != "") {
                                                cakeImages.add(images.toString());

                                              }
                                            }
                                          }

                                          cakeImages.sort((a, b) => a.compareTo(b));

                                          count += 1;
                                          if (count < 20) {

                                            // bool isFavourite = false;
                                            //
                                            // try {
                                            //   if (wishList!.firstWhere((element) => element.split("<sepMAIN>")[0] == items.key).length > 0) {
                                            //     isFavourite = true;
                                            //   }
                                            // } catch(e) {
                                            //   isFavourite = false;
                                            // }

                                            bool isFavourite = wishList!.any((item) => item.contains(items.key));

                                            setState(() {
                                              searchResults.add({
                                                "Category" : categoriesTemp.key,
                                                "ChildCategory" : childCat.key,
                                                "Cake" : Cake(
                                                    firebaseId: items.key,
                                                    imageUrl: cakeImages,
                                                    name: items.value["Name"],
                                                    specs: items.value["Specs"],
                                                    number: items.value["No"],
                                                    weightPrice: tempWeightPrice,
                                                    weightPriceOffer: tempWeightPriceOffer,
                                                    offerAvailable: items.value["offerApplicable"] ?? false,
                                                    inStock: items.value["inStock"] ?? true,
                                                    description: items.value["description"] ?? "", isFavourite: isFavourite
                                                )
                                              });
                                            });
                                          }
                                        }
                                      } else {
                                        if (items.value["Name"].toLowerCase().contains(val.toLowerCase()) || items.value["No"].toString() == val) {
                                          count += 1;
                                          if (count < 20) {
                                            Category categoryWhole = categories.firstWhere((element) => element.firebaseId == categoriesTemp.key);

                                            // bool isFavourite = false;
                                            //
                                            // try {
                                            //   if (wishList!.firstWhere((element) => element.split("<sepMAIN>")[0] == items.key).length > 0) {
                                            //     isFavourite = true;
                                            //   }
                                            // } catch(e) {
                                            //   isFavourite = false;
                                            // }

                                            bool isFavourite = wishList!.any((item) => item.contains(items.key));

                                            setState(() {
                                              searchResults.add({
                                                "Category" : categoryWhole,
                                                "ChildCategory" : categoryWhole.childCategories.firstWhere((element) => element.firebaseId == childCat.key),
                                                "Food" : Food(
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
                                              });
                                            });
                                          }

                                        }

                                      }

                                    }
                                  }

                                }
                              }

                            }

                            dataSnapshot = null;
                            event = null;

                            print(searchResults );
                            // setState(() {
                            //   searchResults = [];
                            //   for(var elements in cakeCategory){
                            //     for (var childCat in elements.childCategories) {
                            //       for(var cakes in childCat.items){
                            //         if("${cakes.number}${cakes.name.toString().toLowerCase()}".contains(val.toLowerCase())){
                            //           searchResults.add({"Cake" : cakes});
                            //         }
                            //       }
                            //     }
                            //   }
                            //   for(var elements in category){
                            //     for (var childCat in elements.childCategories) {
                            //       for(var food in childCat.items){
                            //         if("${food.number}${food.name.toString().toLowerCase()}".contains(val.toLowerCase())){
                            //           searchResults.add({"Category" : childCat, "Food" : food, "CategoryMain" : elements});
                            //         }
                            //       }
                            //     }
                            //   }
                            // });
                            setState(() {
                              loading = false;
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ]
      ),

    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

