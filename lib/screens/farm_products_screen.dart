import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';
import 'farm_app_bar.dart';
import 'farm_products_body.dart';
import 'farm_header.dart';

final farmProvider = Provider<Farm>((ref) {
  throw UnimplementedError('farmProvider must be overridden in ProviderScope');
});

class FarmProductsScreen extends ConsumerWidget {
  final Farm farm;

  const FarmProductsScreen({super.key, required this.farm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        farmProvider.overrideWithValue(farm),
      ],
      child: Scaffold(
        appBar: FarmAppBar(farm: farm),
        body: RefreshIndicator(
          onRefresh: () async {
            // Example refresh logic: fetch products again
            // You may want to call a provider or service here
            // await ref.read(productsProvider.notifier).fetchProducts();
            await Future.delayed(const Duration(seconds: 1));
          },
          displacement: 40,
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Column(
            children: [
              FarmHeader(farm: farm),
              Expanded(
                child: FarmProductsBody(farm: farm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}