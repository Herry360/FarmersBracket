import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class EmptySearchResultsWidget extends StatelessWidget {
  const EmptySearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/empty_search.json',
            height: 120,
            repeat: true,
          ),
          const SizedBox(height: 16),
          Text('No Results Found', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Try a different search or check your spelling. You can also browse our categories!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/categories');
            },
            child: const Text('Browse Categories'),
          ),
        ],
      ),
    );
  }
}
