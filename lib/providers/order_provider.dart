import 'package:flutter/material.dart';

class OrderProviderClass {
  final String id;
  final String product;
  final int quantity;
  final double price;
  final DateTime date;

  OrderProviderClass({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.date,
  });
}

class OrderProvider with ChangeNotifier {
  final List<OrderProviderClass> _orders = [];

  List<OrderProviderClass> get orders => List.unmodifiable(_orders);

  void addOrder({
    required String product,
    required int quantity,
    required double price,
  }) {
    final order = OrderProviderClass(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
      quantity: quantity,
      price: price,
      date: DateTime.now(),
    );
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  Future<void> loadOrders() async {}
}