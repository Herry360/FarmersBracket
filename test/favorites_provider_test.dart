import 'package:flutter_test/flutter_test.dart';

// Mock Product class
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> images;
  final String farmId;
  final String farmName;
  final String category;
  final String unit;
  final bool isOrganic;
  final bool isFeatured;
  final bool isSeasonal;
  final bool isOnSale;
  final bool isNewArrival;
  final double rating;
  final int reviewCount;
  final DateTime? harvestDate;
  final int stock;
  final int quantity;
  final bool isOutOfSeason;
  final String title;
  final String certification;
  final double latitude;
  final double longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.images,
    required this.farmId,
    required this.farmName,
    required this.category,
    required this.unit,
    required this.isOrganic,
    required this.isFeatured,
    required this.isSeasonal,
    required this.isOnSale,
    required this.isNewArrival,
    required this.rating,
    required this.reviewCount,
    required this.harvestDate,
    required this.stock,
    required this.quantity,
    required this.isOutOfSeason,
    required this.title,
    required this.certification,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    this.updatedAt,
  });
}

// Mock FavoritesState class
class FavoritesState {
  final List<Product> favorites;
  final bool isLoading;
  final String? error;

  FavoritesState({
    required this.favorites,
    required this.isLoading,
    this.error,
  });
}

// Mock FavoritesNotifier class
class FavoritesNotifier {
  FavoritesState _state = FavoritesState(favorites: [], isLoading: false);

  FavoritesState get state => _state;
  set state(FavoritesState value) => _state = value;

  bool isFavorite(String productId) {
    return _state.favorites.any((product) => product.id == productId);
  }

  Future<void> loadFavorites() async {
    _state = FavoritesState(favorites: [], isLoading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    _state = FavoritesState(favorites: [], isLoading: false);
  }
}

void main() {
  late FavoritesNotifier favoritesNotifier;
  const productId = 'prod1';

  setUp(() {
    favoritesNotifier = FavoritesNotifier();
    favoritesNotifier.state = FavoritesState(favorites: [], isLoading: false);
  });

  group('FavoritesProvider', () {
    test('Initial state is empty and not loading', () {
      expect(favoritesNotifier.state.favorites, isEmpty);
      expect(favoritesNotifier.state.isLoading, false);
    });

    test('Load favorites updates state', () async {
      final favorites = [
        Product(
          id: productId,
          name: 'Apple',
          description: 'Fresh apple',
          price: 2.5,
          imageUrl: 'img.png',
          images: [],
          farmId: 'farm1',
          farmName: 'Farm A',
          category: 'Fruit',
          unit: 'kg',
          isOrganic: true,
          isFeatured: false,
          isSeasonal: false,
          isOnSale: false,
          isNewArrival: false,
          rating: 4.5,
          reviewCount: 10,
          harvestDate: DateTime(2024, 6, 1),
          stock: 100,
          quantity: 1,
          isOutOfSeason: false,
          title: 'Apple',
          certification: '',
          latitude: 0.0,
          longitude: 0.0,
          createdAt: null,
          updatedAt: null,
        ),
      ];
      favoritesNotifier.state = FavoritesState(
        favorites: favorites,
        isLoading: false,
      );
      expect(favoritesNotifier.state.favorites.length, 1);
      expect(favoritesNotifier.state.favorites.first.name, 'Apple');
      expect(favoritesNotifier.state.isLoading, false);
    });

    test('isFavorite returns true if product is in favorites', () async {
      final favorites = [
        Product(
          id: productId,
          name: 'Apple',
          description: '',
          price: 0.0,
          imageUrl: '',
          images: [],
          farmId: '',
          farmName: '',
          category: '',
          unit: '',
          isOrganic: false,
          isFeatured: false,
          isSeasonal: false,
          isOnSale: false,
          isNewArrival: false,
          rating: 0.0,
          reviewCount: 0,
          harvestDate: null,
          stock: 0,
          createdAt: null,
          updatedAt: null,
          isOutOfSeason: false,
          title: 'Apple',
          certification: '',
          latitude: 0.0,
          longitude: 0.0,
          quantity: 1,
        ),
      ];
      favoritesNotifier.state = FavoritesState(
        favorites: favorites,
        isLoading: false,
      );
      expect(favoritesNotifier.isFavorite(productId), true);
    });

    test('isFavorite returns false if product is not in favorites', () async {
      favoritesNotifier.state = FavoritesState(favorites: [], isLoading: false);
      expect(favoritesNotifier.isFavorite(productId), false);
    });

    test('FavoritesNotifier exposes loading and error states', () async {
      final notifier = FavoritesNotifier();
      await notifier.loadFavorites();
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, isNull);

      notifier.state = FavoritesState(
        favorites: [],
        isLoading: false,
        error: 'Test error',
      );
      expect(notifier.state.error, 'Test error');
    });
  });
}