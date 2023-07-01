import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/childCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/screens/cart_screen.dart';
import 'package:maharani_bakery_app/screens/itemScreen.dart';
import 'package:maharani_bakery_app/screens/privacyPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/returnAndRefundPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/header_second.dart';
import 'package:maharani_bakery_app/widgets/navigationBar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cakeTypeScreen.dart';
import 'cart_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Category categoryMain;

  final ChildCategory category;

  const CategoryScreen(
      {Key? key, required this.category, required this.categoryMain})
      : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool isFavourite = false;
  bool loading = false;
  bool endOfList = false;
  List<dynamic> items = [];
  ScrollController _scrollController = ScrollController();

  final _decorationShade = BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black87.withOpacity(0.3),
            Colors.black54.withOpacity(0.3),
            Colors.black38.withOpacity(0.3),
          ],
          stops: [
            0.1,
            0.4,
            0.6,
            0.9
          ]));

  _swapFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  Future<void> _loadMoreItems() async {
    setState(() {
      endOfList = false;
    });
    List<dynamic> newItems = [];
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    if (widget.category.items.length > items.length + 20) {
      newItems = widget.category.items.sublist(items.length, items.length + 20);
    } else {
      newItems = widget.category.items
          .sublist(items.length, widget.category.items.length);
    }

    setState(() {
      items.addAll(newItems);
    });


    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.category.items
        .sort((a, b) => int.parse(a.number).compareTo(int.parse(b.number)));

    setState(() {
      if (widget.category.items.length > 20) {
        items = widget.category.items.sublist(0, 20);
      } else {
        items = widget.category.items;
      }
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (items.length != widget.category.items.length) {
          await _loadMoreItems();
        } else {
          setState(() {
            endOfList = true;
          });
        }
      }
    });
  }

  Widget _buildMenu(
      BuildContext context, Food menuItem, int index, int length) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: index < 2
              ? Border(
                  right: BorderSide(color: Colors.black12.withOpacity(0.2)))
              : index > length - 2
                  ? Border(
                      right: BorderSide(color: Colors.black12.withOpacity(0.2)))
                  : Border.all(color: Colors.black12.withOpacity(0.1))),
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
                  borderRadius: BorderRadius.circular(15.0)),
              child: CachedNetworkImage(
                imageUrl:
                    "https://res.cloudinary.com/maharani/image/upload/${menuItem.imageUrl}/image_asset/${menuItem.firebaseId}.jpg",
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) =>
                    Image.asset("assets/images/load.gif"),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Text(
                  "${menuItem.name}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Candarai"),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5.0,
                ),
                menuItem.inStock
                    ? menuItem.offerAvailable
                        ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\u{20B9} ${menuItem.price}',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  '\u{20B9} ${menuItem.priceOffer}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),

                                // Text(
                                //   '${(((menuItem.price - menuItem.priceOffer) / menuItem.price) * 100).toInt()}% OFF',
                                //   style: TextStyle(
                                //     color: Colors.green,
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                        )
                        : Text(
                            '\u{20B9} ${menuItem.price}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                    : Text(
                        'OUT OF STOCK',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
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
                child: Image.asset(
                  'assets/images/1.png',
                  color: brandGold,
                )),
            Divider(
              height: 1,
              thickness: 1,
              color: brandGold,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CakeTypeScreen(
                              category: cakeCategories[0],
                              categoriesGlobal:
                                  cakeCategories[0].childCategories,
                            )));
              },
              child: ListTile(
                leading: Icon(
                  Icons.cake,
                  color: brandGold,
                ),
                title: Text(
                  'Cakes',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _makePhoneCall(
                    "tel:${phoneNumber[locationName]}", context);
              },
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: brandGold,
                ),
                title: Text(
                  'Contact',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => WishlistScreen()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: brandGold,
                ),
                title: Text(
                  'Wishlist',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CartScreen()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.shopping_cart_outlined,
                  color: brandGold,
                ),
                title: Text(
                  'Cart',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PrivacyPolicyPage()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.policy_outlined,
                  color: brandGold,
                ),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ReturnRefundPolicyPage()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.policy_outlined,
                  color: brandGold,
                ),
                title: Text(
                  'Returns and Refunds',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TermsAndConditionsPage()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.policy_outlined,
                  color: brandGold,
                ),
                title: Text(
                  'Terms and Conditions',
                  style: TextStyle(color: brandGold),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
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
                  SizedBox(
                    height: 130.0,
                  ),

                  GridView.builder(
                      key: UniqueKey(),
                      itemCount: items.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 3,
                          mainAxisExtent: 300),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemScreen(
                                        category: widget.category,
                                        food: widget.category.items[index],
                                        categoryMain: widget.categoryMain,
                                      )),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: _buildMenu(
                                    context, items[index], index, items.length),
                              ),
                            ],
                          ),
                        );
                      }),

                  // for(var index=0; index<items.length; index+=2)
                  //   IntrinsicHeight(
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //             child: GestureDetector(
                  //               onTap: (){
                  //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: widget.category, food: widget.category.items[index], categoryMain: widget.categoryMain,)),);
                  //
                  //               },
                  //               child: _buildMenu(
                  //                   context,
                  //                   widget.category.items[index],
                  //                   index,
                  //                   widget.category.items.length
                  //               ),
                  //             )
                  //         ),
                  //
                  //         VerticalDividerWidget(),
                  //         widget.category.items.length - 1 != index ?
                  //         Expanded(
                  //           child: GestureDetector(
                  //             onTap: (){
                  //               Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: widget.category, food: widget.category.items[index + 1], categoryMain: widget.categoryMain,)),);
                  //
                  //             },
                  //             child: _buildMenu(
                  //                 context,
                  //                 widget.category.items[index+1],
                  //                 index + 1,
                  //                 widget.category.items.length
                  //             ),
                  //           ),
                  //         ) :
                  //         Expanded(child: Container()),
                  //       ],
                  //     ),
                  //   ),

                  SizedBox(
                    height: 20.0,
                  ),

                  loading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Container(),

                  SizedBox(
                    height: 20.0,
                  ),

                  Center(
                    child: Text(
                      "**",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(
                    height: 80.0,
                  ),
                ],
              ),
            ),
          ),

          // Positioned(
          //   left: 0.0,
          //   right: 0.0,
          //   top: 0.0,
          //   child: Container(
          //     height: 100.0,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black,
          //           blurRadius: 16.0,
          //           spreadRadius: 0.5,
          //           offset: Offset(0.7, 0.7),
          //         ),
          //       ],
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 30.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //
          //           Container(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Row(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   IconButton(
          //                       onPressed: () {
          //
          //                         print(currentUser.name);
          //                       },
          //                       icon: Icon(
          //                         Icons.menu,
          //                         size: 30,
          //                       )),
          //
          //                   Expanded(
          //                     child: Center(
          //                       child: Container(
          //                         width: double.infinity,
          //                         child: Row(
          //                           crossAxisAlignment: CrossAxisAlignment.center,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Container(
          //                               child: Text("Maharani Bakery",
          //                                 style: TextStyle(
          //                                     fontFamily: "Candarai",
          //                                     fontSize: 30.0,
          //                                     fontWeight: FontWeight.bold
          //                                 ),),
          //                               // child: Image.asset("assets/images/logo.png", height: 40.0, width: 250.0,),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   TextButton(
          //                     onPressed: () => Navigator.push(
          //                         context, MaterialPageRoute(builder: (_) => CartScreen())),
          //                     child: Stack(
          //                       children: [
          //                         Icon(
          //                           Icons.shopping_cart,
          //                           size: 30,
          //                           color: Colors.black,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   // Search screen
          //                 ],
          //               ),
          //             ),
          //           ),
          //
          //
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
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
                            style: TextStyle(fontSize: 13.0, color: brandGold),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        color: brandGold,
                        width: 1.0,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showSortOptions();
                        },
                        child: Center(
                          child: Text(
                            'SORT',
                            style: TextStyle(fontSize: 13.0, color: brandGold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          HeaderSecond(
            idScreen: "header",
            scaffoldKey: _scaffoldKey,
          ),
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
          title: Text(
            'Sort Options',
            style: TextStyle(color: brandGold),
          ),
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
                    title: Text(
                      "Price: High to Low",
                      style: TextStyle(color: brandGold),
                    ),
                    onTap: () {
                      setState(() {
                        widget.category.items.sort((a, b) =>
                            double.parse(b.priceOffer.toString()).compareTo(
                                double.parse(a.priceOffer.toString())));
                        if (widget.category.items.length > 20) {
                          items = widget.category.items.sublist(0, 20);
                        } else {
                          items = widget.category.items;
                        }

                        _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    color: brandGold,
                    height: 0.5,
                  ),
                  ListTile(
                    title: Text(
                      "Price: Low to High",
                      style: TextStyle(color: brandGold),
                    ),
                    onTap: () {
                      setState(() {
                        widget.category.items.sort((a, b) =>
                            double.parse(a.priceOffer.toString()).compareTo(
                                double.parse(b.priceOffer.toString())));
                        if (widget.category.items.length > 20) {
                          items = widget.category.items.sublist(0, 20);
                        } else {
                          items = widget.category.items;
                        }

                        _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
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

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
