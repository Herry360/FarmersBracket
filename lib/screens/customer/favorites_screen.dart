import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/empty_states/empty_favorites_widget.dart';
import '../../../widgets/product_card.dart';
import '../../../constants/app_strings.dart';
import '../../../providers/favorites_provider.dart';
import '../../../utils/layout_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoritesProvider _favoritesProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    await favoritesProvider.loadFavorites();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.favorites),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_favoritesProvider.favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showClearAllDialog,
              tooltip: 'Clear all favorites',
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return const LoadingShimmer(type: ShimmerType.favorites);
          }

          if (_favoritesProvider.favorites.isEmpty) {
            return EmptyFavoritesWidget(
              heading: AppStrings.emptyFavoritesTitle,
              message: AppStrings.emptyFavoritesMessage,
              onActionPressed: () {
                Navigator.pushNamed(context, '/products');
              },
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFavorites,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: LayoutHelper.getGridCrossAxisCount(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _favoritesProvider.favorites.length,
              itemBuilder: (context, index) {
                final product = _favoritesProvider.favorites[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-details',
                      arguments: product,
                    );
                  },
                  onFavoriteToggle: () {
                    _favoritesProvider.toggleFavorite(product);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              _favoritesProvider.clearAllFavorites();
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
