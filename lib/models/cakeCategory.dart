import 'package:maharani_bakery_app/models/cake.dart';
import 'package:maharani_bakery_app/models/cakeChildCategory.dart';

class CakeCategory {
  final String firebaseId;
  final String imageUrl;
  final String name;
  final String number;
  final String description;
  final List<CakeChildCategory> childCategories;
  CakeCategory({
    required this.imageUrl,
    required this.firebaseId,
    required this.description,
    required this.name,
    required this.number,
    required this.childCategories,
  });
}
