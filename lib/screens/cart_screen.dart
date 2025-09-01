import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final int quantity;
  final double price;

  CartItem({required this.name, required this.quantity, required this.price});
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(name: 'Tomatoes', quantity: 2, price: 3.5),
    CartItem(name: 'Potatoes', quantity: 1, price: 2.0),
    CartItem(name: 'Carrots', quantity: 3, price: 1.5),
  ];

  double get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearCart,
            tooltip: 'Clear Cart',
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: cartItems.isEmpty ? null : () {
                // Implement checkout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout successful!')),
                );
                clearCart();
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}