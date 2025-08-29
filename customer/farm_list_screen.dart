import 'package:flutter/material.dart';

class Farm {
  final String name;
  final String location;
  final String imageUrl;

  Farm({required this.name, required this.location, required this.imageUrl});
}

class FarmListScreen extends StatelessWidget {
  final List<Farm> farms = [
    Farm(
      name: 'Green Valley Farm',
      location: 'California',
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    ),
    Farm(
      name: 'Sunny Acres',
      location: 'Texas',
      imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
    ),
    Farm(
      name: 'Riverbend Ranch',
      location: 'Montana',
      imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429',
    ),
  ];

  FarmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm List'),
      ),
      body: ListView.builder(
        itemCount: farms.length,
        itemBuilder: (context, index) {
          final farm = farms[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  farm.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(farm.name),
              subtitle: Text(farm.location),
              onTap: () {
                // You can navigate to farm details here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${farm.name}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}