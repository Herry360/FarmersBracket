import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void addFavorite(String id) {
    if (_favoriteIds.add(id)) {
      notifyListeners();
    }
  }

  void removeFavorite(String id) {
    if (_favoriteIds.remove(id)) {
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    if (isFavorite(id)) {
      removeFavorite(id);
    } else {
      addFavorite(id);
    }
  }

  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }

  Future<void> loadFavorites() async {}
}