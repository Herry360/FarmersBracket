import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/cart_summary.dart';
import '../providers/cart_provider.dart';

// Providers
final firebaseAuthProvider = Provider<fb_auth.FirebaseAuth>((ref) => fb_auth.FirebaseAuth.instance);
final firebaseUserProvider = StreamProvider<fb_auth.User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

@RoutePage()
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.items;
    final totalPrice = cartState.subtotal;
    const double shippingFee = 5.00;
    final userId = ref.watch(firebaseUserProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear cart',
              onPressed: () => _showClearCartDialog(context, ref, userId),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          try {
            if (cartItems.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: _buildCartItemsList(context, ref, cartItems, userId),
                  ),
                  CartSummary(subtotal: totalPrice, shippingFee: shippingFee),
                  _buildCheckoutButton(context, ref, totalPrice + shippingFee, userId),
                ],
              );
            }
          } catch (e) {
            String errorMsg;
            if (e is fb_auth.FirebaseAuthException) {
              errorMsg = e.message ?? 'Firebase error';
            } else if (e is Exception) {
              errorMsg = e.toString();
            } else {
              errorMsg = 'Unknown error';
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong loading your cart.',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMsg,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(cartProvider),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCartItemsList(BuildContext context, WidgetRef ref, List<CartItem> cartItems, String? userId) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: cartItems.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (ctx, index) {
        final item = cartItems[index];
        return Dismissible(
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
            if (userId != null) {
              ref.read(cartProvider.notifier).removeFromCart(userId, item.id);
            }
            _showUndoSnackbar(context, ref, item, userId);
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            title: Text(item.name, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('R${item.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        splashRadius: 20,
                        onPressed: () {
                          if (userId != null) {
                            if (item.quantity > 1) {
                              ref.read(cartProvider.notifier).updateQuantity(
                                userId, 
                                item.id, 
                                item.quantity - 1
                              );
                            } else {
                              ref.read(cartProvider.notifier).removeFromCart(userId, item.id);
                            }
                          }
                        },
                      ),
                      Text('${item.quantity}', style: Theme.of(context).textTheme.bodyMedium),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        splashRadius: 20,
                        onPressed: () {
                          if (userId != null) {
                            ref.read(cartProvider.notifier).updateQuantity(
                              userId, 
                              item.id, 
                              item.quantity + 1
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Text(
              'R${(item.price * item.quantity).toStringAsFixed(2)}', 
              style: Theme.of(context).textTheme.titleMedium
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutButton(BuildContext context, WidgetRef ref, double total, String? userId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: userId == null 
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please sign in to checkout'))
                );
              }
            : () => _processCheckout(context, ref, total, userId),
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

  void _processCheckout(BuildContext context, WidgetRef ref, double total, String userId) {
    // Implement your checkout logic here
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
              ref.read(cartProvider.notifier).clearCart(userId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully!'))
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref, String? userId) {
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
              if (userId != null) {
                ref.read(cartProvider.notifier).clearCart(userId);
              }
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

  void _showUndoSnackbar(BuildContext context, WidgetRef ref, CartItem item, String? userId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            if (userId != null) {
              ref.read(cartProvider.notifier).addToCart(userId, item);
            }
          },
        ),
      ),
    );
  }
}