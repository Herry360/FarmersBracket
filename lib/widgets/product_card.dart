import '../models/farm_model.dart' show Product;
import 'package:flutter/material.dart';

// The old StatelessWidget ProductCard has been removed.

class ProductCard extends StatefulWidget {
      final Product product;
      final bool isFavorite;
      final bool isInCart;
      final VoidCallback onFavoritePressed;
      final VoidCallback onAddToCart;
      final VoidCallback? onProductTap;

      const ProductCard({
        super.key,
        required this.product,
        required this.isFavorite,
        required this.isInCart,
        required this.onFavoritePressed,
        required this.onAddToCart,
        this.onProductTap,
      });

      @override
      State<ProductCard> createState() => _ProductCardState();
    }

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
      late AnimationController _controller;
      late Animation<double> _scaleAnimation;

      @override
      void initState() {
        super.initState();
        _controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 350),
        );
        _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.elasticOut))
            .animate(_controller);
      }

      @override
      void dispose() {
        _controller.dispose();
        super.dispose();
      }

      void _handleFavoritePressed() {
        _controller.forward(from: 0);
        widget.onFavoritePressed();
      }

      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onProductTap,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image
                    _buildProductImage(context),
                    // Product Details
                    _buildProductDetails(context),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: IconButton(
                      icon: Icon(
                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: widget.isFavorite ? Colors.redAccent : Colors.grey,
                      ),
                      onPressed: _handleFavoritePressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildProductImage(BuildContext context) {
        return AspectRatio(
          aspectRatio: 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
              if (widget.isInCart)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Center(
                    child: Chip(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      label: const Text('In Cart'),
                    ),
                  ),
                ),
                // Stock status badge
                if (widget.product.stock <= 5)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Chip(
                      backgroundColor: Color.fromRGBO(
                        ((Theme.of(context).colorScheme.error.r * 255.0).round() & 0xff),
                        ((Theme.of(context).colorScheme.error.g * 255.0).round() & 0xff),
                        ((Theme.of(context).colorScheme.error.b * 255.0).round() & 0xff),
                        0.8,
                      ),
                      label: const Text('Low Stock', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                if (widget.product.isOutOfSeason == true)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Chip(
                      backgroundColor: Color.fromRGBO(
                        ((Theme.of(context).colorScheme.secondary.r * 255.0).round() & 0xff),
                        ((Theme.of(context).colorScheme.secondary.g * 255.0).round() & 0xff),
                        ((Theme.of(context).colorScheme.secondary.b * 255.0).round() & 0xff),
                        0.8,
                      ),
                      label: const Text('Out of Season', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
            ],
          ),
        );
      }

      Widget _buildProductDetails(BuildContext context) {
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Title
              Text(
                widget.product.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Product Price
              _buildPriceInfo(context),
              const SizedBox(height: 8),

              // Add to Cart Button
              _buildAddToCartButton(context),
            ],
          ),
        );
      }

      Widget _buildPriceInfo(BuildContext context) {
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
                'R${widget.product.price.toStringAsFixed(2)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
          ],
        );
      }

            Widget _buildAddToCartButton(BuildContext context) {
              return SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.isInCart ? null : widget.onAddToCart,
                  icon: widget.isInCart 
                      ? const Icon(Icons.check)
                      : const Icon(Icons.shopping_cart, size: 18),
                  label: Text(widget.isInCart ? 'Added to Cart' : 'Add to Cart'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              );
            }
      }
