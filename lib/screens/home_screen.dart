import 'package:farm_bracket/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import '../models/farm_model.dart';
import '../widgets/farm_card.dart';
import '../services/hive_service.dart';
import '../widgets/advanced_filter_bottom_sheet.dart';
import 'products_grid.dart';

// Mock classes for state management
class CartState {
  final int itemCount;
  CartState({this.itemCount = 0});
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());
  void addItem() {
    state = CartState(itemCount: state.itemCount + 1);
  }
  void removeItem() {
    if (state.itemCount > 0) {
      state = CartState(itemCount: state.itemCount - 1);
    }
  }
}

// Filter classes
class HomeScreenFilter {
  final bool showFavoritesOnly;
  final bool openNow;
  final bool organic;
  final bool topRated;
  final String category;
  final String searchQuery;
  final double minDistance;
  final double maxDistance;
  final double price;
  HomeScreenFilter({
    this.showFavoritesOnly = false,
    this.openNow = false,
    this.organic = false,
    this.topRated = false,
    this.category = 'All',
    this.searchQuery = '',
    this.minDistance = 0,
    this.maxDistance = 50,
    this.price = 100,
  });
}

class HomeScreenFilterNotifier extends StateNotifier<HomeScreenFilter> {
  HomeScreenFilterNotifier() : super(HomeScreenFilter()) {
    _restoreFilterState();
  }
  Future<void> _restoreFilterState() async {
    final hiveService = HiveService();
    final saved = await hiveService.getHomeScreenFilter();
    if (saved != null) {
      state = saved;
    }
  }
  Future<void> _persistFilterState() async {
    final hiveService = HiveService();
    await hiveService.saveHomeScreenFilter(state);
  }
  void toggleFavorites() {
    state = HomeScreenFilter(
      showFavoritesOnly: !state.showFavoritesOnly,
      openNow: state.openNow,
      organic: state.organic,
      topRated: state.topRated,
      category: state.category,
      searchQuery: state.searchQuery,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: state.price,
    );
    _persistFilterState();
  }
  void toggleOpenNow() {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: !state.openNow,
      organic: state.organic,
      topRated: state.topRated,
      category: state.category,
      searchQuery: state.searchQuery,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: state.price,
    );
    _persistFilterState();
  }
  void toggleOrganic() {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: state.openNow,
      organic: !state.organic,
      topRated: state.topRated,
      category: state.category,
      searchQuery: state.searchQuery,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: state.price,
    );
    _persistFilterState();
  }
  void toggleTopRated() {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: state.openNow,
      organic: state.organic,
      topRated: !state.topRated,
      category: state.category,
      searchQuery: state.searchQuery,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: state.price,
    );
    _persistFilterState();
  }
  void setCategory(String category) {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: state.openNow,
      organic: state.organic,
      topRated: state.topRated,
      category: category,
      searchQuery: state.searchQuery,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: state.price,
    );
    _persistFilterState();
  }
  void setSearchQuery(String query) {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: state.openNow,
      organic: state.organic,
      topRated: state.topRated,
      category: state.category,
      searchQuery: query,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: state.price,
    );
    _persistFilterState();
  }
  void setDistanceRange(double min, double max) {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: state.openNow,
      organic: state.organic,
      topRated: state.topRated,
      category: state.category,
      searchQuery: state.searchQuery,
      minDistance: min,
      maxDistance: max,
      price: state.price,
    );
    _persistFilterState();
  }
  void setPrice(double price) {
    state = HomeScreenFilter(
      showFavoritesOnly: state.showFavoritesOnly,
      openNow: state.openNow,
      organic: state.organic,
      topRated: state.topRated,
      category: state.category,
      searchQuery: state.searchQuery,
      minDistance: state.minDistance,
      maxDistance: state.maxDistance,
      price: price,
    );
    _persistFilterState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});
final homeScreenFilterProvider = StateNotifierProvider<HomeScreenFilterNotifier, HomeScreenFilter>((ref) => HomeScreenFilterNotifier());

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Widget _buildUserProfileSummary(BuildContext context, WidgetRef ref) {
    final user = {
      'name': 'Jane Doe',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
      'favorites': 8,
      'orders': 12,
      'lastActive': 'Today',
    };
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user['avatar'] as String),
            radius: 24,
            backgroundColor: Colors.grey[200],
          ),
          title: Text(user['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('Favorites: ${user['favorites']}  Orders: ${user['orders']}'),
          trailing: Text('Active: ${user['lastActive']}', style: const TextStyle(fontSize: 12)),
        ),
      );
  }

  Widget _buildOnboardingTipsSection(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('Welcome to FarmersBracket!', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('• Use filters to find the freshest products near you.'),
            const Text('• Tap on a product for details and reviews.'),
            const Text('• Add favorites for quick access.'),
          ],
        ),
      ),
    );
  }

  void showSmartNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);
  String _selectedSort = 'Relevance';
  final searchQuery = ref.watch(homeScreenFilterProvider).searchQuery;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Marketplace'),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          _buildFavoritesFilterButton(context, ref),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: theme.colorScheme.surface,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildSearchField(context, ref),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildFilterChips(context, ref)),
                  IconButton(
                    icon: Icon(Icons.tune, color: theme.colorScheme.primary),
                    tooltip: 'Advanced Filters',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => AdvancedFilterBottomSheet(
                          onApply: (filters) {
                            ref.read(productsProvider.notifier).filterProducts(
                              categories: filters['categories'],
                              tags: filters['tags'],
                              farms: filters['farms'],
                              minPrice: filters['minPrice'],
                              maxPrice: filters['maxPrice'],
                              pickedToday: filters['pickedToday'],
                              organic: filters['organic'],
                              minRating: filters['minRating'],
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Filters applied: $filters')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: Text('Browse Categories', style: theme.textTheme.titleMedium),
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: ProductsProvider.categories.entries.map((entry) => GestureDetector(
                      onTap: () {
                        ref.read(productsProvider.notifier).filterProducts(categories: [entry.key]);
                      },
                      child: Card(
                        child: Center(child: Text(entry.value, textAlign: TextAlign.center)),
                      ),
                    )).toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Sort by:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedSort,
                    items: const [
                      DropdownMenuItem(value: 'Relevance', child: Text('Relevance')),
                      DropdownMenuItem(value: 'Price', child: Text('Price')),
                      DropdownMenuItem(value: 'Date', child: Text('Date')),
                    ],
                    onChanged: (value) {
                      // TODO: Integrate with provider for sorting
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // ...existing code...
              _buildFeaturedFarmsSection(context),
              const SizedBox(height: 16),
              _buildFeaturedProductsSection(context),
              const SizedBox(height: 16),
              // Insert ProductsGrid with searchQuery from filter provider
              ProductsGrid(searchQuery: searchQuery),
              const SizedBox(height: 16),
              _buildRecentProductsSectionEnhanced(context, ref),
              const SizedBox(height: 16),
              _buildPersonalizedRecommendationsSection(context, ref),
              const SizedBox(height: 16),
              _buildOnboardingTipsSection(context),
              const SizedBox(height: 16),
              _buildUserProfileSummary(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProductsSectionEnhanced(BuildContext context, WidgetRef ref) {
    // Get recent product IDs from Hive, then fetch product objects from provider
    return FutureBuilder<List<String>>(
      future: HiveService.getRecentlyViewedProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No recently viewed products.');
        }
        final recentIds = snapshot.data!;
        final allProducts = ref.watch(productsProvider).products;
        final recentProducts = allProducts.where((p) => recentIds.contains(p.id)).toList();
        if (recentProducts.isEmpty) {
          return const Text('No recently viewed products.');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recently Viewed Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recentProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final product = recentProducts[i];
                  final badges = <Widget>[];
                  if (product.isNewArrival == true) {
                    badges.add(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(8)),
                      child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ));
                  }
                  if (product.rating >= 4.5) {
                    badges.add(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Best Seller', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ));
                  }
                  if (product.isOnSale == true) {
                    badges.add(Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Discount', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ));
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/product_detail', arguments: product);
                    },
                    child: Card(
                      child: SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.imageUrl,
                                    height: 60,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: Row(children: badges),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('ID: ${product.id}', style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPersonalizedRecommendationsSection(BuildContext context, WidgetRef ref) {
    final productsProviderInstance = ref.watch(productsProvider);
    final recommendedProducts = productsProviderInstance.products
        .where((product) => product.rating >= 4.0 || product.isNewArrival == true)
        .take(5)
        .toList();
    if (recommendedProducts.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommended for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recommendedProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final product = recommendedProducts[i];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/product_detail', arguments: product);
                },
                child: Card(
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            height: 60,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('ID: ${product.id}', style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedFarmsSection(BuildContext context) {
    final featuredFarms = [
      const Farm(
        id: '1',
        name: 'Mbombela Citrus',
        description: 'Fresh citrus from Mpumalanga',
        imageUrl: 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        rating: 4.8,
        distance: 2.0,
        location: 'Mpumalanga',
        category: 'Fruit',
        products: [],
        price: 0,
        isFavorite: false, latitude: 0.0, longitude: 0.0, story: '', practiceLabels: [], imageUrls: [],
      ),
      const Farm(
        id: '2',
        name: 'Nelspruit Veg Farms',
        description: 'Organic vegetables and greens',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        rating: 4.5,
        distance: 5.0,
        location: 'Mpumalanga',
        category: 'Vegetables',
        products: [],
        price: 0,
        isFavorite: true, latitude: 0.0, longitude: 0.0, story: '', practiceLabels: [], imageUrls: [],
      ),
      const Farm(
        id: '3',
        name: 'Ermelo Berry Estate',
        description: 'Best berries in the region',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        rating: 4.9,
        distance: 8.0,
        location: 'Mpumalanga',
        category: 'Berries',
        products: [],
        price: 0,
        isFavorite: false, latitude: 0.0, longitude: 0.0, story: '', practiceLabels: [], imageUrls: [],
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Fruit & Veg Farms',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featuredFarms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final farm = featuredFarms[i];
              return FarmCard(
                farm: farm,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/farm_detail',
                    arguments: farm,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProductsSection(BuildContext context) {
    final featuredProducts = [
      {
        'name': 'Avocados',
        'farm': 'Mbombela Citrus',
        'image': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R24.99',
      },
      {
        'name': 'Table Grapes',
        'farm': 'Nelspruit Veg Farms',
        'image': 'https://images.unsplash.com/photo-1596363505729-4f52d5c04ae0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R17.99',
      },
      {
        'name': 'Blueberries',
        'farm': 'Ermelo Berry Estate',
        'image': 'https://images.unsplash.com/photo-1457276586916-e1e6b6e9ef98?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R29.99',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Fruit & Veg Products',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          semanticsLabel: 'Featured Fruit and Vegetable Products',
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final product = featuredProducts[i];
              final badges = <Widget>[];
              if (product['name']!.toLowerCase().contains('blue')) {
                badges.add(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(8)),
                  child: const Text('New', style: TextStyle(color: Colors.white, fontSize: 10)),
                ));
              }
              if (product['name']!.toLowerCase().contains('grape')) {
                badges.add(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Best Seller', style: TextStyle(color: Colors.white, fontSize: 10)),
                ));
              }
              if (product['price']!.contains('17')) {
                badges.add(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Discount', style: TextStyle(color: Colors.white, fontSize: 10)),
                ));
              }
              return Semantics(
                label: '${product['name']} from ${product['farm']}, price ${product['price']}',
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product_detail',
                      arguments: product,
                    );
                    // Haptic feedback for engagement
                    HapticFeedback.selectionClick();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 2,
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/default_profile.png',
                                      image: product['image']!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      imageSemanticLabel: product['name'],
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Row(children: badges),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name']!,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    semanticsLabel: product['name'],
                                  ),
                                  Text(
                                    product['farm']!,
                                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    semanticsLabel: product['farm'],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['price']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    semanticsLabel: product['price'],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildFavoritesFilterButton(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(homeScreenFilterProvider);
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: filter.showFavoritesOnly ? Colors.redAccent : Colors.grey[600],
      ),
      onPressed: () => ref.read(homeScreenFilterProvider.notifier).toggleFavorites(),
      tooltip: filter.showFavoritesOnly ? 'Show All' : 'Show Favorites',
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref) {
    final recentSearches = <String>["Avocado", "Grapes", "Blueberries", "Mbombela", "Organic"];
    final TextEditingController _controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search farms, products...',
            hintStyle: TextStyle(color: Colors.grey[700]),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          onChanged: (value) {
            ref.read(homeScreenFilterProvider.notifier).setSearchQuery(value);
          },
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: recentSearches.map((search) => ActionChip(
            label: Text(search),
            onPressed: () {
              _controller.text = search;
              ref.read(homeScreenFilterProvider.notifier).setSearchQuery(search);
            },
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(homeScreenFilterProvider);
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: const Text('Favorites'),
          selected: filter.showFavoritesOnly,
          onSelected: (selected) => ref.read(homeScreenFilterProvider.notifier).toggleFavorites(),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Colors.white,
          selectedColor: Colors.red[100],
          showCheckmark: false,
          avatar: const Icon(Icons.favorite, semanticLabel: 'Favorites'),
        ),
        InputChip(
          label: Text('Max Distance: ${filter.maxDistance.toStringAsFixed(0)} km'),
          selected: false,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(),
            );
          },
        ),
      ],
    );
  }
}
