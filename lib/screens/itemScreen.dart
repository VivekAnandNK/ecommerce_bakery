import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:maharani_bakery_app/components/build_rating.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/models/childCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/models/user.dart';
import 'package:maharani_bakery_app/screens/viewImage.dart';
import 'package:maharani_bakery_app/screens/wishlistScreen.dart';
import 'package:maharani_bakery_app/widgets/Divider.dart';
import 'package:maharani_bakery_app/widgets/add_item.dart';
import 'package:maharani_bakery_app/widgets/bottomWidget.dart';
import 'package:maharani_bakery_app/widgets/cart_operation.dart';
import 'package:maharani_bakery_app/widgets/navigationBar.dart';
import 'package:maharani_bakery_app/widgets/rounded_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maharani_bakery_app/widgets/similarItemOrder.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cakeChildCategory.dart';
import '../widgets/header_second.dart';
import 'cakeItemScreen.dart';
import 'cakeTypeScreen.dart';
import 'cart_screen.dart';
import 'cart_screen.dart';
import 'cart_screen.dart';

class ItemScreen extends StatefulWidget {
  final Food food;
  final ChildCategory category;
  final Category categoryMain;

  const ItemScreen({Key? key,required this.category, required this.food, required this.categoryMain}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  bool isFavourite = false;
  List comments = [];
  bool commentsLoaded = false;
  bool commentAddContainer = false;
  double value = 1;
  bool halfKgSelected = false;
  bool oneKgSelected = true;
  bool oneHalfKgSelected = false;
  double selectedWeight = 1.0;
  String addToCartText = "Add to cart";
  bool addToCartClicked = false;

  TextEditingController nameTextEditingController = new TextEditingController(text: currentUser.name);
  TextEditingController locationTextEditingController = new TextEditingController(text: currentUser.location);
  TextEditingController commentTextEditingController = new TextEditingController();


  String resultId = "";
  int orderCount = 1;


  final _decorationShade = BoxDecoration(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
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
          ]
      )
  );

  _swapFavourite() async{

    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList("wishlist");

    if (isFavourite) {

      if (items != null) {
        items.remove(items.firstWhere((element) => element.split("<sepMAIN>")[0] == widget.food.firebaseId));
      }
      wishList = items;
      await prefs.setStringList("wishlist", items!);

    } else {

      String favoriteCake = "${widget.food.firebaseId}<sepMAIN>${widget.food.imageUrl}<sepMAIN>${widget.food.name}<sepMAIN>${widget.food.specs}<sepMAIN>${widget.food.number}<sepMAIN>${widget.food.price}<sepMAIN>${widget.food.priceOffer}<sepMAIN>${widget.food.offerAvailable}<sepMAIN>${widget.food.inStock}<sepMAIN>${widget.food.description}<sepMAIN>item<sepMAIN>${widget.categoryMain.firebaseId}<sepMAIN>${widget.category.firebaseId}";

      if (items == null) {
        await prefs.setStringList("wishlist", [favoriteCake]);
      } else {
        items.add(favoriteCake);
        // print("added")
        wishList = items;
        await prefs.setStringList("wishlist", items);
      }
      // await prefs.setStringList("favourites", favoriteCake);
    }

    print(prefs.getStringList("wishlist"));

    setState(() {
      isFavourite = !isFavourite;
    });

  }

  getComments() async{
    setState(() {
      comments = [];

    });

    setState(() {
      commentsLoaded = false;
    });

    final event = await referenceGlobal.once(DatabaseEventType.value);
    final dataSnapshot = event.snapshot.value as Map<dynamic, dynamic>;

    print(dataSnapshot["Categories"]);

    setState(() {
      commentsLoaded = true;
    });

  }

  void checkFavorites() {

    // final prefs = await SharedPreferences.getInstance();
    // final List<String>? items = prefs.getStringList("wishlist");

    if (wishList != null) {
      // print(wishList);
      for (var item in wishList!) {
        print(item.split("<sepMAIN>")[0]);
        print(widget.food.firebaseId);
        if (item.split("<sepMAIN>")[0] == widget.food.firebaseId) {
          print("HELLO");
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
    getComments();
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
                        CachedNetworkImage(
                          imageBuilder: (context, imageProvider) => Container(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          imageUrl: "https://res.cloudinary.com/maharani/image/upload/${widget.food.imageUrl}/image_asset/${widget.food.firebaseId}.jpg",

                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Icon(Icons.error),

                          placeholder: (context, url) => Image.asset("assets/images/load.gif"),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImage(imageUrl: widget.food.imageUrl, firebaseId: widget.food.firebaseId, type: 'item', item: widget.food,),));

                          },
                          child: Container(
                            // Container to add a shading effect on the resturant image
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            decoration: _decorationShade,
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
                                  widget.food.name,
                                  style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          widget.food.description.split("//").length > 1 ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "--${widget.food.description.split("//")[1]}--",
                              style: TextStyle(fontSize: 18, fontFamily: "Candarai", ),
                            ),
                          ) : Container(),
                          // Rating(rating: widget.food.rating),
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: widget.food.inStock ? widget.food.offerAvailable ? Row(
                          children: [
                            Text(
                              "\u{20B9} ${(orderCount == 0 ? widget.food.price : widget.food.price * orderCount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  decoration: TextDecoration.lineThrough
                              ),
                            ),
                            SizedBox(width: 5.0,),
                            Text(
                              "\u{20B9} ${(orderCount == 0 ? widget.food.priceOffer : widget.food.priceOffer * orderCount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal
                              ),
                            ),
                            SizedBox(width: 5.0,),

                            Text(
                              "${(((widget.food.price - widget.food.priceOffer) / widget.food.price) * 100).toInt()}% OFF",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                              ),
                            ),
                          ],
                        ) : Row(
                          children: [
                            Text(
                              "\u{20B9} ${(orderCount == 0 ? widget.food.price : widget.food.price * orderCount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
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
                    ),

                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  if (widget.food.inStock) {
                                    currentUser.cart.add(
                                        Order(
                                            category: widget.category,
                                            food: widget.food,
                                            date: DateTime.now().toString().split(" ")[0],
                                            quantity: orderCount,
                                            categoryMain: widget.categoryMain
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
                        Container(
                          width: 140,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey.withOpacity(0.1),
                              border: Border.all(
                                width: 1.5,
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
                                      child: Text("${widget.food.number}"),
                                    )
                                  ]
                              ),
                              for(var elements in widget.food.specs.entries)
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
                            ],
                          ),
                        )
                      ],
                    ),
                    DividerWidget(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.food.description == "" ? "" : "Please Note : ",
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Candarai"),
                        ),
                      ),
                    ),
                    for (var k=0; k<widget.food.description.split("//")[0].split("*").length; k++)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 3.0, right: 8.0),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            widget.food.description.split("//")[0] == "" ? "" : "• ${widget.food.description.split("//")[0].split("*")[k]}",
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50.0,),
                        Container(
                          child: Text("No comments"),
                        ),
                      ],
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 32.0),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                    //     ],
                    //   ),
                    // ),
                    DividerWidget(),
                    SizedBox(height: 10.0,),
                    Text(
                      'Similar Items',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    SimilarItemOrder(category: widget.category, thisFood: widget.food, categoryMain: widget.categoryMain,),

                    BottomWidget(),
                    SizedBox(height: 60.0,),
                  ],
                ),
              ),
            ),
            HeaderSecond(idScreen: "header", scaffoldKey: _scaffoldKey,),
            NavigationsBar(idScreen: "items"),

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
                                  String commentsTemp = "";

                                  if(nameTextEditingController.text.trim() == ""){
                                    displayToastMessage("Name cannot be empty", context);
                                  }
                                  else if(locationTextEditingController.text.trim() == ""){
                                    displayToastMessage("Location cannot be empty", context);
                                  }
                                  else if(commentTextEditingController.text.trim() == ""){
                                    displayToastMessage("Comment cannot be empty", context);
                                  }
                                  else{
                                    for(var elements in comments){
                                      commentsTemp += "<lsep>${elements["Name"]}<sep>${elements["Location"]}<sep>${elements["Rating"]}<sep>${elements["Comment"]}";
                                    }
                                  }

                                  commentsTemp += "<lsep>${nameTextEditingController.text.trim()}<sep>${locationTextEditingController.text.trim()}<sep>${value.toString().split(".")[0]}<sep>${commentTextEditingController.text.trim()}";


                                  setState(() {
                                    commentAddContainer = false;
                                  });


                                  await db.collection("data").get().then((querySnapshot) {
                                    querySnapshot.docs.forEach((result) {
                                      if(result.data()["Category"] == widget.category.name){
                                        db.collection("data").doc(result.id).collection("Items").get().then((querySnapshot){
                                          querySnapshot.docs.forEach((result3){
                                            db.collection("data").doc(result.id).collection("Items").doc(result3.id).update(
                                              // {"Dosa.Price": "49.99", "Chicken": {"Price": "59.99", "Image":"378372737"}}
                                                {"${widget.food.name}.Comments" : commentsTemp.substring(6)}
                                            );
                                          });
                                        });

                                      }
                                    });
                                  });


                                  // SharedPreferences preferences = await SharedPreferences();

                                  Future.delayed(Duration(seconds: 2));

                                  getComments();

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
