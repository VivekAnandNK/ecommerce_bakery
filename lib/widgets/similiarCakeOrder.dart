import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/screens/cakeItemScreen.dart';

import '../data/data.dart';
import 'compressedImage.dart';

class SimilarCakeOrder extends StatefulWidget {
  final String cakeChildCategoryId;
  const SimilarCakeOrder({Key? key, required this.cakeChildCategoryId}) : super(key: key);

  @override
  State<SimilarCakeOrder> createState() => _SimilarCakeOrderState();
}

class _SimilarCakeOrderState extends State<SimilarCakeOrder> {

  bool loaded = false;
  List randomCakes = [];

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
              description: cake.value["description"] ?? "", isFavourite: isFavourite
          )
      );
    }

    return newItems;
  }


  Future<void> _loadFromFirebase() async{

    setState(() {
      loaded = false;
    });
    DatabaseEvent? event = await referenceGlobal
        .child("Categories")
        .child("CakesCategories")
        .child("ChildCategories")
        .child(widget.cakeChildCategoryId)
        .child("Items")// limit to the first 20 items
        .once(DatabaseEventType.value);

    Map? dataSnapshot = (event.snapshot.value ?? {}) as Map<dynamic, dynamic>;

    event = null;
    List<dynamic>? newItemsAll = _processCakes(dataSnapshot);
    dataSnapshot = null;
    var rng = new Random();
    var sampleSize = min(newItemsAll.length, 30);
    var sample = List.from(newItemsAll);
    newItemsAll = null;

    for (var i = 0; i < sampleSize; i++) {
      var j = i + rng.nextInt(sample.length - i);
      var temp = sample[i];
      sample[i] = sample[j];
      sample[j] = temp;
    }

    while(true) {
      if (mounted) {
        setState(() {
          loaded = true;
        });
        break;
      }
    }


    setState(() {
      randomCakes = sample.sublist(0, sampleSize);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFromFirebase();
  }

  @override
  Widget build(BuildContext context) {

    return loaded ? randomCakes.length > 0 ?
    ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        itemCount: randomCakes.length,
        itemBuilder: (BuildContext context, int index){
      return
        GestureDetector(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => CakeItemScreen(cake: randomCakes[index], categoryId: 'CakesCategories', categoryMainId: widget.cakeChildCategoryId,)),);
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //     image: OptimizedCacheImageProvider(
                  //         elements.imageUrl[0]
                  //     ),
                  //     fit: BoxFit.cover
                  // ),
                    borderRadius: BorderRadius.circular(15.0)
                ),
                child: CompressedImage(imageUrl: randomCakes[index].imageUrl[0], quality: 5),
              ),
              SizedBox(height: 10.0,),

              Column(
                children: [
                  Text(
                    "${randomCakes[index].name.split(" ")[0]}...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Candarai"
                    ),
                  ),
                  Text(
                    '\u{20B9} ${randomCakes[index].weightPrice[randomCakes[index].weightPrice.keys.toList()[0]]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }) : Text("No similar cakes found") : CircularProgressIndicator();
  }
}