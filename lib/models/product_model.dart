class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;

  final String category;
  final List<String> images;
  final String farmId;
  final String farmName;
  final bool isOrganic;
  final bool isSeasonal;
  final String unit;
  final bool isFeatured;
  final double rating;
  final bool isOnSale;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final int stock;
  final bool isNewArrival;
  final bool isOutOfSeason;
  final DateTime harvestDate;
  final String certification;
  final double longitude;
  final int stockQuantity;
  final String farmerId;
  final double latitude;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.category,
    required this.images,
    required this.farmId,
    required this.farmName,
    required this.isOrganic,
    required this.isSeasonal,
    required this.unit,
    required this.isFeatured,
    required this.rating,
    required this.isOnSale,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.stock,
    required this.isNewArrival,
    required this.isOutOfSeason,
    required this.harvestDate,
    required this.certification,
    required this.longitude,
    required this.stockQuantity,
    required this.farmerId,
    required this.latitude,
    required this.isAvailable,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      quantity: json['quantity'] as int,
      category: json['category'] as String? ?? '',
      images: (json['images'] as List<dynamic>? ?? []).map((e) => e as String).toList(),
      farmId: json['farmId'] as String? ?? '',
      farmName: json['farmName'] as String? ?? '',
      isOrganic: json['isOrganic'] as bool? ?? false,
      isSeasonal: json['isSeasonal'] as bool? ?? false,
      unit: json['unit'] as String? ?? '',
      isFeatured: json['isFeatured'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isOnSale: json['isOnSale'] as bool? ?? false,
      reviewCount: json['reviewCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      title: json['title'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
      isNewArrival: json['isNewArrival'] as bool? ?? false,
      isOutOfSeason: json['isOutOfSeason'] as bool? ?? false,
      harvestDate: json['harvestDate'] != null ? DateTime.parse(json['harvestDate']) : DateTime.now(),
      certification: json['certification'] as String? ?? '',
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      farmerId: json['farmerId'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'category': category,
      'images': images,
      'farmId': farmId,
      'farmName': farmName,
      'isOrganic': isOrganic,
      'isSeasonal': isSeasonal,
      'unit': unit,
      'isFeatured': isFeatured,
      'rating': rating,
      'isOnSale': isOnSale,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'stock': stock,
      'isNewArrival': isNewArrival,
      'isOutOfSeason': isOutOfSeason,
      'harvestDate': harvestDate.toIso8601String(),
      'certification': certification,
      'longitude': longitude,
      'stockQuantity': stockQuantity,
      'farmerId': farmerId,
      'latitude': latitude,
      'isAvailable': isAvailable,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? quantity,
    String? category,
    List<String>? images,
    String? farmId,
    String? farmName,
    bool? isOrganic,
    bool? isSeasonal,
    String? unit,
    bool? isFeatured,
    double? rating,
    bool? isOnSale,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    int? stock,
    bool? isNewArrival,
    bool? isOutOfSeason,
    DateTime? harvestDate,
    String? certification,
    double? longitude,
    int? stockQuantity,
    String? farmerId,
    double? latitude,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      images: images ?? this.images,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      isOrganic: isOrganic ?? this.isOrganic,
      isSeasonal: isSeasonal ?? this.isSeasonal,
      unit: unit ?? this.unit,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      isOnSale: isOnSale ?? this.isOnSale,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      stock: stock ?? this.stock,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isOutOfSeason: isOutOfSeason ?? this.isOutOfSeason,
      harvestDate: harvestDate ?? this.harvestDate,
      certification: certification ?? this.certification,
      longitude: longitude ?? this.longitude,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      farmerId: farmerId ?? this.farmerId,
      latitude: latitude ?? this.latitude,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}