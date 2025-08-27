import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';
import '../providers/cart_provider.dart' as cart_provider;
import '../providers/favorites_provider.dart';
import '../widgets/product_card.dart';
import '../providers/auth_provider.dart';
import 'cart_screen.dart';

class ProductsList extends ConsumerWidget {
  final List<Product> products;

  const ProductsList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final favoritesState = ref.watch(favoritesProvider);
  final cartProviderInstance = ref.watch(cart_provider.cartProvider);
  final cartItems = cartProviderInstance.items;
  final cartNotifier = ref.read(cart_provider.cartProvider.notifier);
  final favoritesNotifier = ref.read(favoritesProvider.notifier);
  final userId = ref.read(authProvider).currentUser?.id;

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
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  final isFav = favoritesState.favorites.any((p) => p.id == product.id);
                  return ProductCard(
                    key: ValueKey(product.id),
                    product: product,
                    isInCart: cartItems.any((item) => item.productId == product.id),
                    onAddToCart: () {
                      if (userId == null) return;
                      final cartItem = cart_provider.CartItem(
                        id: product.id,
                        productId: product.id,
                        name: product.name,
                        price: product.price,
                        imageUrl: product.imageUrl,
                        farmId: product.farmId,
                        farmName: product.farmName,
                        quantity: product.quantity,
                        unit: product.unit,
                      );
                      cartNotifier.addToCart(userId, cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${product.title} to cart'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          action: SnackBarAction(
                            label: 'View Cart',
                            textColor: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CartScreen()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    isFavorite: isFav,
                    onFavoritePressed: () {
                      if (userId == null) return;
                      if (isFav) {
                        favoritesNotifier.removeFavorite(userId, product.id);
                      } else {
                        favoritesNotifier.addFavorite(userId, product.id);
                      }
                    },
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
