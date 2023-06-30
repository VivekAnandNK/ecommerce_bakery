class Food {
  final String type;
  final String number;
  final String firebaseId;
  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final double priceOffer;
  final bool offerAvailable;
  final bool inStock;
  final bool isFavourite;

  final Map specs;
  Food({
    required this.number,
    required this.type,
    required this.firebaseId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.priceOffer,
    required this.description,

    required this.offerAvailable,
    required this.inStock,
    required this.isFavourite,
    required this.specs,

  });
}
