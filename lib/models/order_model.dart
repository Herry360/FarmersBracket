import 'address_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final AddressModel shippingAddress;
  final double totalAmount;
  final String status; // e.g., Processing, Shipped, Delivered
  final DateTime orderDate;
  final String? shipmentStatus; // e.g., In Transit, Out for Delivery
  final String? trackingNumber;
  final DateTime? estimatedDelivery;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.shipmentStatus,
    this.trackingNumber,
    this.estimatedDelivery,
  });
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });
}
