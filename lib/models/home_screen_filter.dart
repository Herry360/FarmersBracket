import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/hive_service.dart';

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
  HomeScreenFilterNotifier() : super(HomeScreenFilter()) {
    _restoreFilterState();
  }

  Future<void> _restoreFilterState() async {
    final hiveService = HiveService();
    final saved = await hiveService.getHomeScreenFilter();
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> _persistFilterState() async {
    final hiveService = HiveService();
    await hiveService.saveHomeScreenFilter(state);
  }

  void toggleFavorites() {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void toggleOpenNow() {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void toggleOrganic() {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void toggleTopRated() {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void setCategory(String category) {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void setSearchQuery(String query) {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void setDistanceRange(double min, double max) {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }

  void setPrice(double price) {
    state = HomeScreenFilter(
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
    _persistFilterState();
  }
}

final homeScreenFilterProvider =
    StateNotifierProvider<HomeScreenFilterNotifier, HomeScreenFilter>(
      (ref) => HomeScreenFilterNotifier(),
    );
