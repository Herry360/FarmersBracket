

import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/favorites_provider.dart';
import 'package:farm_bracket/models/farm_model.dart';

class FakeSupabaseService {
  List<Map<String, dynamic>> mockData = [];
  Future<List<Map<String, dynamic>>> fetchFavorites(String userId) async {
    return mockData;
  }
}

class TestFavoritesNotifier extends FavoritesNotifier {
  final FakeSupabaseService fakeService;
  TestFavoritesNotifier(this.fakeService)
      : super();

  @override
  Future<void> loadFavorites(String userId) async {
    state = FavoritesState(favorites: state.favorites, isLoading: true);
    final data = await fakeService.fetchFavorites(userId);
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
}

void main() {
  late TestFavoritesNotifier favoritesNotifier;
  late FakeSupabaseService fakeService;
  const userId = 'user1';
  const productId = 'prod1';

  setUp(() {
    fakeService = FakeSupabaseService();
    favoritesNotifier = TestFavoritesNotifier(fakeService);
    favoritesNotifier.state = FavoritesState(favorites: [], isLoading: false);
  });

  group('FavoritesProvider', () {
    test('Initial state is empty and not loading', () {
      expect(favoritesNotifier.state.favorites, isEmpty);
      expect(favoritesNotifier.state.isLoading, false);
    });

    test('Load favorites updates state', () async {
      fakeService.mockData = [
        {
          'product_id': productId,
          'name': 'Apple',
          'description': 'Fresh apple',
          'price': 2.5,
          'imageUrl': 'img.png',
          'farmId': 'farm1',
          'farmName': 'Farm A',
          'category': 'Fruit',
          'unit': 'kg',
          'isOrganic': true,
          'isSeasonal': false,
          'rating': 4.5,
          'reviewCount': 10,
          'harvestDate': '2024-06-01',
          'stock': 100,
        }
      ];
      await favoritesNotifier.loadFavorites(userId);
      expect(favoritesNotifier.state.favorites.length, 1);
      expect(favoritesNotifier.state.favorites.first.name, 'Apple');
      expect(favoritesNotifier.state.isLoading, false);
    });

    test('isFavorite returns true if product is in favorites', () async {
      fakeService.mockData = [
        {'product_id': productId, 'name': 'Apple'}
      ];
      await favoritesNotifier.loadFavorites(userId);
      expect(favoritesNotifier.isFavorite(productId), true);
    });

    test('isFavorite returns false if product is not in favorites', () async {
      fakeService.mockData = [];
      await favoritesNotifier.loadFavorites(userId);
      expect(favoritesNotifier.isFavorite(productId), false);
    });
  });
}

