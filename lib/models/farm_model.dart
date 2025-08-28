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
  final bool isOnSale;
  final bool isNewArrival;
  final double rating;
  final int reviewCount;
  final DateTime? harvestDate;
  final int stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isOutOfSeason;
  final String title;
  final String certification;
  final double latitude;
  final double longitude;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.images,
    required this.farmId,
    required this.farmName,
    required this.category,
    required this.unit,
    required this.isOrganic,
    required this.isFeatured,
    required this.isSeasonal,
    required this.isOnSale,
    required this.isNewArrival,
    required this.rating,
    required this.reviewCount,
    this.harvestDate,
    required this.stock,
    this.createdAt,
    this.updatedAt,
    required this.isOutOfSeason,
    required this.title,
    required this.certification,
    required this.latitude,
    required this.longitude, required int quantity,
  });

  String get displayTitle => title.isNotEmpty ? title : name;
}

class Farm {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double distance;
  /// Location of the farm (lat/lng)
  final double latitude;
  final double longitude;
  final String story;
  final List<String> practiceLabels;
  final List<String> imageUrls;

  // Getter for practices (for compatibility with farm_profile_screen.dart)
  List<String> get practices => practiceLabels;

  // Getter for images (for compatibility with farm_profile_screen.dart)
  List<String> get images => imageUrls;
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
    required this.latitude,
    required this.longitude,
    required this.story,
    required this.practiceLabels,
    required this.imageUrls,
    required this.category,
    this.products = const [],
    this.price = 0.0,
    this.isFavorite = false, required location,
  });
}
