class Farm {
  final String id;
  final String name;
  final double size;
  final List<String> crops;
  final DateTime established;
  final bool isFavorite;
  final double latitude;
  final double longitude;
  final String story;
  final List<String> practiceLabels;
  final List<String> imageUrls;
  final String description;
  final String imageUrl;
  final int rating;
  final int distance;
  final String location;
  final String category;
  final List products;
  final int price;

  Farm({
    required this.id,
    required this.name,
    required this.size,
    required this.crops,
    required this.established,
    this.isFavorite = false,
    required this.latitude,
    required this.longitude,
    this.story = '',
    this.practiceLabels = const [],
    this.imageUrls = const [],
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.location,
    required this.category,
    required this.products,
    required this.price,
  });
}

// Example usage:
final featuredFarms = [
  Farm(
    id: 'farm1',
    name: 'Green Valley Farm',
    size: 120.5,
    crops: ['Corn', 'Wheat'],
    established: DateTime(1995, 6, 15),
    isFavorite: true,
    latitude: 37.7749,
    longitude: -122.4194,
    story: 'A family-run farm with sustainable practices.',
    practiceLabels: ['Organic', 'No-till'],
    imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
    description: 'A beautiful farm in the valley.',
    imageUrl: 'https://example.com/image1.jpg',
    rating: 5,
    distance: 10,
    location: 'San Francisco, CA',
    category: 'Vegetables',
    products: ['Corn', 'Wheat'],
    price: 100,
  ),
  Farm(
    id: 'farm2',
    name: 'Sunny Acres',
    size: 80.0,
    crops: ['Tomatoes', 'Lettuce'],
    established: DateTime(2005, 3, 10),
    latitude: 34.0522,
    longitude: -118.2437,
    story: 'Known for fresh produce and community events.',
    practiceLabels: ['Hydroponic'],
    imageUrls: ['https://example.com/image3.jpg'],
    description: 'Sunny farm with fresh produce.',
    imageUrl: 'https://example.com/image3.jpg',
    rating: 4,
    distance: 20,
    location: 'Los Angeles, CA',
    category: 'Fruits',
    products: ['Tomatoes', 'Lettuce'],
    price: 80,
  ),
];