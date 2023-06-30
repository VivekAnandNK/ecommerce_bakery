import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeCategory.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/screens/cakeItemScreen.dart';
import 'package:maharani_bakery_app/screens/itemScreen.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../models/childCategory.dart';

class SimilarItemOrder extends StatelessWidget {
  final ChildCategory category;
  final Category categoryMain;
  final Food thisFood;
  const SimilarItemOrder({Key? key, required this.category, required this.thisFood, required this.categoryMain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tempFoodMap = [];
    List randomCakes = [];
    var rng = new Random();
    var sampleSize = min(category.items.length, 30);
    var sample = List.from(category.items);

    for (var i = 0; i < sampleSize; i++) {
      var j = i + rng.nextInt(sample.length - i);
      var temp = sample[i];
      sample[i] = sample[j];
      sample[j] = temp;
    }

    randomCakes = sample.sublist(0, sampleSize);

    for(var elements in randomCakes){
      tempFoodMap.add(elements);
    }
    tempFoodMap.remove(thisFood);
    return tempFoodMap.length > 0 ? SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for(var elements in tempFoodMap)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(category: category, food: elements, categoryMain: categoryMain,)),);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${elements.imageUrl}/image_asset/${elements.firebaseId}.jpg"), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    SizedBox(height: 10.0,),

                    Column(
                      children: [
                        Text(
                          elements.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Candarai"
                          ),
                        ),
                        Text(
                          '\u{20B9} ${elements.price}',
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
            ),
        ],
      ),
    ) : Text("No similar items found");
  }
}
