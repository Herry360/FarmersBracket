import 'package:flutter/material.dart';

// Widget for adjusting item quantities
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final void Function(int) onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => onChanged(quantity > 1 ? quantity - 1 : 1),
        ),
        Text(quantity.toString()),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onChanged(quantity + 1),
        ),
      ],
    );
  }
}
