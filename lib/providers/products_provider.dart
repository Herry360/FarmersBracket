import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/farm_model.dart';

final productsProvider = ChangeNotifierProvider<ProductsProvider>((ref) {
  // final supabase = Supabase.instance.client;
  // return ProductsProvider(supabase);
  return ProductsProvider();
});

// Product model is now unified in models/farm_model.dart

class ProductsProvider with ChangeNotifier {
  // Public getters for filter state
  bool? get organic => _organic;
  bool? get onlyAvailable => _onlyAvailable;
  bool? get onlyOnSale => _onlyOnSale;
  bool? get onlyNewArrival => _onlyNewArrival;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  // final SupabaseClient _supabase;
  ProductsProvider();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String? _error;
  double? _minPrice;
  double? _maxPrice;
  double? _maxDistanceKm;
  String? _certification;
  bool? _onlyAvailable;
  bool? _onlyOnSale;
  bool? _onlyNewArrival;
  double? _minRating;
  double? _userLatitude;
  double? _userLongitude;

  List<String> _selectedCategories = [];
  List<String> _selectedTags = [];
  List<String> _selectedFarms = [];
  bool? _pickedToday;
  bool? _organic;

  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String? get error => _error;

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
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // Populate with 10 placeholder products for UI testing
      _products = List.generate(10, (i) => Product(
        id: 'prod_$i',
        name: 'Product $i',
        description: 'Description for product $i',
        price: 10.0 + i,
        imageUrl: '',
        images: [],
        farmId: 'farm_${i % 3}',
        farmName: 'Farm ${i % 3}',
        category: i % 2 == 0 ? 'fruits' : 'vegetables',
        unit: 'kg',
        isOrganic: i % 2 == 0,
        isFeatured: i % 3 == 0,
        isSeasonal: i % 2 == 1,
        isOnSale: i % 4 == 0,
        isNewArrival: i % 5 == 0,
        rating: 3.5 + (i % 5),
        reviewCount: i * 2,
        harvestDate: DateTime.now().subtract(Duration(days: i * 3)),
        stock: 10 + i,
        createdAt: DateTime.now().subtract(Duration(days: i * 2)),
        updatedAt: DateTime.now(),
        isOutOfSeason: false,
        title: 'Product $i',
        certification: i % 2 == 0 ? 'Certified' : '',
        latitude: -25.0 + i,
        longitude: 30.0 + i,
        quantity: 1,
      ));
      _applyFilters();
    } catch (e) {
      _error = 'Error loading products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
  _selectedCategory = category;
  _applyFilters();
  notifyListeners();
  }

  void searchProducts(String query) {
  _searchQuery = query.toLowerCase();
  _applyFilters();
  notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(product.category);
      final matchesTags = _selectedTags.isEmpty || (_selectedTags.any((tag) => product.title.toLowerCase().contains(tag.toLowerCase())));
      final matchesFarms = _selectedFarms.isEmpty || _selectedFarms.contains(product.farmName);
      final matchesPickedToday = _pickedToday == null || (_pickedToday == true ? (product.harvestDate != null && product.harvestDate!.difference(DateTime.now()).inDays == 0) : true);
      final matchesOrganic = _organic == null || (_organic == true ? product.isOrganic : true);
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery) ||
          product.farmName.toLowerCase().contains(_searchQuery);
      final matchesPrice = (_minPrice == null || product.price >= _minPrice!) && (_maxPrice == null || product.price <= _maxPrice!);
      final matchesCertification = _certification == null || product.certification == _certification;
      final matchesAvailability = _onlyAvailable == null || (_onlyAvailable == true ? product.stock > 0 : true);
      final matchesSale = _onlyOnSale == null || (_onlyOnSale == true ? product.isOnSale : true);
      final matchesNewArrival = _onlyNewArrival == null || (_onlyNewArrival == true ? product.isNewArrival : true);
      final matchesRating = _minRating == null || product.rating >= _minRating!;
      final matchesDistance = (_maxDistanceKm == null || _userLatitude == null || _userLongitude == null) ? true : _distanceKm(_userLatitude!, _userLongitude!, product.latitude, product.longitude) <= _maxDistanceKm!;
      return matchesCategory && matchesTags && matchesFarms && matchesPickedToday && matchesOrganic && matchesSearch && matchesPrice && matchesCertification && matchesAvailability && matchesSale && matchesNewArrival && matchesRating && matchesDistance;
    }).toList();
  }

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth radius in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a =
        (sin(dLat / 2) * sin(dLat / 2)) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * (sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (3.141592653589793 / 180.0);

  // Filter setters
  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
    notifyListeners();
  }
  void setCertification(String? cert) {
    _certification = cert;
    _applyFilters();
    notifyListeners();
  }
  void setAvailability(bool? onlyAvailable) {
    _onlyAvailable = onlyAvailable;
    _applyFilters();
    notifyListeners();
  }
  void setSale(bool? onlyOnSale) {
    _onlyOnSale = onlyOnSale;
    _applyFilters();
    notifyListeners();
  }
  void setNewArrival(bool? onlyNewArrival) {
    _onlyNewArrival = onlyNewArrival;
    _applyFilters();
    notifyListeners();
  }
  void setMinRating(double? minRating) {
    _minRating = minRating;
    _applyFilters();
    notifyListeners();
  }
  void setLocation(double? userLat, double? userLon, double? maxDistanceKm) {
    _userLatitude = userLat;
    _userLongitude = userLon;
    _maxDistanceKm = maxDistanceKm;
    _applyFilters();
    notifyListeners();
  }

  void filterProducts({
    List<String>? categories,
    List<String>? tags,
    List<String>? farms,
    bool? pickedToday,
    bool? organic,
    String? category,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? certification,
    bool? onlyAvailable,
    bool? onlyOnSale,
    bool? onlyNewArrival,
    double? minRating,
    double? userLatitude,
    double? userLongitude,
    double? maxDistanceKm,
  }) {
    if (categories != null) _selectedCategories = categories;
    if (tags != null) _selectedTags = tags;
    if (farms != null) _selectedFarms = farms;
    if (pickedToday != null) _pickedToday = pickedToday;
    if (organic != null) _organic = organic;
    if (category != null) _selectedCategory = category;
    if (searchQuery != null) _searchQuery = searchQuery;
    if (minPrice != null) _minPrice = minPrice;
    if (maxPrice != null) _maxPrice = maxPrice;
    if (certification != null) _certification = certification;
    if (onlyAvailable != null) _onlyAvailable = onlyAvailable;
    if (onlyOnSale != null) _onlyOnSale = onlyOnSale;
    if (onlyNewArrival != null) _onlyNewArrival = onlyNewArrival;
    if (minRating != null) _minRating = minRating;
    if (userLatitude != null) _userLatitude = userLatitude;
    if (userLongitude != null) _userLongitude = userLongitude;
    if (maxDistanceKm != null) _maxDistanceKm = maxDistanceKm;
    _applyFilters();
    notifyListeners();
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

