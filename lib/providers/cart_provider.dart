import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  Null get imageUrl => null;

  Null get farmID => null;

  Null get farm => null;

  Null get unit => null;

  num? get totalPrice => null;

  CartItem copyWith({
    String? id,
    String? title,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  double get subtotal {
    double subtotal = 0.0;
    _items.forEach((key, cartItem) {
      subtotal += cartItem.price * cartItem.quantity;
    });
    return subtotal;
  }

  void addItem({
    required String productId,
    required String title,
    required double price,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateItemQuantity(String itemId, int newQuantity) {
    if (_items.containsKey(itemId) && newQuantity > 0) {
      _items.update(
        itemId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: newQuantity,
        ),
      );
      notifyListeners();
    } else if (_items.containsKey(itemId) && newQuantity <= 0) {
      removeItem(itemId);
    }
  }
}