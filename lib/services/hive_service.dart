import 'package:farm_bracket/screens/home/home_screen.dart';
import 'package:hive/hive.dart';
import '../models/home_screen_filter.dart';

class HiveService {
  static Future<void> addRecentlyViewedProduct(String productId) async {
    var box = await Hive.openBox('recently_viewed');
    List<String> products = List<String>.from(
      box.get('recent_products', defaultValue: []),
    );
    products.remove(productId);
    products.insert(0, productId);
    if (products.length > 10) products = products.sublist(0, 10);
    await box.put('recent_products', products);
  }

  static Future<List<String>> getRecentlyViewedProducts() async {
    var box = await Hive.openBox('recently_viewed');
    return List<String>.from(box.get('recent_products', defaultValue: []));
  }

  Future<HomeScreenFilterModel?> getHomeScreenFilterModel() async {
    var box = await Hive.openBox('home_screen_filter');
    final data = box.get('filter');
    if (data == null) return null;
    // Assuming data is a Map<String, dynamic>
    return HomeScreenFilterModel(
      showFavoritesOnly: data['showFavoritesOnly'] ?? false,
      openNow: data['openNow'] ?? false,
      organic: data['organic'] ?? false,
      topRated: data['topRated'] ?? false,
      category: data['category'] ?? 'All',
      searchQuery: data['searchQuery'] ?? '',
      minDistance: (data['minDistance'] ?? 0).toDouble(),
      maxDistance: (data['maxDistance'] ?? 50).toDouble(),
      price: (data['price'] ?? 100).toDouble(), selectedCategories: [], selectedPriceRange: null, selectedSortOption: '',
    );
  }

  Future<void> saveHomeScreenFilterModel(HomeScreenFilterModel filter) async {
    var box = await Hive.openBox('home_screen_filter');
    await box.put('filter', {
      'showFavoritesOnly': filter.showFavoritesOnly,
      'openNow': filter.openNow,
      'organic': filter.organic,
      'topRated': filter.topRated,
      'category': filter.category,
      'searchQuery': filter.searchQuery,
      'minDistance': filter.minDistance,
      'maxDistance': filter.maxDistance,
      'price': filter.price,
    });
  }

  Future getHomeScreenFilter() async {}

  Future<void> saveHomeScreenFilter(HomeScreenFilter state) async {}
}
