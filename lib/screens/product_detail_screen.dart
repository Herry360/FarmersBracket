

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/auth_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;

  List<String> get imageUrls => widget.product.images.isNotEmpty ? widget.product.images : [widget.product.imageUrl];

  @override
  Widget build(BuildContext context) {
  final favoritesNotifier = ref.read(favoritesProvider.notifier);
  final isFavorite = favoritesNotifier.isFavorite(widget.product.id);
  final cartNotifier = ref.read(cartProvider.notifier);
  final cartState = ref.watch(cartProvider);
  final cartItems = cartState.items;
  final isInCart = cartItems.any((item) => item.productId == widget.product.id);
    final userId = ref.read(authProvider).currentUser?.id;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.product.name),
          actions: [
            IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              tooltip: isFavorite ? 'Unfavourite' : 'Favourite',
              onPressed: userId == null
                  ? null
                  : () async {
                      if (isFavorite) {
                        await favoritesNotifier.removeFavorite(userId, widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed from favourites')),
                        );
                      } else {
                        await favoritesNotifier.addFavorite(userId, widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to favourites')),
                        );
                      }
                    },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image gallery with Hero and dot indicators
                  SizedBox(
                    height: 250,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: 'product-image-${imageUrls[index]}',
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(imageUrls.length, (index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('R ${widget.product.price.toStringAsFixed(2)} / ${widget.product.unit.isNotEmpty ? widget.product.unit : "unit"}', style: const TextStyle(fontSize: 18, color: Colors.green)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (widget.product.isOrganic) Chip(label: const Text('Organic'), backgroundColor: Colors.lightGreen[100]),
                            if (widget.product.isFeatured) Chip(label: const Text('Featured'), backgroundColor: Colors.yellow[100]),
                            if (widget.product.isSeasonal) Chip(label: const Text('Seasonal'), backgroundColor: Colors.blue[100]),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Stock: ${widget.product.stock} ${widget.product.unit}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Harvest Date: ${widget.product.harvestDate != null ? widget.product.harvestDate!.toLocal().toString().split(' ')[0] : "N/A"}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Category: ${widget.product.category}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.product.description, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  const TabBar(
                    tabs: [
                      Tab(text: 'Farm Info'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'More'),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Farm Name: ${widget.product.farmName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Farm ID: ${widget.product.farmId}'),
                              // Add more farm info if available
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Reviews: ${widget.product.reviewCount} | Rating: ${widget.product.rating.toStringAsFixed(1)}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Created: ${widget.product.createdAt != null ? widget.product.createdAt!.toLocal().toString().split(' ')[0] : "N/A"}\nUpdated: ${widget.product.updatedAt != null ? widget.product.updatedAt!.toLocal().toString().split(' ')[0] : "N/A"}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Sticky bottom action bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('R ${widget.product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                            ),
                            Text('$quantity', style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => quantity++),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: isInCart || userId == null
                          ? null
                          : () async {
                              final cartItem = CartItem(
                                id: widget.product.id,
                                productId: widget.product.id,
                                name: widget.product.name,
                                price: widget.product.price,
                                imageUrl: widget.product.imageUrl,
                                farmId: widget.product.farmId,
                                farmName: widget.product.farmName,
                                quantity: quantity,
                                unit: widget.product.unit,
                              );
                              await cartNotifier.addToCart(userId, cartItem);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Added to cart')),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(isInCart ? 'Added to Cart' : 'Add to Cart', style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
