class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String farmId;
  final String farmName;
  final String unit;
  final String name;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.farmId,
    required this.farmName,
    required this.unit,
    required this.name,
  });

  CartItem copyWith({
    String? id,
    String? title,
    int? quantity,
    double? price,
    String? imageUrl,
    String? farmId,
    String? farmName,
    String? unit,
    String? name,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      unit: unit ?? this.unit,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'farmId': farmId,
      'farmName': farmName,
      'unit': unit,
      'name': name,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      title: map['title'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      farmId: map['farmId'] as String,
      farmName: map['farmName'] as String,
      unit: map['unit'] as String,
      name: map['name'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          quantity == other.quantity &&
          price == other.price &&
          imageUrl == other.imageUrl &&
          farmId == other.farmId &&
          farmName == other.farmName &&
          unit == other.unit &&
          name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      quantity.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      farmId.hashCode ^
      farmName.hashCode ^
      unit.hashCode ^
      name.hashCode;

  @override
  String toString() {
    return 'CartItem(id: $id, title: $title, quantity: $quantity, price: $price, imageUrl: $imageUrl, farmId: $farmId, farmName: $farmName, unit: $unit, name: $name)';
  }
}