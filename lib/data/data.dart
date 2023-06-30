// Food
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/models/category.dart';
import 'package:maharani_bakery_app/models/user.dart';

final db = FirebaseFirestore.instance;

final referenceGlobal = FirebaseDatabase.instance.reference();

Color brandGold = Color(0xffdac48c);

Map phoneNumber = {
  "ramdurg" : "+917686093333",
  "bagalkot" : "+917686083333",
  "mudhol" : "+917338148433",
};

Map coordinates = {
  "ramdurg" : [15.9470027, 75.2951516],
  "bagalkot" : [16.1871925, 75.6994652],
  "mudhol" : [16.3292118, 75.2852058],
};

String locationName = "ramdurg";
late List types = ["Egg Less", "Egg"];
String cakeType = "Egg";

List<String>? wishList = [];

List<Category> categories = [];
List<CakeCategory> cakeCategories = [];
Map<String, dynamic> slideShow = {};
Map deliveryDetails = {};


// User
User currentUser = User(name: "Faris", location: "Tirurangadi", orders: [], cart: []);

List sortList(List initialList, int length){

  List sortedList = [];
  int listLength = 0;
  var idNos = List<int>.generate(length, (i) => i + 1);

  for(var idElement in idNos){
    for(var listElement in initialList){
      if(double.parse(listElement.id.toString()) == double.parse(idElement.toString())){
        sortedList.add(listElement);
        listLength += 1;
        if(listLength == initialList.length){
          break;
        }
        break;
      }
    }
  }

  return sortedList;
}
