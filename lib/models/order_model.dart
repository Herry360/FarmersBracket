
class Order {
  final String id;
  final String customerId;
  final DateTime date;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;

  Order({
    required this.id,
    required this.customerId,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      date: DateTime.parse(json['date'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Null get total => null;

  Null get orderDate => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
    };
  }
}

class OrderItem {
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  String? get name => null;

  Null get imageUrl => null;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
enum OrderStatus {
  pending,
  delivered,
  cancelled,
}