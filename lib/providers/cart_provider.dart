import 'package:farm_bracket/models/cart_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartProvider extends ChangeNotifier {
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

  double get subtotal => totalAmount;

  // This method is for your tests
  void addItem({
    required String productId,
    required String title,
    required double price,
    required int quantity,
    String farmId = '',
    String farmName = '',
    String unit = '',
    String imageUrl = '',
  }) {
    if (_items.containsKey(productId)) {
      // Item already exists, update quantity
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
          quantity: quantity,
          farmId: farmId,
          farmName: farmName,
          unit: unit,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  // This method is for your ProductsList widget
  void addToCart(CartItem cartItem) {
    if (_items.containsKey(cartItem.productId)) {
      // Item already exists, update quantity
      _items.update(
        cartItem.productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + cartItem.quantity,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        cartItem.productId,
        () => cartItem,
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

  void updateItemQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId) && newQuantity > 0) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: newQuantity,
        ),
      );
      notifyListeners();
    } else if (_items.containsKey(productId) && newQuantity <= 0) {
      removeItem(productId);
    }
  }

  void clear() {}
}

// Make sure this line is at the bottom of the file
final cartProvider = ChangeNotifierProvider<CartProvider>((ref) => CartProvider());