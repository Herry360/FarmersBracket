import 'package:farm_bracket/screens/farm/farm_header.dart';

class FarmModel {
  final String id;
  final String name;
  final String location;
  final double size; // in acres
  final List<String> crops;
  final DateTime established;
  final String description;
  final String imageUrl;
  final double rating;
  final double distance;
  final String category;
  final List products;
  final int price;
  final double latitude;
  final double longitude;
  final String story;
  final List<String> practiceLabels;
  final List imageUrls;
  final bool isFavorite;

  FarmModel({
    required this.id,
    required this.name,
    required this.location,
    required this.size,
    required this.crops,
    required this.established,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.category,
    required this.products,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.story,
    required this.practiceLabels,
    required this.imageUrls,
    required this.isFavorite,
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      size: (json['size'] as num).toDouble(),
      crops: List<String>.from(json['crops'] ?? []),
      established: DateTime.parse(json['established'] as String),
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      products: json['products'] ?? [],
      price: json['price'] ?? 0,
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      story: json['story'] ?? '',
      practiceLabels: List<String>.from(json['practiceLabels'] ?? []),
      imageUrls: json['imageUrls'] ?? [],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'size': size,
      'crops': crops,
      'established': established.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'distance': distance,
      'category': category,
      'products': products,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'story': story,
      'practiceLabels': practiceLabels,
      'imageUrls': imageUrls,
      'isFavorite': isFavorite,
    };
  }

  @override
  String toString() {
    return 'FarmModel(id: $id, name: $name, location: $location, size: $size, crops: $crops, established: $established, description: $description, imageUrl: $imageUrl, rating: $rating, distance: $distance, category: $category, products: $products, price: $price, latitude: $latitude, longitude: $longitude, story: $story, practiceLabels: $practiceLabels, imageUrls: $imageUrls, isFavorite: $isFavorite)';
  }

  static void fromFarmModel(Farm farm) {}
}