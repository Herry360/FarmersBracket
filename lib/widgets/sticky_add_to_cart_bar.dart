import 'package:flutter/material.dart';

class StickyAddToCartBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;
  const StickyAddToCartBar({
    super.key,
    required this.price,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'R${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(minimumSize: const Size(120, 48)),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
