import 'package:maharani_bakery_app/models/childCategory.dart';
import 'package:maharani_bakery_app/models/food.dart';
import 'package:maharani_bakery_app/models/category.dart';

import 'cakeCategory.dart';
import 'cakeChildCategory.dart';
import 'cakeItem.dart';

class WishList {
  final ChildCategory? category;
  final CakeChildCategory? cakeChildCategory;
  final dynamic categoryMain;
  final Food? food;
  final String date;
  final CakeItem? cake;
  WishList({
    this.category,
    this.cakeChildCategory,
    this.categoryMain,
    this.food,
    this.cake,
    required this.date
  });
}
