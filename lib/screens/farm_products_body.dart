import 'package:flutter/material.dart';

import '../models/farm_model.dart';
import 'product_detail_screen.dart';

class FarmProductsBody extends StatefulWidget {
  final Farm farm;
  const FarmProductsBody({Key? key, required this.farm}) : super(key: key);

  @override
  State<FarmProductsBody> createState() => _FarmProductsBodyState();
}

class _FarmProductsBodyState extends State<FarmProductsBody> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Tomatoes',
      description: 'Fresh organic tomatoes.',
      price: 2.5,
      imageUrl: 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc', title: null,
    ),
    Product(
      id: '2',
      name: 'Carrots',
      description: 'Crunchy farm carrots.',
      price: 1.2,
      imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca', title: null,
    ),
    Product(
      id: '3',
      name: 'Lettuce',
      description: 'Green leafy lettuce.',
      price: 1.8,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', title: null,
    ),
    Product(
      id: '4',
      name: 'Potatoes',
      description: 'Organic potatoes.',
      price: 2.0,
      imageUrl: 'assets/images/farm_logo.jpg', title: null,
    ),
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products
        .where((p) =>
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
    // Removed duplicate cart icon, use FarmAppBar in parent
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No products found.'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 3,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                            ),
                            title: Text(product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(product.description),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('R ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.name} added to cart!'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(60, 30),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

