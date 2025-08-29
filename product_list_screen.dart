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
    Product(name: 'Apple', description: 'Fresh red apples', price: 2.5),
    Product(name: 'Banana', description: 'Organic bananas', price: 1.2),
    Product(name: 'Carrot', description: 'Crunchy carrots', price: 0.8),
    Product(name: 'Tomato', description: 'Juicy tomatoes', price: 1.5),
  ];

  ProductListScreen({super.key});

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