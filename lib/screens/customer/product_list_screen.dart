import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/empty_search_results_widget.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../constants/app_strings.dart';
import '../../../../models/product_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.allProducts, showBackButton: true),
      body: Builder(
        builder: (context) {
          if (productProvider.isLoading) {
            return const LoadingShimmer(type: ShimmerType.productList);
          }

          if (productProvider.products.isEmpty) {
            return Center(
              child: EmptySearchResultsWidget(
                title: AppStrings.emptySearchTitle,
                message: AppStrings.emptySearchMessage,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}

// Dummy ProductCard widget for demonstration.
// Replace with your actual ProductCard implementation.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(child: Image.network(product.imageUrl, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('\$${product.price.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}
