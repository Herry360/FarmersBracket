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
  final int quantity;
  final int stockQuantity;
  final String farmerId;
  final bool isAvailable;

  Product({
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
    required this.longitude,
    required this.quantity,
    required this.stockQuantity,
    required this.farmerId,
    required this.isAvailable,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      farmId: map['farmId'] ?? '',
      farmName: map['farmName'] ?? '',
      category: map['category'] ?? '',
      unit: map['unit'] ?? '',
      isOrganic: map['isOrganic'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      isSeasonal: map['isSeasonal'] ?? false,
      isOnSale: map['isOnSale'] ?? false,
      isNewArrival: map['isNewArrival'] ?? false,
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: (map['reviewCount'] ?? 0).toInt(),
      harvestDate: map['harvestDate'] != null ? DateTime.parse(map['harvestDate']) : null,
      stock: (map['stock'] ?? 0).toInt(),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isOutOfSeason: map['isOutOfSeason'] ?? false,
      title: map['title'] ?? '',
      certification: map['certification'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 0).toInt(),
      stockQuantity: (map['stockQuantity'] ?? 0).toInt(),
      farmerId: map['farmerId'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'farmId': farmId,
      'farmName': farmName,
      'category': category,
      'unit': unit,
      'isOrganic': isOrganic,
      'isFeatured': isFeatured,
      'isSeasonal': isSeasonal,
      'isOnSale': isOnSale,
      'isNewArrival': isNewArrival,
      'rating': rating,
      'reviewCount': reviewCount,
      'harvestDate': harvestDate?.toIso8601String(),
      'stock': stock,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isOutOfSeason': isOutOfSeason,
      'title': title,
      'certification': certification,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': quantity,
      'stockQuantity': stockQuantity,
      'farmerId': farmerId,
      'isAvailable': isAvailable,
    };
  }
}