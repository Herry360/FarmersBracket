import 'package:flutter/material.dart';

class Farm {
  final String id;
  final String name;
  final String location;

  Farm({
    required this.id,
    required this.name,
    required this.location,
  });
}

class FarmProvider with ChangeNotifier {
  final List<Farm> _farms = [];

  List<Farm> get farms => List.unmodifiable(_farms);

  Null get searchResults => null;

  final bool _organicFilter = false;
  final bool _localFilter = false;
  final bool _openNowFilter = false;

  bool get organicFilter => _organicFilter;

  bool get localFilter => _localFilter;

  bool get openNowFilter => _openNowFilter;

  void addFarm(Farm farm) {
    _farms.add(farm);
    notifyListeners();
  }

  void removeFarm(String id) {
    _farms.removeWhere((farm) => farm.id == id);
    notifyListeners();
  }

  void updateFarm(Farm updatedFarm) {
    final index = _farms.indexWhere((farm) => farm.id == updatedFarm.id);
    if (index != -1) {
      _farms[index] = updatedFarm;
      notifyListeners();
    }
  }

  Farm? getFarmById(String id) {
    try {
      return _farms.firstWhere((farm) => farm.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> loadFarms() async {}

  void searchFarms(String query) {}

  void clearSearch() {}

  void clearFilters() {}

  void setOrganicFilter(bool newValue) {}

  void setLocalFilter(bool newValue) {}

  void setOpenNowFilter(bool newValue) {}
}