class Farm {
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

  Farm({
	required this.name,
	required this.size,
	required this.crops,
	required this.established,
	this.isFavorite = false,
	required this.latitude,
	required this.longitude,
	this.story = '',
	this.practiceLabels = const [],
	this.imageUrls = const [], required String description,
  });
}

// Example usage:
final featuredFarms = [
  Farm(
	name: 'Green Valley Farm',
	size: 120.5,
	crops: ['Corn', 'Wheat'],
	established: DateTime(1995, 6, 15),
	isFavorite: true,
	latitude: 37.7749,
	longitude: -122.4194,
	story: 'A family-run farm with sustainable practices.',
	practiceLabels: ['Organic', 'No-till'],
	imageUrls: ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'], description: '',
  ),
  Farm(
	name: 'Sunny Acres',
	size: 80.0,
	crops: ['Tomatoes', 'Lettuce'],
	established: DateTime(2005, 3, 10),
	latitude: 34.0522,
	longitude: -118.2437,
	story: 'Known for fresh produce and community events.',
	practiceLabels: ['Hydroponic'],
	imageUrls: ['https://example.com/image3.jpg'], description: '',
  ),
];
