import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ...existing code...
import '../widgets/cart_summary.dart';
import '../services/notification_service.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../models/farm_model.dart';
import 'main_navigation.dart';

// Providers
// ...existing code...

@RoutePage()
class CartScreen extends ConsumerWidget {
  final NotificationService _notificationService = NotificationService();
  CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.items;
    final totalPrice = cartState.subtotal;
    const double shippingFee = 5.00;
  // Removed unused isLoading variable

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear cart',
              onPressed: () => _showClearCartDialog(context, ref),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cart refreshed!')),
          );
        },
        child: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const MainNavigation()),
                                (route) => false,
                              );
                            },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_bag_outlined),
                              SizedBox(width: 8),
                              Text('Continue Shopping'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: _buildCartItemsList(context, ref, cartItems),
                  ),
                  CartSummary(subtotal: totalPrice, shippingFee: shippingFee),
                  _buildCheckoutButton(context, ref, totalPrice + shippingFee),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const MainNavigation()),
                            (route) => false,
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_bag_outlined),
                            SizedBox(width: 8),
                            Text('Continue Shopping'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCartItemsList(BuildContext context, WidgetRef ref, List<CartItem> cartItems) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: cartItems.length,
  separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (ctx, index) {
        final item = cartItems[index];
        final product = Product(
          id: item.productId,
          name: item.name,
          description: '',
          price: item.price,
          imageUrl: item.imageUrl,
          images: [],
          farmId: item.farmId,
          farmName: item.farmName,
          category: '',
          unit: item.unit,
          isOrganic: false,
          isFeatured: false,
          isSeasonal: false,
          isOnSale: false,
          isNewArrival: false,
          rating: 0.0,
          reviewCount: 0,
          harvestDate: null,
          stock: item.quantity,
          createdAt: null,
          updatedAt: null,
          isOutOfSeason: false,
          title: item.name,
          certification: '',
          latitude: 0.0,
          longitude: 0.0, quantity: item.quantity,
        );
        return Semantics(
          label: 'Cart item for ${item.name}',
          child: Dismissible(
            key: Key('${item.id}_${item.quantity}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove Item'),
                  content: Text('Remove ${item.name} from your cart?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Remove', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              ref.read(cartProvider.notifier).removeFromCart(item.id);
              _showUndoSnackbar(context, ref, item);
            },
            child: ProductCard(
              product: product,
              isFavorite: false,
              isInCart: true,
              onFavoritePressed: () {},
              onAddToCart: () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1),
              onProductTap: null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutButton(BuildContext context, WidgetRef ref, double total) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _processCheckout(context, ref, total),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Proceed to Checkout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _processCheckout(BuildContext context, WidgetRef ref, double total) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
  title: const Text('Confirm Order'),
        content: Text('Total amount: R${total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(cartProvider.notifier).clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!'))
              );
              _notificationService.sendNotification('Order Confirmed', 'Your order has been placed!');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
  title: const Text('Clear Cart'),
  content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showUndoSnackbar(BuildContext context, WidgetRef ref, CartItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            ref.read(cartProvider.notifier).addToCart(item);
          },
        ),
      ),
    );
  }
}