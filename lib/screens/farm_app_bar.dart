import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farm_model.dart';
import '../providers/cart_provider.dart' as cart_provider;
import 'cart_screen.dart' as cart_screen;

class FarmAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Farm farm;
  const FarmAppBar({Key? key, required this.farm}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cart_provider.cartProvider);
    return AppBar(
      title: Semantics(
        label: 'Farm name: ${farm.name}',
        child: Text(
          farm.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        CartIconWithBadge(cartItems: cart.items),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CartIconWithBadge extends StatelessWidget {
  final List<dynamic> cartItems; // Accepts List<Product> or List<CartItem>
  const CartIconWithBadge({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          button: true,
          label: 'Cart with ${cartItems.length} items',
          child: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => cart_screen.CartScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening cart with ${cartItems.length} items.')),
              );
            },
          ),
        ),
        if (cartItems.isNotEmpty)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Center(
                child: Text(
                  '${cartItems.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
