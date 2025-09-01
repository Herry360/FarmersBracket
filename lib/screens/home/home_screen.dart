import 'package:farm_bracket/models/farm_model.dart';
import 'package:farm_bracket/models/featured_farms.dart';
import 'package:farm_bracket/screens/product/products_grid.dart';
import 'package:farm_bracket/services/hive_service.dart';
import 'package:farm_bracket/widgets/advanced_filter_bottom_sheet.dart';
import 'package:farm_bracket/widgets/farm_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Dummy ProductModel for demonstration
class ProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double rating;
  final bool isNewArrival;
  final bool isOnSale;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.rating = 0,
    this.isNewArrival = false,
    this.isOnSale = false,
  });
}

// Dummy productsProvider for demonstration
final productsProvider = StateNotifierProvider<ProductsProvider, ProductsProviderState>((ref) => ProductsProvider());

class ProductsProvider extends StateNotifier<ProductsProviderState> {
  ProductsProvider() : super(ProductsProviderState());

  static const categories = {
    'fruit': 'Fruit',
    'veg': 'Vegetables',
    'herbs': 'Herbs',
  };

  void filterProducts({
    List<String>? categories,
    List<String>? tags,
    List<String>? farms,
    double? minPrice,
    double? maxPrice,
    bool? pickedToday,
    bool? organic,
    double? minRating,
  }) {}

  void setSort(String value) {}

  void searchProducts(String query) {}
}

class ProductsProviderState {
  final List<ProductModel> products;
  final String selectedSort;

  ProductsProviderState({
    this.products = const [],
    this.selectedSort = 'Relevance',
  });
}

// Dummy homeScreenFilterProvider for demonstration
final homeScreenFilterProvider = StateNotifierProvider<HomeScreenFilterProvider, HomeScreenFilter>((ref) => HomeScreenFilterProvider());

class HomeScreenFilterProvider extends StateNotifier<HomeScreenFilter> {
  HomeScreenFilterProvider() : super(HomeScreenFilter());

  void toggleFavorites() {
    state = state.copyWith(showFavoritesOnly: !state.showFavoritesOnly);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

class HomeScreenFilter {
  final bool showFavoritesOnly;
  final String searchQuery;

  HomeScreenFilter({
    this.showFavoritesOnly = false,
    this.searchQuery = '',
  });

  HomeScreenFilter copyWith({
    bool? showFavoritesOnly,
    String? searchQuery,
  }) {
    return HomeScreenFilter(
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// Dummy farmProvider for demonstration
final farmProvider = Provider<FarmModel>((ref) => FarmModel(
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      rating: 0,
      distance: 0,
      location: '',
      category: '',
      products: [],
      price: 0,
      isFavorite: false,
      latitude: 0.0,
      longitude: 0.0,
      story: '',
      practiceLabels: [],
      imageUrls: [],
      size: 0.0,
      crops: [],
      established: DateTime.now(),
    ));

Widget _buildUserProfileSummary(BuildContext context, WidgetRef ref) {
  final String name = 'Jane Doe';
  final String avatar = 'https://randomuser.me/api/portraits/women/44.jpg';
  final int favorites = 8;
  final int orders = 12;
  final String lastActive = 'Today';
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 24,
        backgroundColor: Colors.grey[200],
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Favorites: $favorites  Orders: $orders'),
      trailing: Text(
        'Active: $lastActive',
        style: const TextStyle(fontSize: 12),
      ),
    ),
  );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void showSmartNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final productsProv = ref.watch(productsProvider);
    final selectedSort = productsProv.selectedSort;
    final searchQuery = ref.watch(homeScreenFilterProvider).searchQuery;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Marketplace'),
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          _buildFavoritesFilterButton(context, ref),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: theme.colorScheme.surface,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildSearchField(context, ref),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.tune, color: theme.colorScheme.primary),
                    tooltip: 'Advanced Filters',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => AdvancedFilterBottomSheet(
                          onApply: (filters) {
                            ref
                                .read(productsProvider.notifier)
                                .filterProducts(
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
                              SnackBar(
                                content: Text('Filters applied: $filters'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                        value: 'Relevance',
                        child: Text('Relevance'),
                      ),
                      DropdownMenuItem(value: 'Price', child: Text('Price')),
                      DropdownMenuItem(value: 'Date', child: Text('Date')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(productsProvider.notifier).setSort(value);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.help_outline,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Help Center',
                    onPressed: () {
                      Navigator.pushNamed(context, '/help-center');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ExpansionTile(
                title: Text(
                  'Browse Categories',
                  style: theme.textTheme.titleMedium,
                ),
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: ProductsProvider.categories.entries
                        .map(
                          (entry) => GestureDetector(
                            onTap: () {
                              ref
                                  .read(productsProvider.notifier)
                                  .filterProducts(categories: [entry.key]);
                            },
                            child: Card(
                              child: Center(
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Sort by:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                        value: 'Relevance',
                        child: Text('Relevance'),
                      ),
                      DropdownMenuItem(value: 'Price', child: Text('Price')),
                      DropdownMenuItem(value: 'Date', child: Text('Date')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(productsProvider.notifier).setSort(value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFeaturedFarmsSection(context),
              const SizedBox(height: 16),
              _buildFeaturedProductsSection(context),
              const SizedBox(height: 16),
              ProviderScope(
                overrides: [
                  farmProvider.overrideWithValue(
                    featuredFarms.isNotEmpty
                        ? featuredFarms[0] as FarmModel
                        : FarmModel(
                            id: '',
                            name: '',
                            description: '',
                            imageUrl: '',
                            rating: 0,
                            distance: 0,
                            location: '',
                            category: '',
                            products: [],
                            price: 0,
                            isFavorite: false,
                            latitude: 0.0,
                            longitude: 0.0,
                            story: '',
                            practiceLabels: [],
                            imageUrls: [],
                            size: 0.0,
                            crops: [],
                            established: DateTime.now(),
                          ),
                  ),
                ],
                child: ProductsGrid(searchQuery: searchQuery),
              ),
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

  Widget _buildRecentProductsSectionEnhanced(
    BuildContext context,
    WidgetRef ref,
  ) {
    return FutureBuilder<List<String>>(
      future: HiveService.getRecentlyViewedProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No recently viewed products.');
        }
        final recentIds = snapshot.data!;
        final allProducts = ref.watch(productsProvider).products;
        final recentProducts = allProducts
            .where((p) => recentIds.contains(p.id))
            .toList();
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
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final product = recentProducts[i];
                  final badges = <Widget>[];
                  if (product.isNewArrival == true) {
                    badges.add(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'New',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  if (product.rating >= 4.5) {
                    badges.add(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Best Seller',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  if (product.isOnSale == true) {
                    badges.add(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Discount',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/product_detail',
                        arguments: product,
                      );
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 32,
                                              color: Colors.grey,
                                            ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  left: 4,
                                  child: SizedBox.shrink(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ID: ${product.id}',
                              style: const TextStyle(fontSize: 10),
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
        );
      },
    );
  }

  Widget _buildPersonalizedRecommendationsSection(
    BuildContext context,
    WidgetRef ref,
  ) {
    return FutureBuilder<Box>(
      future: Hive.openBox('settings'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final settingsBox = snapshot.data!;
        final interests = settingsBox.get(
          'interests',
          defaultValue: <String>[],
        );
        final productsProviderInstance = ref.watch(productsProvider);
        final recommendedProducts = productsProviderInstance.products
            .where(
              (product) => interests.any(
                (interest) => product.category.toLowerCase().contains(
                  interest.toLowerCase(),
                ),
              ),
            )
            .toList();
        if (recommendedProducts.isEmpty) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommended for You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedProducts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final product = recommendedProducts[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/product_detail',
                        arguments: product,
                      );
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
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 32,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'ID: ${product.id}',
                              style: const TextStyle(fontSize: 10),
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
        );
      },
    );
  }

  Widget _buildFeaturedFarmsSection(BuildContext context) {
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
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final farm = featuredFarms[i];
              return FarmCard(
                farm: farm as FarmModel,
                onTap: () {
                  Navigator.pushNamed(context, '/farm_detail', arguments: farm);
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
        'image':
            'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R24.99',
      },
      {
        'name': 'Table Grapes',
        'farm': 'Nelspruit Veg Farms',
        'image':
            'https://images.unsplash.com/photo-1596363505729-4f52d5c04ae0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R17.99',
      },
      {
        'name': 'Blueberries',
        'farm': 'Ermelo Berry Estate',
        'image':
            'https://images.unsplash.com/photo-1457276586916-e1e6b6e9ef98?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
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
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final product = featuredProducts[i];
              final badges = <Widget>[];
              if (product['name']!.toLowerCase().contains('blue')) {
                badges.add(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              }
              if (product['name']!.toLowerCase().contains('grape')) {
                badges.add(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Best Seller',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              }
              if (product['price']!.contains('17')) {
                badges.add(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Discount',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                );
              }
              return Semantics(
                label:
                    '${product['name']} from ${product['farm']}, price ${product['price']}',
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product_detail',
                      arguments: product,
                    );
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
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/default_profile.png',
                                      image: product['image'] ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      imageSemanticLabel: product['name'] ?? '',
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    semanticsLabel: product['name'],
                                  ),
                                  Text(
                                    product['farm']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    semanticsLabel: product['farm'],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['price']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
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
      onPressed: () =>
          ref.read(homeScreenFilterProvider.notifier).toggleFavorites(),
      tooltip: filter.showFavoritesOnly ? 'Show All' : 'Show Favorites',
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref
          .read(homeScreenFilterProvider.notifier)
          .setSearchQuery(controller.text);
    });
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search for products, farms, or categories',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.search),
      ),
      onSubmitted: (value) {
        ref.read(productsProvider.notifier).searchProducts(value);
      },
    );
  }

  Widget _buildOnboardingTipsSection(BuildContext context) {
    return Card(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Welcome to FarmersBracket!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('• Use filters to find the freshest products near you.'),
            Text('• Tap on a product for details and reviews.'),
            Text('• Add favorites for quick access.'),
          ],
        ),
      ),
    );
  }
}