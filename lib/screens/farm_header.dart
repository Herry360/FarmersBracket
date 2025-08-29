// lib/models/farm_model.dart

class Farm {
  final String name;
  final String description;
  final String imageUrl;
  final double distance;
  final double latitude;
  final double longitude;
  final double rating;
  final String category;

  Farm({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.category,
  });
}