import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Tomato', description: 'Fresh tomatoes', price: 2.5),
    Product(name: 'Potato', description: 'Organic potatoes', price: 1.8),
    Product(name: 'Carrot', description: 'Crunchy carrots', price: 1.2),
    Product(name: 'Cucumber', description: 'Green cucumbers', price: 2.0),
  ];

  const ProductListScreen({super.key});

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
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text(product.description),
              trailing: Text('\$${product.price.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}