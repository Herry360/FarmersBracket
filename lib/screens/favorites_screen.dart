import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example list of favorite items
    final List<String> favorites = [
      'Apple',
      'Banana',
      'Carrot',
      'Tomato',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorites yet.'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(favorites[index]),
                );
              },
            ),
    );
  }
}