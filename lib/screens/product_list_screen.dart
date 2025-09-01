import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> products = [
    Product(
      name: 'Tomato',
      price: 2.5,
      imageUrl: 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc',
    ),
    Product(
      name: 'Potato',
      price: 1.2,
      imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
    ),
    Product(
      name: 'Carrot',
      price: 1.8,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
    ),
  ];

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(product.imageUrl, height: 100),
            SizedBox(height: 10),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              onTap: () => _showProductDetails(product),
            ),
          );
        },
      ),
    );
  }
}