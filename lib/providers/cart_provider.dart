// import removed: flutter/foundation.dart
// ...existing code...
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String farmId;
  final String farmName;
  int quantity;
  final String unit;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.farmId,
    required this.farmName,
    required this.quantity,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'farmId': farmId,
      'farmName': farmName,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      name: map['name'],
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'],
      farmId: map['farmId'],
      farmName: map['farmName'],
      quantity: map['quantity'],
      unit: map['unit'],
    );
  }

  double get totalPrice => price * quantity;
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  // Inject dependencies here if needed
  return CartNotifier();
});

class CartState {
  final List<CartItem> items;
  final List<CartItem> savedForLater;
  final double deliveryFee;
  final double serviceFee;
  final bool isLoading;
  final String? error;
  CartState({required this.items, this.savedForLater = const [], this.deliveryFee = 0, this.serviceFee = 15.0, this.isLoading = false, this.error});
  double get subtotal => items.fold(0, (total, item) => total + item.totalPrice);
  double get total => subtotal + deliveryFee + serviceFee;
}

class CartNotifier extends StateNotifier<CartState> {
  // Removed SupabaseService for UI-only refactor
  CartNotifier() : super(CartState(items: [], savedForLater: [], isLoading: false, error: null));
  // Save item for later
  void saveForLater(String cartItemId) {
    final item = state.items.where((i) => i.id == cartItemId).toList();
    if (item.isNotEmpty) {
      final updatedItems = state.items.where((i) => i.id != cartItemId).toList();
      final updatedSaved = List<CartItem>.from(state.savedForLater)..add(item.first);
      state = CartState(items: updatedItems, savedForLater: updatedSaved, isLoading: false, error: null);
    }
  }

  // Move item from saved for later back to cart
  void moveToCart(String cartItemId) {
    final item = state.savedForLater.where((i) => i.id == cartItemId).toList();
    if (item.isNotEmpty) {
      final updatedSaved = state.savedForLater.where((i) => i.id != cartItemId).toList();
      final updatedItems = List<CartItem>.from(state.items)..add(item.first);
      state = CartState(items: updatedItems, savedForLater: updatedSaved, isLoading: false, error: null);
    }
  }

  String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'en_ZA',
      symbol: 'R',
      decimalDigits: 2,
    ).format(price);
  }

  // UI only: load cart from local state
  void loadCart() {
    state = CartState(items: state.items, isLoading: true, error: null);
    try {
      // Simulate async load if needed
      state = CartState(items: state.items, isLoading: false, error: null);
    } catch (e) {
      state = CartState(items: state.items, isLoading: false, error: 'Error loading cart: $e');
    }
  }

  // UI only: add item to local cart
  void addToCart(CartItem item) {
  final updatedItems = List<CartItem>.from(state.items)..add(item);
  state = CartState(items: updatedItems, isLoading: false, error: null);
  }

  // UI only: remove item from local cart
  void removeFromCart(String cartItemId) {
  final updatedItems = state.items.where((item) => item.id != cartItemId).toList();
  state = CartState(items: updatedItems, isLoading: false, error: null);
  }

  // UI only: clear local cart
  void clearCart() {
  state = CartState(items: [], isLoading: false, error: null);
  }

  // UI only: update quantity in local cart
  void updateQuantity(String cartItemId, int newQuantity) {
    final updatedItems = state.items.map((item) {
      if (item.id == cartItemId) {
        return CartItem(
          id: item.id,
          productId: item.productId,
          name: item.name,
          price: item.price,
          imageUrl: item.imageUrl,
          farmId: item.farmId,
          farmName: item.farmName,
          quantity: newQuantity,
          unit: item.unit,
        );
      }
      return item;
    }).toList();
    state = CartState(items: updatedItems, isLoading: false, error: null);
  }
}

// Riverpod provider
// Removed duplicate ChangeNotifierProvider declaration