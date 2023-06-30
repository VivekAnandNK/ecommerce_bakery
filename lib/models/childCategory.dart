import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/food.dart';

class ChildCategory {
  final String firebaseId;
  final String imageUrl;
  final String name;
  final String description;
  final String number;
  final List<Food> items;
  ChildCategory({
    required this.imageUrl,
    required this.firebaseId,
    required this.description,
    required this.name,
    required this.number,
    required this.items,
  });
}
