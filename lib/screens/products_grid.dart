import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart' as farm_model;
import '../providers/products_provider.dart' as products_provider;
import 'products_list.dart';

final farmProvider = Provider<farm_model.Farm>((ref) {
  throw UnimplementedError('farmProvider must be overridden in ProviderScope');
});

class ProductsGrid extends ConsumerWidget {
  final String searchQuery;
  const ProductsGrid({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farm = ref.watch(farmProvider);
    final productsProviderInstance = ref.watch(products_provider.productsProvider);
    final products = productsProviderInstance.products;
    final isLoading = productsProviderInstance.isLoading;

    if (isLoading) {
      return const LoadingIndicator();
    }
    List<farm_model.Product> farmProducts = products.where((product) => product.farmId == farm.id).toList();
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      farmProducts = farmProducts.where((product) {
        final name = product.title.toLowerCase();
        final category = product.category.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    }
    if (farmProducts.isEmpty) {
      return const EmptyProductsState();
    }
    return ProductsList(products: farmProducts);
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class EmptyProductsState extends StatelessWidget {
  const EmptyProductsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No products available', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text('Check back later', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
