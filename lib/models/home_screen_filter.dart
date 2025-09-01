import 'package:flutter/material.dart';

class HomeScreenFilterModel {
  final String? category;
  final double? maxPrice;
  final double? minRating;
  final String? sortBy;
  final bool? showFavoritesOnly;
  final bool? openNow;
  final bool? organic;
  final bool? topRated;
  final String? searchQuery;
  final double? minDistance;
  final double? maxDistance;
  final String? price;

  final List<String> selectedCategories;
  final RangeValues? selectedPriceRange;
  final String? selectedSortOption;

  HomeScreenFilterModel({
    this.category,
    this.maxPrice,
    this.minRating,
    this.sortBy,
    this.showFavoritesOnly,
    this.openNow,
    this.organic,
    this.topRated,
    this.searchQuery,
    this.minDistance,
    this.maxDistance,
    this.price,
    required this.selectedCategories,
    required this.selectedPriceRange,
    required this.selectedSortOption,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'maxPrice': maxPrice,
      'minRating': minRating,
      'sortBy': sortBy,
      'showFavoritesOnly': showFavoritesOnly,
      'openNow': openNow,
      'organic': organic,
      'topRated': topRated,
      'searchQuery': searchQuery,
      'minDistance': minDistance,
      'maxDistance': maxDistance,
      'price': price,
      'selectedCategories': selectedCategories,
      'selectedPriceRange': selectedPriceRange == null
          ? null
          : {'start': selectedPriceRange!.start, 'end': selectedPriceRange!.end},
      'selectedSortOption': selectedSortOption,
    };
  }

  factory HomeScreenFilterModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenFilterModel(
      category: json['category'],
      maxPrice: json['maxPrice']?.toDouble(),
      minRating: json['minRating']?.toDouble(),
      sortBy: json['sortBy'],
      showFavoritesOnly: json['showFavoritesOnly'],
      openNow: json['openNow'],
      organic: json['organic'],
      topRated: json['topRated'],
      searchQuery: json['searchQuery'],
      minDistance: json['minDistance']?.toDouble(),
      maxDistance: json['maxDistance']?.toDouble(),
      price: json['price'],
      selectedCategories: (json['selectedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      selectedPriceRange: json['selectedPriceRange'] != null
          ? RangeValues(
              (json['selectedPriceRange']['start'] as num).toDouble(),
              (json['selectedPriceRange']['end'] as num).toDouble(),
            )
          : null,
      selectedSortOption: json['selectedSortOption'],
    );
  }

  Null get showOnlyFavorites => null;

  HomeScreenFilterModel copyWith({
    String? category,
    double? maxPrice,
    double? minRating,
    String? sortBy,
    bool? showFavoritesOnly,
    bool? openNow,
    bool? organic,
    bool? topRated,
    String? searchQuery,
    double? minDistance,
    double? maxDistance,
    String? price,
    List<String>? selectedCategories,
    RangeValues? selectedPriceRange,
    String? selectedSortOption, required bool showOnlyFavorites,
  }) {
    return HomeScreenFilterModel(
      category: category ?? this.category,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      openNow: openNow ?? this.openNow,
      organic: organic ?? this.organic,
      topRated: topRated ?? this.topRated,
      searchQuery: searchQuery ?? this.searchQuery,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      price: price ?? this.price,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedPriceRange: selectedPriceRange ?? this.selectedPriceRange,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
    );
  }
}