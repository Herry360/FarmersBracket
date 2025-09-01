import 'package:farm_bracket/models/product_model.dart';
import 'package:farm_bracket/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the Farm class here or import it from your models
class Farm {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final double distance;
  final double latitude;
  final double longitude;
  final String story;
  final List<String> practiceLabels;
  final List<String> imageUrls;
  final String category;
  final List<Product> products;
  final double price;
  final bool isFavorite;
  final String location;

  Farm({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.story,
    required this.practiceLabels,
    required this.imageUrls,
    required this.category,
    required this.products,
    required this.price,
    required this.isFavorite,
    required this.location,
  });

  // For compatibility with your widget code
  List<String> get practices => practiceLabels;
  List<String> get images => imageUrls;
}

class FarmProfileScreen extends ConsumerStatefulWidget {
  final String farmId;
  const FarmProfileScreen({super.key, required this.farmId});

  @override
  ConsumerState<FarmProfileScreen> createState() => _FarmProfileScreenState();
}

class _FarmProfileScreenState extends ConsumerState<FarmProfileScreen> {
  Farm? farm;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    products = ref.read(productsProvider).getProductsByFarm(widget.farmId);
    if (products.isNotEmpty) {
      final firstProduct = products.first;
      farm = Farm(
        id: widget.farmId,
        name: firstProduct.farmName,
        description: 'No description available',
        imageUrl: firstProduct.imageUrl,
        rating: firstProduct.rating,
        distance: 0.0,
        latitude: firstProduct.latitude,
        longitude: firstProduct.longitude,
        story: '',
        practiceLabels: [],
        imageUrls: [firstProduct.imageUrl],
        category: firstProduct.category,
        products: products,
        price: firstProduct.price,
        isFavorite: false,
        location: '',
      );
    } else {
      farm = Farm(
        id: widget.farmId,
        name: 'Unknown Farm',
        description: 'No description available',
        imageUrl: '',
        rating: 0.0,
        distance: 0.0,
        latitude: 0.0,
        longitude: 0.0,
        story: '',
        practiceLabels: [],
        imageUrls: [],
        category: '',
        products: [],
        price: 0.0,
        isFavorite: false,
        location: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(farm?.name ?? 'Farm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Farm Story',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(farm?.story ?? ''),
            const SizedBox(height: 16),
            const Text(
              'Practices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children:
                  farm?.practices.map((p) => Chip(label: Text(p))).toList() ??
                  [],
            ),
            const SizedBox(height: 16),
            const Text(
              'Gallery',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: farm?.images.length ?? 0,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      farm?.images[i] ?? '',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/productDetail',
                        arguments: p.id,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            p.imageUrl,
                            height: 90,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.description,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}