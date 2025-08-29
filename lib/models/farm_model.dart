class FarmModel {
  final String id;
  final String name;
  final String location;
  final double size; // in acres
  final List<String> crops;
  final DateTime established;

  FarmModel({
    required this.id,
    required this.name,
    required this.location,
    required this.size,
    required this.crops,
    required this.established, required String description, required String imageUrl, required double rating, required double distance, required String category, required List products, required int price, required double latitude, required double longitude, required String story, required List<String> practiceLabels, required List imageUrls, required bool isFavorite,
  });

  // Factory constructor for creating a new FarmModel instance from a map
  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      size: (json['size'] as num).toDouble(),
      crops: List<String>.from(json['crops'] ?? []),
      established: DateTime.parse(json['established'] as String), description: '', imageUrl: '', rating: 0.0, distance: 0.0, category: '', products: [], price: 0, latitude: 0.0, longitude: 0.0, story: '', practiceLabels: [], imageUrls: [], isFavorite: false,
    );
  }

  // Method to convert FarmModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'size': size,
      'crops': crops,
      'established': established.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'FarmModel(id: $id, name: $name, location: $location, size: $size, crops: $crops, established: $established)';
  }
}