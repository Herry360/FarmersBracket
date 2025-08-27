import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/empty_favorites.json',
            height: 120,
            repeat: true,
          ),
          const SizedBox(height: 16),
          Text('No Favorites Yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'You haven\'t added any favorites yet. Tap the heart icon on a product to save it here!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/products');
            },
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}
