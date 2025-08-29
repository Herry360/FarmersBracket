import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Tomato',
      price: 2.5,
      imageUrl: 'https://example.com/tomato.jpg',
    ),
    Product(
      id: '2',
      name: 'Potato',
      price: 1.5,
      imageUrl: 'https://example.com/potato.jpg',
    ),
    Product(
      id: '3',
      name: 'Carrot',
      price: 3.0,
      imageUrl: 'https://example.com/carrot.jpg',
    ),
  ];

  List<Product> get products => [..._products];

  Product? findById(String id) {
    try {
      return _products.firstWhere((prod) => prod.id == id);
    } catch (e) {
      return null;
    }
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final index = _products.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _products[index] = newProduct;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}