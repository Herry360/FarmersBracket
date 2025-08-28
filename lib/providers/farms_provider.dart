import 'package:flutter/foundation.dart';
import '../models/farm_model.dart';

class FarmsProvider with ChangeNotifier {
  List<Farm> _farms = [];
  bool _isLoading = false;
  String? _error;

  List<Farm> get farms => _farms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFarms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Populate with 10 placeholder farms for UI testing
    _farms = List.generate(10, (i) => Farm(
      id: 'farm_$i',
      name: 'Farm $i',
      description: 'Description for farm $i',
      imageUrl: '',
      rating: 4.0 + (i % 5) * 0.2,
      distance: 2.0 + i,
      latitude: -25.0 + i,
      longitude: 30.0 + i,
      story: 'Farm $i story goes here.',
      practiceLabels: ['Organic', 'Sustainable'],
      imageUrls: [],
      category: i % 2 == 0 ? 'fruits' : 'vegetables',
      products: [],
      price: 0.0,
      isFavorite: i % 2 == 0,
      location: '',
    ));
    _isLoading = false;
    notifyListeners();
  }
}
