// import removed: flutter/foundation.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) => FavoritesNotifier());

class FavoritesState {
  final List<Product> favorites;
  final bool isLoading;
  FavoritesState({required this.favorites, required this.isLoading});
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final SupabaseService _supabaseService = SupabaseService();
  FavoritesNotifier() : super(FavoritesState(favorites: [], isLoading: false));

  Future<void> loadFavorites(String userId) async {
    state = FavoritesState(favorites: state.favorites, isLoading: true);
    final data = await _supabaseService.fetchFavorites(userId);
    final favorites = data.map((item) => Product(
      id: item['product_id'],
      name: item['name'] ?? '',
      description: item['description'] ?? '',
      price: (item['price'] ?? 0.0).toDouble(),
      imageUrl: item['imageUrl'] ?? '',
      farmId: item['farmId'] ?? '',
      farmName: item['farmName'] ?? '',
      category: item['category'] ?? '',
      unit: item['unit'] ?? '',
      isOrganic: item['isOrganic'] ?? false,
      isSeasonal: item['isSeasonal'] ?? false,
      rating: (item['rating'] ?? 0.0).toDouble(),
      reviewCount: item['reviewCount'] ?? 0,
      harvestDate: item['harvestDate'] != null ? DateTime.tryParse(item['harvestDate']) : null,
      stock: (item['stock'] ?? 0.0).toDouble(),
      quantity: 1,
      isOutOfSeason: false,
      title: item['name'] ?? '',
    )).toList();
    state = FavoritesState(favorites: favorites, isLoading: false);
  }

  Future<void> addFavorite(String userId, String productId) async {
    await Supabase.instance.client.from('favorites').insert({
      'user_id': userId,
      'product_id': productId,
    });
    await loadFavorites(userId);
  }

  Future<void> removeFavorite(String userId, String productId) async {
    await Supabase.instance.client.from('favorites')
      .delete()
      .eq('user_id', userId)
      .eq('product_id', productId);
    await loadFavorites(userId);
  }

  Future<void> clearFavorites(String userId) async {
    await Supabase.instance.client.from('favorites')
      .delete()
      .eq('user_id', userId);
    await loadFavorites(userId);
  }

  bool isFavorite(String productId) {
    return state.favorites.any((product) => product.id == productId);
  }
}
  final SupabaseService _supabaseService = SupabaseService();
  List<Product> _favorites = [];
  bool _isLoading = false;

  List<Product> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  int get count => _favorites.length;

  Future<void> loadFavorites(String userId) async {
    _isLoading = true;
    final data = await _supabaseService.fetchFavorites(userId);
    _favorites = data.map((item) => Product(
      id: item['product_id'],
      name: item['name'] ?? '',
      description: item['description'] ?? '',
      price: (item['price'] ?? 0.0).toDouble(),
      imageUrl: item['imageUrl'] ?? '',
      farmId: item['farmId'] ?? '',
      farmName: item['farmName'] ?? '',
      category: item['category'] ?? '',
      unit: item['unit'] ?? '',
      isOrganic: item['isOrganic'] ?? false,
      isSeasonal: item['isSeasonal'] ?? false,
      rating: (item['rating'] ?? 0.0).toDouble(),
      reviewCount: item['reviewCount'] ?? 0,
      harvestDate: item['harvestDate'] != null ? DateTime.tryParse(item['harvestDate']) : null,
      stock: (item['stock'] ?? 0.0).toDouble(),
      quantity: 1,
      isOutOfSeason: false,
      title: item['name'] ?? '',
    )).toList();
    _isLoading = false;
  }

  Future<void> addFavorite(String userId, String productId) async {
    await Supabase.instance.client.from('favorites').insert({
      'user_id': userId,
      'product_id': productId,
    });
    await loadFavorites(userId);
  }

  Future<void> removeFavorite(String userId, String productId) async {
    await Supabase.instance.client.from('favorites')
      .delete()
      .eq('user_id', userId)
      .eq('product_id', productId);
    await loadFavorites(userId);
  }

  Future<void> clearFavorites(String userId) async {
    await Supabase.instance.client.from('favorites')
      .delete()
      .eq('user_id', userId);
    await loadFavorites(userId);
  }

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }
// End of FavoritesNotifier
