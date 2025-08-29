import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: item.imageUrl.isNotEmpty
            ? Image.network(
                item.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.shopping_cart, size: 40),
        title: Text(item.name),
        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (item.quantity > 1) {
                  onQuantityChanged(item.quantity - 1);
                } else {
                  onRemove();
                }
              },
            ),
            Text(item.quantity.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onQuantityChanged(item.quantity + 1),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.withAlpha(204)),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
