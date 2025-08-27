import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:badges/badges.dart' as badges;

// Mock providers (replace with your actual implementations)
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});

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
  HomeScreenFilterNotifier() : super(HomeScreenFilter());
  
  void toggleFavorites() => state = HomeScreenFilter(
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
  
  void toggleOpenNow() => state = HomeScreenFilter(
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
  
  void toggleOrganic() => state = HomeScreenFilter(
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
  
  void toggleTopRated() => state = HomeScreenFilter(
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
  
  void setCategory(String category) => state = HomeScreenFilter(
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
  
  void setSearchQuery(String query) => state = HomeScreenFilter(
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
  
  void setDistanceRange(double min, double max) => state = HomeScreenFilter(
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
  
  void setPrice(double price) => state = HomeScreenFilter(
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
}

final homeScreenFilterProvider = StateNotifierProvider<HomeScreenFilterNotifier, HomeScreenFilter>((ref) => HomeScreenFilterNotifier());

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Marketplace'),
        actions: [
          _buildCartButton(context, ref),
          _buildFavoritesFilterButton(context, ref),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 2,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(homeScreenFilterProvider);
          ref.invalidate(cartProvider);
          await Future.delayed(const Duration(seconds: 1));
        },
        displacement: 40,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(context, ref),
              const SizedBox(height: 16),
              _buildFilterChips(context, ref),
              const SizedBox(height: 16),
              _buildFeaturedFarmsSection(context),
              const SizedBox(height: 16),
              _buildFeaturedProductsSection(context),
              const SizedBox(height: 16),
              _buildRecentProductsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProductsSection(BuildContext context) {
    final recentProducts = [
      {
        'name': 'Spinach',
        'farm': 'Mbombela Citrus',
        'image': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R19.99',
      },
      {
        'name': 'Tomatoes',
        'farm': 'Nelspruit Veg Farms',
        'image': 'https://images.unsplash.com/photo-1561136594-7f68413baa99?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R14.99',
      },
      {
        'name': 'Carrots',
        'farm': 'Ermelo Berry Estate',
        'image': 'https://images.unsplash.com/photo-1445282768818-728615cc910a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'price': 'R9.99',
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Products Near You', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final product = recentProducts[i];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product_detail',
                    arguments: product,
                  );
                },
                child: Card(
                  elevation: 2,
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              product['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
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
                              ),
                              Text(
                                product['farm']!,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['price']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
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
  }

  Widget _buildFeaturedFarmsSection(BuildContext context) {
    final featuredFarms = [
      {
        'name': 'Mbombela Citrus',
        'location': 'Mpumalanga',
        'image': 'https://images.unsplash.com/photo-1502741338009-cac2772e18bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'rating': '4.8',
      },
      {
        'name': 'Nelspruit Veg Farms',
        'location': 'Mpumalanga',
        'image': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'rating': '4.5',
      },
      {
        'name': 'Ermelo Berry Estate',
        'location': 'Mpumalanga',
        'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=600&q=80',
        'rating': '4.9',
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Fruit & Veg Farms', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featuredFarms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final farm = featuredFarms[i];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/farm_detail',
                    arguments: farm,
                  );
                },
                child: Card(
                  elevation: 2,
                  child: SizedBox(
                    width: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              farm['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farm['name']!, 
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      farm['location']!,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 12, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    farm['rating']!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
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
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product_detail',
                    arguments: product,
                  );
                },
                child: Card(
                  elevation: 2,
                  child: SizedBox(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              product['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
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
                              ),
                              Text(
                                product['farm']!,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['price']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
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
  }

  Widget _buildCartButton(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -10, end: -10),
      badgeContent: Text(
        '$cartCount', 
        style: const TextStyle(color: Colors.white, fontSize: 12)
      ),
      showBadge: cartCount > 0,
      child: IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        tooltip: 'Cart',
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
      ),
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
    return TextField(
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
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(homeScreenFilterProvider);
    final chips = [
      FilterChip(
        label: const Text('Favorites'),
        selected: filter.showFavoritesOnly,
        onSelected: (selected) => ref.read(homeScreenFilterProvider.notifier).toggleFavorites(),
      ),
      InputChip(
        label: Text('Max Distance: ${filter.maxDistance.toStringAsFixed(0)} km'),
        selected: false,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              double tempDistance = filter.maxDistance;
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Set Max Distance (km)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          min: 1,
                          max: 100,
                          divisions: 99,
                          value: tempDistance,
                          label: '${tempDistance.toStringAsFixed(0)} km',
                          onChanged: (val) => setState(() => tempDistance = val),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(homeScreenFilterProvider.notifier).setDistanceRange(0, tempDistance);
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      FilterChip(
        label: const Text('Open Now'),
        selected: filter.openNow,
        onSelected: (selected) => ref.read(homeScreenFilterProvider.notifier).toggleOpenNow(),
      ),
      FilterChip(
        label: const Text('Organic'),
        selected: filter.organic,
        onSelected: (selected) => ref.read(homeScreenFilterProvider.notifier).toggleOrganic(),
      ),
      FilterChip(
        label: const Text('Top Rated'),
        selected: filter.topRated,
        onSelected: (selected) => ref.read(homeScreenFilterProvider.notifier).toggleTopRated(),
      ),
      // Price filter (slider)
      InputChip(
        label: Text('Max Price: R${filter.price.toStringAsFixed(2)}'),
        selected: false,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              double tempPrice = filter.price;
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Set Max Price (ZAR)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          min: 0,
                          max: 1000,
                          divisions: 100,
                          value: tempPrice,
                          label: 'R${tempPrice.toStringAsFixed(2)}',
                          onChanged: (val) => setState(() => tempPrice = val),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(homeScreenFilterProvider.notifier).setPrice(tempPrice);
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Location filter (dropdown)
      InputChip(
        label: const Text('Location'),
        selected: false,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              final locations = ['All', 'Mpumalanga', 'Gauteng', 'Western Cape', 'KwaZulu-Natal'];
              String selectedLocation = filter.category;
              return StatefulBuilder(
                builder: (context, setState) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Select Location', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: selectedLocation,
                          items: locations.map((loc) => DropdownMenuItem(
                            value: loc,
                            child: Text(loc),
                          )).toList(),
                          onChanged: (val) => setState(() => selectedLocation = val ?? 'All'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(homeScreenFilterProvider.notifier).setCategory(selectedLocation);
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }
}