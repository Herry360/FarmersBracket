import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
// import '../providers/auth_provider.dart';
import '../models/farm_model.dart';
import '../providers/cart_provider.dart' as cart_data;
import '../widgets/product_card.dart';
// Ensure ProductCard uses Product from models/farm_model.dart
import 'cart_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider).favorites;
    final cartItems = ref.watch(cart_data.cartProvider).items;
    // final isSignedIn = authProvider.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            ),
          ),
        ],
      ),
      body: (favorites.isEmpty
          ? _buildEmptyState(context)
          : _buildFavoritesGrid(context, favorites, ref, cartItems)),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: Theme.of(context).colorScheme.secondary.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon to add products',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(
    BuildContext context,
    List<Product> favorites,
    WidgetRef ref,
    List<cart_data.CartItem> cartItems,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '${favorites.length} ${favorites.length == 1 ? 'item' : 'items'}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showClearAllDialog(context, ref),
                child: Text(
                  'Clear All',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (ctx, index) => ProductCard(
              product: favorites[index],
              isInCart: cartItems.any(
                (item) => item.productId == favorites[index].id,
              ),
              isFavorite: true,
              onFavoritePressed: () {
                final favNotifier = ref.read(favoritesProvider.notifier);
                final isFav = favNotifier.isFavorite(favorites[index].id);
                if (isFav) {
                  favNotifier.removeFavorite(favorites[index].id);
                } else {
                  favNotifier.addFavorite(favorites[index]);
                }
              },
              onAddToCart: () {
                final product = favorites[index];
                final cartItem = cart_data.CartItem(
                  id: product.id,
                  productId: product.id,
                  name: product.title,
                  price: product.price,
                  imageUrl: product.imageUrl,
                  farmId: product.farmId,
                  farmName: product.farmName,
                  quantity: 1,
                  unit: product.unit,
                );
                ref.read(cart_data.cartProvider.notifier).addToCart(cartItem);
                _showAddedToCartSnackbar(context, product);
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all favorites?'),
        content: const Text(
          'Are you sure you want to remove all items from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).clearFavorites();
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddedToCartSnackbar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          ),
        ),
      ),
    );
  }
}
