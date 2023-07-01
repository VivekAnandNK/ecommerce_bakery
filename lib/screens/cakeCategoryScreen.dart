import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/navigationBar.dart';
import 'package:maharani_bakery_app/components/build_rating.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/screens/itemScreen.dart';
import 'package:maharani_bakery_app/widgets/Divider.dart';
import 'package:maharani_bakery_app/widgets/add_item.dart';
import 'package:maharani_bakery_app/widgets/rounded_button.dart';
import 'package:maharani_bakery_app/widgets/verticalDivider.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:maharani_bakery_app/screens/cart_screen.dart';
import 'package:maharani_bakery_app/screens/privacyPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/returnAndRefundPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
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
import '../models/cakeChildCategory.dart';
import '../widgets/header_second.dart';
import 'cakeItemScreen.dart';
import 'cakeTypeScreen.dart';
import 'cart_screen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
class CakeCategoryScreen extends StatefulWidget {
  final String childCategoryId;
  final String categoryId;

  const CakeCategoryScreen({Key? key, required this.childCategoryId, required this.categoryId}) : super(key: key);

  @override
  _CakeCategoryScreenState createState() => _CakeCategoryScreenState();
}

class _CakeCategoryScreenState extends State<CakeCategoryScreen> {

  ScrollController _scrollController = ScrollController();
  DefaultCacheManager _cacheManager = DefaultCacheManager();
  bool isFavourite = false;
  bool loading = false;
  bool endOfList = false;
  List<dynamic> items = List.empty(growable: true).obs;
  bool highToLow = false;
  bool lowToHigh = false;
  String _selectedSortOption = 'Price: High to Low';
  final List<String> _sortOptions = [
    'Price: High to Low',
    'Price: Low to High',
  ];

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

  List _processCakes(Map cakeMap) {
    List newItems = [];
    for (var cake in cakeMap.entries) {
      Map tempWeightPrice = {};
      Map tempWeightPriceOffer = {};
      for(var weights in cake.value["WeightPrice"]){
        tempWeightPrice[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
      }
      if (cake.value.containsKey("offerWeight")) {
        for(var weights in cake.value["offerWeight"]){
          tempWeightPriceOffer[double.parse(weights.split("<sep>")[0])] = double.parse(weights.split("<sep>")[1]);
        }
      } else {
        tempWeightPriceOffer = tempWeightPrice;
      }
      List<String> cakeImages = [];
      if (cake.value["Image"].runtimeType.toString() == "String") {
        cakeImages = ["https://res.cloudinary.com/maharani/image/upload/${cake.value["Image"].toString()}/image_asset/${cake.key}.jpg"];
      } else {
        for (var images in cake.value["Image"]) {
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

      bool isFavourite = wishList!.any((item) => item.contains(cake.key));

      newItems.add(
          Cake(
              firebaseId: cake.key,
              imageUrl: cakeImages,
              name: cake.value["Name"],
              specs: cake.value["Specs"],
              number: cake.value["No"],
              weightPrice: tempWeightPrice,
              weightPriceOffer: tempWeightPriceOffer,
              offerAvailable: cake.value["offerApplicable"] ?? false,
              inStock: cake.value["inStock"] ?? true,
              description: cake.value["description"] ?? "",
              isFavourite: isFavourite
          )
      );
    }

    return newItems;
  }

  Future<void> _loadMoreItems() async{
    setState(() {
      endOfList = false;
    });
    List<dynamic> newItems = [];
    setState(() {
      loading = true;
    });

    DatabaseEvent? event = await referenceGlobal
        .child("Categories")
        .child("CakesCategories")
        .child("ChildCategories")
        .child(widget.childCategoryId)
        .child("Items")// limit to the first 20 items
        .once(DatabaseEventType.value);

    Map? dataSnapshot = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;

    List? allItems = _processCakes(dataSnapshot);
    dataSnapshot = null;
    allItems.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));


    if (lowToHigh) {
      allItems.sort((a, b) => a.weightPriceOffer[a.weightPriceOffer.keys.toList()[0]].compareTo(b.weightPriceOffer[b.weightPriceOffer.keys.toList()[0]]));
    }

    if (highToLow) {
      allItems.sort((a, b) => b.weightPriceOffer[b.weightPriceOffer.keys.toList()[0]].compareTo(a.weightPriceOffer[a.weightPriceOffer.keys.toList()[0]]));
    }

    if (allItems.length > items.length + 20) {
      newItems = allItems.sublist(items.length, items.length + 20);

    } else {
      newItems = allItems.sublist(items.length, allItems.length);

    }
    allItems = null;

    // setState(() {
      items.addAll(newItems);
    // });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    // widget.category.items.sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));
    //
    // setState(() {
    //   if (widget.category.items.length > 20) {
    //     items = widget.category.items.sublist(0, 20);
    //
    //   } else {
    //     items = widget.category.items;
    //   }
    // });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {

        await _loadMoreItems();


      }
    });
  }

  Widget _buildMenu(BuildContext context, Cake menuItem, int index, int length) {
    // print(length % 2 != 0 && index == length - 2);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: index < 2  ? Border(
          right: BorderSide(
              color: Colors.black12.withOpacity(0.2)
          )

        ):index > length-2  ?  Border(
            right: BorderSide(
                color: Colors.black12.withOpacity(0.2)
            )

        ):  Border.all(color: Colors.black12.withOpacity(0.1))
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //     image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${menuItem.imageUrl}/image_asset/${menuItem.firebaseId}.jpg"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15.0)
              ),
              child: OptimizedCacheImage(
                imageUrl: menuItem.imageUrl[0],
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),

                placeholder: (context, url) => Image.asset("assets/images/load.gif"),
              ),
            ),
            SizedBox(height: 20.0,),
            Column(
              children: [

                Text(
                  "${menuItem.name}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Candarai"
                  ),
                  textAlign: TextAlign.center,

                ),
                SizedBox(height: 5.0,),

                menuItem.inStock ? !menuItem.offerAvailable ?
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\u{20B9} ${menuItem.weightPrice[menuItem.weightPrice.keys.toList()[0]]}',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Text(
                        '\u{20B9} ${menuItem.weightPriceOffer[menuItem.weightPriceOffer.keys.toList()[0]]}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5.0,),

                      // Text(
                      //   '${(((menuItem.weightPrice[menuItem.weightPrice.keys.toList()[0]] - menuItem.weightPriceOffer[menuItem.weightPriceOffer.keys.toList()[0]]) / menuItem.weightPrice[menuItem.weightPrice.keys.toList()[0]]) * 100).toInt()}% OFF',
                      //   style: TextStyle(
                      //     color: Colors.green,
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),

                    ],
                  ),
                ) : Text(
                  '\u{20B9} ${menuItem.weightPrice[menuItem.weightPrice.keys.toList()[0]]}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ) : Text(
                  'OUT OF STOCK',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
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
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: 130.0,),
                 Obx(() => GridView.builder(
                     key: UniqueKey(),
                     itemCount: items.length,
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,mainAxisExtent: 300),
                     itemBuilder: (BuildContext context, int index) {
                       return GestureDetector(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(categoryId: widget.childCategoryId, cake: items[index], categoryMainId: widget.categoryId,)),);

                         },
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Flexible(
                               child: _buildMenu(
                                   context,
                                   items[index],
                                   index,
                                   items.length
                               ),
                             ),
                           ],
                         ),
                       );
                     })),

                  // for(var index=0; index<items.length; index+=2)...{
                  //
                  //   IntrinsicHeight(
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //             child: GestureDetector(
                  //               onTap: (){
                  //                 Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(categoryId: widget.childCategoryId, cake: items[index], categoryMainId: widget.categoryId,)),);
                  //
                  //               },
                  //               child: _buildMenu(
                  //                   context,
                  //                   items[index],
                  //                   index,
                  //                   items.length
                  //               ),
                  //             )
                  //         ),
                  //
                  //         VerticalDividerWidget(),
                  //         items.length - 1 != index ?
                  //         Expanded(
                  //           child: GestureDetector(
                  //             onTap: (){
                  //               Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(categoryId: widget.childCategoryId, cake: items[index + 1], categoryMainId: widget.categoryId,)),);
                  //
                  //
                  //             },
                  //             child: _buildMenu(
                  //                 context,
                  //                 items[index+1],
                  //                 index + 1,
                  //                 items.length
                  //             ),
                  //           ),
                  //         ) :
                  //         Expanded(child: Container()),
                  //       ],
                  //     ),
                  //   )
                  // },

                  SizedBox(height: 20.0,),

                  loading ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ) : Container(),

                  SizedBox(height: 20.0,),

                  Center(
                    child: Text(
                      "**",
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 80.0,),

                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 35.0),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10.0,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],

                  // border: Border(
                  //   bottom: BorderSide(
                  //     color: brandGold,
                  //     width: 1.0, // Customize the border width here
                  //   ),
                  // ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _scrollController.animateTo(
                            0.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Center(
                          child: Text(
                            'GO TOP',
                            style: TextStyle(
                                fontSize: 13.0,
                                color: brandGold
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(color: brandGold, width: 1.0,),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showSortOptions();
                        },
                        child: Center(
                          child: Text(
                            'SORT',
                            style: TextStyle(
                                fontSize: 13.0,
                                color: brandGold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          HeaderSecond(idScreen: "header", scaffoldKey: _scaffoldKey,),
          NavigationsBar(idScreen: "category"),

        ],
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: brandGold,
              width: 1.0, // Customize the border width here
            ),
          ),
          backgroundColor: Colors.black,
          title: Text('Sort Options', style: TextStyle(color: brandGold),),
          content: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                // border: Border.all(
                //   color: brandGold,
                //   width: 2.0, // Customize the border width here
                // ),
              ),
              width: double.maxFinite,
              height: 120.0,
              child: Column(
                children: [
                  // Container(color: brandGold, height: 1.0,),

                  ListTile(
                    title: Text("Price: High to Low", style: TextStyle(color: brandGold),),
                    onTap: () async{

                      setState(() {
                        highToLow = true;
                        lowToHigh = false;
                      });

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                            backgroundColor: Colors.black,
                              content: Row(
                                children: [
                                  Spacer(),
                                  CircularProgressIndicator(color: brandGold),
                                  Spacer()
                                ],
                              ),
                            );
                          }
                      );

                      DatabaseEvent? event = await referenceGlobal
                          .child("Categories")
                          .child("CakesCategories")
                          .child("ChildCategories")
                          .child(widget.childCategoryId)
                          .child("Items")
                          .once(DatabaseEventType.value);

                      Map? dataSnapshot = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;

                      List? allItems = _processCakes(dataSnapshot);
                      dataSnapshot = null;
                      allItems.sort((a, b) => b.weightPriceOffer[b.weightPriceOffer.keys.toList()[0]].compareTo(a.weightPriceOffer[a.weightPriceOffer.keys.toList()[0]]));

                      setState(() {
                        if (allItems.length > 20) {
                          items = allItems.sublist(0, 20);

                        } else {
                          items = allItems;

                        }

                        _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(color: brandGold, height: 0.5,),
                  ListTile(
                    title: Text("Price: Low to High", style: TextStyle(color: brandGold),),
                    onTap: () async {

                      setState(() {
                        highToLow = false;
                        lowToHigh = true;
                      });

                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              content: Row(
                                children: [
                                  Spacer(),
                                  CircularProgressIndicator(color: brandGold),
                                  Spacer()
                                ],
                              ),
                            );
                          }
                      );

                      DatabaseEvent? event = await referenceGlobal
                          .child("Categories")
                          .child("CakesCategories")
                          .child("ChildCategories")
                          .child(widget.childCategoryId)
                          .child("Items")
                          .once(DatabaseEventType.value);

                      Map? dataSnapshot = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;

                      List? allItems = _processCakes(dataSnapshot);
                      dataSnapshot = null;
                      allItems.sort((a, b) => a.weightPriceOffer[a.weightPriceOffer.keys.toList()[0]].compareTo(b.weightPriceOffer[b.weightPriceOffer.keys.toList()[0]]));

                      // print(widget.category.items[0].weightPriceOffer[widget.category.items[0].weightPriceOffer.keys.toList()[0]]);

                      setState(() {
                        if (allItems.length > 20) {
                          items = allItems.sublist(0, 20);

                        } else {
                          items = allItems;

                        }

                        _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                  // Container(color: brandGold, height: 1.0,),

                ],
              )
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: _sortOptions.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return ListTile(
            //       title: Text(_sortOptions[index], style: TextStyle(color: brandGold),),
            //       onTap: () {
            //         setState(() {
            //           _selectedSortOption = _sortOptions[index];
            //         });
            //         Navigator.of(context).pop();
            //       },
            //     );
            //   },
            // ),
          ),
        );
      },
    );
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
