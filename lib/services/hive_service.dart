import 'package:hive/hive.dart';
import '../screens/home_screen.dart';

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

  Future<HomeScreenFilter?> getHomeScreenFilter() async {
    var box = await Hive.openBox('home_screen_filter');
    final data = box.get('filter');
    if (data == null) return null;
    // Assuming data is a Map<String, dynamic>
    return HomeScreenFilter(
      showFavoritesOnly: data['showFavoritesOnly'] ?? false,
      openNow: data['openNow'] ?? false,
      organic: data['organic'] ?? false,
      topRated: data['topRated'] ?? false,
      category: data['category'] ?? 'All',
      searchQuery: data['searchQuery'] ?? '',
      minDistance: (data['minDistance'] ?? 0).toDouble(),
      maxDistance: (data['maxDistance'] ?? 50).toDouble(),
      price: (data['price'] ?? 100).toDouble(),
    );
  }

  Future<void> saveHomeScreenFilter(HomeScreenFilter filter) async {
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
}
