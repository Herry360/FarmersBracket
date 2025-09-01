import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/home_screen_filter_provider.dart';
import 'package:farm_bracket/models/home_screen_filter.dart';

void main() {
  group('HomeScreenFilterProvider', () {
    late HomeScreenFilterProvider provider;

    setUp(() {
      provider = HomeScreenFilterProvider();
    });

    test('Initial filter model is default', () {
      expect(provider.filter, isA<HomeScreenFilterModel>());
      expect(provider.filter.selectedCategories, isEmpty);
      expect(provider.filter.selectedPriceRange, isNull);
      expect(provider.filter.selectedSortOption, isNull);
    });

    test('updateFilter replaces filter and notifies listeners', () {
      final newFilter = HomeScreenFilterModel(
        selectedCategories: ['Dairy'],
        selectedPriceRange: const RangeValues(5, 20),
        selectedSortOption: 'Newest',
      );
      bool notified = false;
      provider.addListener(() => notified = true);

      provider.updateFilter(newFilter);

      expect(provider.filter.selectedCategories, ['Dairy']);
      expect(provider.filter.selectedPriceRange?.start, 5);
      expect(provider.filter.selectedPriceRange?.end, 20);
      expect(provider.filter.selectedSortOption, 'Newest');
      expect(notified, isTrue);
    });

    test('resetFilter sets filter to default and notifies listeners', () {
      provider.updateFilter(HomeScreenFilterModel(
        selectedCategories: ['Bakery'],
        selectedPriceRange: const RangeValues(1, 10),
        selectedSortOption: 'Popular',
      ));
      bool notified = false;
      provider.addListener(() => notified = true);

      provider.resetFilter();

      expect(provider.filter.selectedCategories, isEmpty);
      expect(provider.filter.selectedPriceRange, isNull);
      expect(provider.filter.selectedSortOption, isNull);
      expect(notified, isTrue);
    });

    test('Multiple updates reflect in filter', () {
      provider.updateFilter(HomeScreenFilterModel(
        selectedCategories: ['Meat'],
        selectedPriceRange: const RangeValues(15, 30),
        selectedSortOption: 'Price: High to Low',
      ));
      expect(provider.filter.selectedCategories, ['Meat']);
      expect(provider.filter.selectedPriceRange?.start, 15);
      expect(provider.filter.selectedPriceRange?.end, 30);
      expect(provider.filter.selectedSortOption, 'Price: High to Low');

      provider.updateFilter(HomeScreenFilterModel(
        selectedCategories: ['Seafood'],
        selectedPriceRange: const RangeValues(20, 40),
        selectedSortOption: 'Rating',
      ));
      expect(provider.filter.selectedCategories, ['Seafood']);
      expect(provider.filter.selectedPriceRange?.start, 20);
      expect(provider.filter.selectedPriceRange?.end, 40);
      expect(provider.filter.selectedSortOption, 'Rating');
    });

    test('updateFilter with empty categories and nulls', () {
      final newFilter = HomeScreenFilterModel(
        selectedCategories: [],
        selectedPriceRange: null,
        selectedSortOption: null,
      );
      provider.updateFilter(newFilter);

      expect(provider.filter.selectedCategories, isEmpty);
      expect(provider.filter.selectedPriceRange, isNull);
      expect(provider.filter.selectedSortOption, isNull);
    });

    test('Listeners are called only on update', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);
      provider.updateFilter(HomeScreenFilterModel(
        selectedCategories: ['Fruit'],
        selectedPriceRange: const RangeValues(2, 8),
        selectedSortOption: 'Oldest',
      ));
      expect(notifyCount, 1);

      provider.resetFilter();
      expect(notifyCount, 2);
    });

    test('resetFilter after default does not change filter', () {
      bool notified = false;
      provider.addListener(() => notified = true);
      provider.resetFilter();
      expect(provider.filter.selectedCategories, isEmpty);
      expect(provider.filter.selectedPriceRange, isNull);
      expect(provider.filter.selectedSortOption, isNull);
      expect(notified, isTrue);
    });
  });
}