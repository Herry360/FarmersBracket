import 'package:flutter/material.dart';

import '../models/farm_model.dart';
import '../widgets/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';

class FarmProductsBody extends StatefulWidget {
  final Farm farm;
  const FarmProductsBody({Key? key, required this.farm}) : super(key: key);

  @override
  State<FarmProductsBody> createState() => _FarmProductsBodyState();
}

class _FarmProductsBodyState extends State<FarmProductsBody> {
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  bool? _onlyAvailable;
  bool? _onlyOnSale;
  bool? _onlyNewArrival;
  String? _certification;
  double? _userLatitude;
  double? _userLongitude;
  double? _maxDistanceKm;
  final List<Map<String, dynamic>> _favoriteFilters = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final provider = ref.watch(productsProvider);
        final products = provider.products;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildFilterBar(ref),
                Expanded(
                  child: products.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              isFavorite: false,
                              isInCart: false,
                              onFavoritePressed: () {},
                              onAddToCart: () {},
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterBar(WidgetRef ref) {
    final provider = ref.read(productsProvider.notifier);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search'),
              onChanged: (val) {
                setState(() => _searchQuery = val);
                provider.searchProducts(val);
              },
            ),
          ),
          _filterButton('Price', () async {
            // Show price range dialog
            final range = await showDialog<Map<String, double>>(
              context: context,
              builder: (ctx) => _priceRangeDialog(),
            );
            if (range != null) {
              setState(() {
                _minPrice = range['min'];
                _maxPrice = range['max'];
              });
              provider.setPriceRange(_minPrice, _maxPrice);
            }
          }),
          _filterButton('Sale', () {
            setState(() => _onlyOnSale = !(_onlyOnSale ?? false));
            provider.setSale(_onlyOnSale);
          }),
          _filterButton('New Arrival', () {
            setState(() => _onlyNewArrival = !(_onlyNewArrival ?? false));
            provider.setNewArrival(_onlyNewArrival);
          }),
          _filterButton('Available', () {
            setState(() => _onlyAvailable = !(_onlyAvailable ?? false));
            provider.setAvailability(_onlyAvailable);
          }),
          _filterButton('Rating', () async {
            final minRating = await showDialog<double>(
              context: context,
              builder: (ctx) => _minRatingDialog(),
            );
            if (minRating != null) {
              setState(() => _minRating = minRating);
              provider.setMinRating(_minRating);
            }
          }),
          _filterButton('Certification', () async {
            final cert = await showDialog<String>(
              context: context,
              builder: (ctx) => _certificationDialog(),
            );
            if (cert != null) {
              setState(() => _certification = cert);
              provider.setCertification(_certification);
            }
          }),
          _filterButton('Location', () async {
            final loc = await showDialog<Map<String, double>>(
              context: context,
              builder: (ctx) => _locationDialog(),
            );
            if (loc != null) {
              setState(() {
                _userLatitude = loc['lat'];
                _userLongitude = loc['lon'];
                _maxDistanceKm = loc['maxDist'];
              });
              provider.setLocation(_userLatitude, _userLongitude, _maxDistanceKm);
            }
          }),
          _filterButton('Save Filters', () {
            _favoriteFilters.add({
              'search': _searchQuery,
              'minPrice': _minPrice,
              'maxPrice': _maxPrice,
              'onlyOnSale': _onlyOnSale,
              'onlyNewArrival': _onlyNewArrival,
              'onlyAvailable': _onlyAvailable,
              'minRating': _minRating,
              'certification': _certification,
              'userLatitude': _userLatitude,
              'userLongitude': _userLongitude,
              'maxDistanceKm': _maxDistanceKm,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filter set saved!')),
            );
          }),
          _filterButton('Load Filters', () async {
            if (_favoriteFilters.isEmpty) return;
            final idx = await showDialog<int>(
              context: context,
              builder: (ctx) => _favoriteFiltersDialog(),
            );
            if (idx != null && idx < _favoriteFilters.length) {
              final f = _favoriteFilters[idx];
              setState(() {
                _searchQuery = f['search'] ?? '';
                _minPrice = f['minPrice'];
                _maxPrice = f['maxPrice'];
                _onlyOnSale = f['onlyOnSale'];
                _onlyNewArrival = f['onlyNewArrival'];
                _onlyAvailable = f['onlyAvailable'];
                _minRating = f['minRating'];
                _certification = f['certification'];
                _userLatitude = f['userLatitude'];
                _userLongitude = f['userLongitude'];
                _maxDistanceKm = f['maxDistanceKm'];
              });
              provider.searchProducts(_searchQuery);
              provider.setPriceRange(_minPrice, _maxPrice);
              provider.setSale(_onlyOnSale);
              provider.setNewArrival(_onlyNewArrival);
              provider.setAvailability(_onlyAvailable);
              provider.setMinRating(_minRating);
              provider.setCertification(_certification);
              provider.setLocation(_userLatitude, _userLongitude, _maxDistanceKm);
            }
          }),
        ],
      ),
    );
  }

  Widget _filterButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Widget _priceRangeDialog() {
    double min = _minPrice ?? 0;
    double max = _maxPrice ?? 100;
    return AlertDialog(
      title: const Text('Price Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Min Price'),
            keyboardType: TextInputType.number,
            onChanged: (val) => min = double.tryParse(val) ?? min,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Max Price'),
            keyboardType: TextInputType.number,
            onChanged: (val) => max = double.tryParse(val) ?? max,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, {'min': min, 'max': max}),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _minRatingDialog() {
    double minRating = _minRating ?? 0;
    return AlertDialog(
      title: const Text('Minimum Rating'),
      content: TextField(
        decoration: const InputDecoration(labelText: 'Min Rating'),
        keyboardType: TextInputType.number,
        onChanged: (val) => minRating = double.tryParse(val) ?? minRating,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, minRating),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _certificationDialog() {
    String cert = _certification ?? '';
    return AlertDialog(
      title: const Text('Certification'),
      content: TextField(
        decoration: const InputDecoration(labelText: 'Certification'),
        onChanged: (val) => cert = val,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, cert),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _locationDialog() {
    double lat = _userLatitude ?? 0;
    double lon = _userLongitude ?? 0;
    double maxDist = _maxDistanceKm ?? 50;
    return AlertDialog(
      title: const Text('Location Filter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Latitude'),
            keyboardType: TextInputType.number,
            onChanged: (val) => lat = double.tryParse(val) ?? lat,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Longitude'),
            keyboardType: TextInputType.number,
            onChanged: (val) => lon = double.tryParse(val) ?? lon,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Max Distance (km)'),
            keyboardType: TextInputType.number,
            onChanged: (val) => maxDist = double.tryParse(val) ?? maxDist,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, {'lat': lat, 'lon': lon, 'maxDist': maxDist}),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _favoriteFiltersDialog() {
    return AlertDialog(
      title: const Text('Saved Filters'),
      content: SizedBox(
        width: 200,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _favoriteFilters.length,
          itemBuilder: (ctx, idx) {
            final f = _favoriteFilters[idx];
            return ListTile(
              title: Text('Filter ${idx + 1}'),
              subtitle: Text(f.toString()),
              onTap: () => Navigator.pop(context, idx),
            );
          },
        ),
      ),
    );
  }
}

