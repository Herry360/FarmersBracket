import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/farm_model.dart';

final productsProvider = ChangeNotifierProvider<ProductsProvider>((ref) => ProductsProvider());

// Product model is now unified in models/farm_model.dart

class ProductsProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // South African produce categories
  static const Map<String, String> categories = {
    'all': 'All Products',
    'fruits': 'Fruits',
    'vegetables': 'Vegetables',
    'dairy': 'Dairy & Eggs',
    'meat': 'Meat & Poultry',
    'herbs': 'Herbs & Spices',
    'grains': 'Grains & Legumes',
    'honey': 'Honey & preserves',
  };

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('products')
          .select()
          .order('name');

      _products = response.map((data) => Product(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        price: (data['price'] ?? 0.0).toDouble(),
        imageUrl: data['imageUrl'] ?? '',
        farmId: data['farmId'] ?? '',
        farmName: data['farmName'] ?? '',
        category: data['category'] ?? '',
        unit: data['unit'] ?? '',
        isOrganic: data['isOrganic'] ?? false,
        isSeasonal: data['isSeasonal'] ?? false,
        rating: (data['rating'] ?? 0.0).toDouble(),
        reviewCount: data['reviewCount'] ?? 0,
        harvestDate: data['harvestDate'] != null ? DateTime.tryParse(data['harvestDate']) : null,
        stock: (data['stock'] ?? 0.0).toDouble(),
        quantity: data['quantity'] ?? 1, title: '',
      )).toList();
      _applyFilters();
      
    } catch (e) {
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
  _filteredProducts = _products.where((product) {
    final matchesCategory = _selectedCategory == 'all' || 
      product.category == _selectedCategory;
    final matchesSearch = _searchQuery.isEmpty || 
      product.name.toLowerCase().contains(_searchQuery) || 
      product.description.toLowerCase().contains(_searchQuery) || 
      product.farmName.toLowerCase().contains(_searchQuery);
    return matchesCategory && matchesSearch;
  }).toList();
  }

  List<Product> getProductsByFarm(String farmId) {
    return _products.where((product) => product.farmId == farmId).toList();
  }

  List<Product> getFeaturedProducts() {
    return _products.where((product) => product.rating >= 4.5).take(8).toList();
  }

  List<Product> getSeasonalProducts() {
    final currentMonth = DateTime.now().month;
    return _products.where((product) {
      if (product.harvestDate == null) return false;
      final harvestMonth = product.harvestDate!.month;
      return harvestMonth == currentMonth || harvestMonth == currentMonth + 1;
    }).toList();
  }
}

