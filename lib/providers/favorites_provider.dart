// import removed: flutter/foundation.dart
// ...existing code...
// ...existing code...
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  // Inject dependencies here if needed
  return FavoritesNotifier();
});

class FavoritesState {
  final List<Product> favorites;
  final bool isLoading;
  final String? error;
  FavoritesState({required this.favorites, required this.isLoading, this.error});
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  // ...existing code...
  FavoritesNotifier() : super(FavoritesState(favorites: [], isLoading: false, error: null));

  Future<void> loadFavorites() async {
    state = FavoritesState(favorites: state.favorites, isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // UI only: mock favorites
      state = FavoritesState(favorites: [], isLoading: false, error: null);
    } catch (e) {
      state = FavoritesState(favorites: state.favorites, isLoading: false, error: 'Error loading favorites: $e');
    }
  }

  // UI only: add/remove favorite locally
  void addFavorite(Product product) {
  final updatedFavorites = List<Product>.from(state.favorites)..add(product);
  state = FavoritesState(favorites: updatedFavorites, isLoading: false, error: null);
  }

  void removeFavorite(String productId) {
  final updatedFavorites = state.favorites.where((p) => p.id != productId).toList();
  state = FavoritesState(favorites: updatedFavorites, isLoading: false, error: null);
  }

  void clearFavorites() {
  state = FavoritesState(favorites: [], isLoading: false, error: null);
  }

  bool isFavorite(String productId) {
    return state.favorites.any((product) => product.id == productId);
  }
}
  // UI only: local favorites implementation
  // ...existing code...
// End of FavoritesNotifier
