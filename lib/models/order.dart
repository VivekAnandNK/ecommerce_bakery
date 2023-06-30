import 'package:maharani_bakery_app/models/childCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/models/category.dart';

import 'cake.dart';
import 'cakeCategory.dart';
import 'cakeChildCategory.dart';
import 'cakeItem.dart';

class Order {
  final ChildCategory? category;
  final CakeChildCategory? cakeChildCategory;
  final dynamic categoryMain;
  final Food? food;
  final String date;
  final CakeItem? cake;
  final Cake? cakeGlobal;
  late int quantity;
  Order({
    this.category,
    this.cakeChildCategory,
    this.categoryMain,
    this.food,
    this.cake,
    required this.date,
    this.cakeGlobal,
    required this.quantity,
  });
}
