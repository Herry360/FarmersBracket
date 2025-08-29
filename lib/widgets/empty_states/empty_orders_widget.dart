import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyOrdersWidget extends StatelessWidget {
  const EmptyOrdersWidget({super.key, required Null Function() onActionPressed, required String subtitle, required String heading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/empty_orders.json',
            height: 120,
            repeat: true,
          ),
          const SizedBox(height: 16),
          Text('No Orders Yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'You haven\'t placed any orders yet. Start shopping and place your first order!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/products');
            },
            child: const Text('Shop Now'),
          ),
        ],
      ),
    );
  }
}
