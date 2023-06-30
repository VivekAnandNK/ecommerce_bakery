import 'package:maharani_bakery_app/models/order.dart';
import 'package:maharani_bakery_app/models/wishlist.dart';

class User {
  late String name;
  late String location;
  final List<Order> orders;
  late final List<Order> cart;
  final List<WishList>? wishlist;
  User({
    required this.name,
    required this.location,
    required this.orders,
    required this.cart,
    this.wishlist,
  });
}
