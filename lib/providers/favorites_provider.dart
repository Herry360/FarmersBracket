import 'package:farm_bracket/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<String, Product> _favorites = {};

  Map<String, Product> get favorites => {..._favorites};
  List<Product> get favoritesList => _favorites.values.toList();

  bool isFavorite(String id) => _favorites.containsKey(id);

  void addFavorite(Product product) {
    _favorites[product.id] = product;
    notifyListeners();
  }

  void removeFavorite(String id) {
    _favorites.remove(id);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      removeFavorite(product.id);
    } else {
      addFavorite(product);
    }
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}

final favoritesProvider = ChangeNotifierProvider<FavoritesProvider>((ref) => FavoritesProvider());