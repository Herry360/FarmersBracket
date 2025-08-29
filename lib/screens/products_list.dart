import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';
import '../providers/cart_provider.dart' as cart_provider;
import '../providers/favorites_provider.dart';
import '../widgets/product_card.dart';
// ...existing code...
import 'cart_screen.dart';

class ProductsList extends ConsumerWidget {
  final List<Product> products;

  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final cartProviderInstance = ref.watch(cart_provider.cartProvider);
    final cartItems = cartProviderInstance.items;
    final cartNotifier = ref.read(cart_provider.cartProvider.notifier);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    // UI only: no userId needed

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
                final isFav = favoritesState.favorites.any(
                  (p) => p.id == product.id,
                );
                final isInCart = cartItems.any(
                  (item) => item.productId == product.id,
                );
                return ProductCard(
                  key: ValueKey(product.id),
                  product: product,
                  isInCart: isInCart,
                  isFavorite: isFav,
                  onAddToCart: () {
                    final cartItem = cart_provider.CartItem(
                      id: product.id,
                      productId: product.id,
                      name: product.name,
                      price: product.price,
                      imageUrl: product.imageUrl,
                      farmId: product.farmId,
                      farmName: product.farmName,
                      quantity: 1,
                      unit: product.unit,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CartScreen()),
                            );
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
