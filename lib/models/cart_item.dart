class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String farmId;
  final String farmName;
  final String unit;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.farmId,
    required this.farmName,
    required this.unit,
    required this.imageUrl,
  });

  String get name => title;

  CartItem copyWith({
    String? id,
    String? productId,
    String? title,
    double? price,
    int? quantity,
    String? farmId,
    String? farmName,
    String? unit,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}