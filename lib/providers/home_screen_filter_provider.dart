import 'package:flutter/foundation.dart';
import '../models/home_screen_filter.dart';

class HomeScreenFilterProvider extends ChangeNotifier {
  HomeScreenFilterModel _filter = HomeScreenFilterModel(selectedCategories: [], selectedPriceRange: null, selectedSortOption: '');

  String _searchQuery = '';
  List<String> _selectedCategories = [];
  bool _showOnlyFavorites = false;

  HomeScreenFilterModel get filter => _filter;
  String get searchQuery => _searchQuery;
  List<String> get selectedCategories => List.unmodifiable(_selectedCategories);
  bool get showOnlyFavorites => _showOnlyFavorites;

  void updateFilter(HomeScreenFilterModel newFilter) {
    _filter = newFilter;
    _searchQuery = newFilter.searchQuery ?? '';
    _selectedCategories = List.from(newFilter.selectedCategories);
    _showOnlyFavorites = newFilter.showOnlyFavorites ?? false;
    notifyListeners();
  }

  void resetFilter() {
    _filter = HomeScreenFilterModel(selectedCategories: [], selectedPriceRange: null, selectedSortOption: '');
    _searchQuery = '';
    _selectedCategories.clear();
    _showOnlyFavorites = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _filter = _filter.copyWith(
        searchQuery: query,
        selectedCategories: _selectedCategories,
        showOnlyFavorites: _showOnlyFavorites,
      );
      notifyListeners();
    }
  }

  void setSelectedCategories(List<String> categories) {
    _selectedCategories = List.from(categories);
    _filter = _filter.copyWith(
      selectedCategories: _selectedCategories,
      searchQuery: _searchQuery,
      showOnlyFavorites: _showOnlyFavorites,
    );
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _filter = _filter.copyWith(
      selectedCategories: _selectedCategories,
      searchQuery: _searchQuery,
      showOnlyFavorites: _showOnlyFavorites,
    );
    notifyListeners();
  }

  void setShowOnlyFavorites(bool value) {
    if (_showOnlyFavorites != value) {
      _showOnlyFavorites = value;
      _filter = _filter.copyWith(
        showOnlyFavorites: value,
        searchQuery: _searchQuery,
        selectedCategories: _selectedCategories,
      );
      notifyListeners();
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategories.clear();
    _showOnlyFavorites = false;
    _filter = HomeScreenFilterModel(selectedCategories: [], selectedPriceRange: null, selectedSortOption: '');
    notifyListeners();
  }
}