import 'package:farm_bracket/models/cart_item.dart';
import 'package:farm_bracket/models/product_model.dart';
import 'package:farm_bracket/providers/cart_provider.dart';
import 'package:farm_bracket/providers/favorites_provider.dart';
import 'package:farm_bracket/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsList extends ConsumerWidget {
  final List<Product> products;

  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesProviderInstance = ref.watch(favoritesProvider);
    final cartProviderInstance = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                final isFav = favoritesProviderInstance.isFavorite(product.id);
                final isInCart = cartProviderInstance.items.containsKey(product.id);

                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                  isInCart: isInCart,
                  isFavorite: isFav,
                  onAddToCart: () {
                    final cartItem = CartItem(
                      id: DateTime.now().toString(),
                      productId: product.id,
                      title: product.title,
                      farmId: product.farmId ?? '',
                      farmName: product.farmName ?? '',
                      unit: product.unit ?? '',
                      price: product.price,
                      quantity: 1,
                      imageUrl: product.imageUrl ?? '',
                    );
                    
                    cartNotifier.addToCart(cartItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${product.title} to cart'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        action: SnackBarAction(
                          label: 'View Cart',
                          textColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            Navigator.pushNamed(context, "/cart");
                          },
                        ),
                      ),
                    );
                  },
                  onFavoritePressed: () {
                    if (isFav) {
                      favoritesNotifier.removeFavorite(product.id);
                    } else {
                      favoritesNotifier.addFavorite(product);
                    }
                  },
                );
              }, childCount: products.length),
            ),
          ),
        ],
      ),
    );
  }
}