import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/empty_cart.json',
            height: 120,
            repeat: true,
          ),
          const SizedBox(height: 16),
          Text('Your cart is empty!', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Find something fresh to add. Browse our products and fill your cart with farm goodness!',
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
