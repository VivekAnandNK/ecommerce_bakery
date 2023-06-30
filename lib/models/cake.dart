class Cake {
  final String firebaseId;
  final List<String> imageUrl;
  final String name;
  final String number;
  final String description;
  final Map specs;
  final Map weightPrice;
  final Map weightPriceOffer;
  final bool offerAvailable;
  final bool inStock;
  final bool isFavourite;
  Cake({
    required this.firebaseId,
    required this.imageUrl,
    required this.weightPrice,
    required this.name,
    required this.number,
    required this.description,
    required this.specs,
    required this.weightPriceOffer,
    required this.offerAvailable,
    required this.inStock,
    required this.isFavourite,
  });
}