import 'package:maharani_bakery_app/models/food.dart';

import 'childCategory.dart';

class Category {
  final String firebaseId;
  final String imageUrl;
  final String name;
  final String number;
  final String description;
  final List<ChildCategory> childCategories;
  Category({
    required this.imageUrl,
    required this.firebaseId,
    required this.name,
    required this.number,
    required this.description,
    required this.childCategories,
  });
}
