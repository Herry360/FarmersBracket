class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> images;
  final String farmId;
  final String farmName;
  final String category;
  final String unit;
  final bool isOrganic;
  final bool isFeatured;
  final bool isSeasonal;
  final double rating;
  final int reviewCount;
  final DateTime? harvestDate;
  final double stock;
  int quantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isOutOfSeason;

  Product({
  required this.id,
  required this.name,
  required this.description,
  required this.price,
  required this.imageUrl,
  this.images = const [],
  this.farmId = '',
  this.farmName = '',
  this.category = '',
  this.unit = '',
  this.isOrganic = false,
  this.isFeatured = false,
  this.isSeasonal = false,
  this.rating = 0.0,
  this.reviewCount = 0,
  this.harvestDate,
  this.stock = 0.0,
  this.quantity = 1,
  this.createdAt,
  this.updatedAt,
  this.isOutOfSeason = false, required title,
  });

  String get title => name;
}

class Farm {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double distance;
  /// Location of the farm (always Mpumalanga)
  final String location;
  final String category;
  final List<Product> products;
  final double price;
  final bool isFavorite;

  const Farm({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.location,
    required this.category,
    this.products = const [],
    this.price = 0.0,
    this.isFavorite = false,
  });
}
