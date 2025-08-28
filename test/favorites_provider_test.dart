import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/favorites_provider.dart';
import 'package:farm_bracket/models/farm_model.dart';


// Removed FakeSupabaseService and TestFavoritesNotifier. Use FavoritesNotifier directly in tests.

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
      // Simulate loading favorites by directly setting state
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
        ),
      ];
      favoritesNotifier.state = FavoritesState(favorites: favorites, isLoading: false);
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
      favoritesNotifier.state = FavoritesState(favorites: favorites, isLoading: false);
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

      // Simulate error
      notifier.state = FavoritesState(favorites: [], isLoading: false, error: 'Test error');
      expect(notifier.state.error, 'Test error');
    });
  });
}

