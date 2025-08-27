// import removed: flutter/foundation.dart
import '../services/supabase_service.dart';
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

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());

class CartState {
  final List<CartItem> items;
  final double deliveryFee;
  final double serviceFee;
  CartState({required this.items, this.deliveryFee = 0, this.serviceFee = 15.0});
  double get subtotal => items.fold(0, (total, item) => total + item.totalPrice);
  double get total => subtotal + deliveryFee + serviceFee;
}

class CartNotifier extends StateNotifier<CartState> {
  final SupabaseService _supabaseService = SupabaseService();
  CartNotifier() : super(CartState(items: []));

  String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'en_ZA',
      symbol: 'R',
      decimalDigits: 2,
    ).format(price);
  }

  Future<void> loadCart(String userId) async {
    final data = await _supabaseService.client
      .from('cart')
      .select()
      .eq('user_id', userId);
    final items = <CartItem>[];
    for (var item in data) {
      items.add(CartItem.fromMap(item));
    }
    state = CartState(items: items);
  }

  Future<void> addToCart(String userId, CartItem item) async {
    await _supabaseService.client.from('cart').insert({
      'user_id': userId,
      ...item.toMap(),
    });
    await loadCart(userId);
  }

  Future<void> removeFromCart(String userId, String cartItemId) async {
    await _supabaseService.client.from('cart')
      .delete()
      .eq('user_id', userId)
      .eq('id', cartItemId);
    await loadCart(userId);
  }

  Future<void> clearCart(String userId) async {
    await _supabaseService.client.from('cart')
      .delete()
      .eq('user_id', userId);
    await loadCart(userId);
  }

  Future<void> updateQuantity(String userId, String cartItemId, int newQuantity) async {
    await _supabaseService.client.from('cart')
      .update({'quantity': newQuantity})
      .eq('user_id', userId)
      .eq('id', cartItemId);
    await loadCart(userId);
  }
}

// Riverpod provider
// Removed duplicate ChangeNotifierProvider declaration