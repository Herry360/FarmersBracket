import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('Initial cart is empty', () {
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.totalAmount, 0.0);
      expect(cartProvider.subtotal, 0.0);
    });

    test('Add item to cart', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 2,
      );
      expect(cartProvider.items.length, 1);
      expect(cartProvider.items['1']!.title, 'Apple');
      expect(cartProvider.items['1']!.quantity, 2);
    });

    test('Add same item increases quantity', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 1,
      );
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 2,
      );
      expect(cartProvider.items['1']!.quantity, 3);
    });

    test('Remove item from cart', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 1,
      );
      cartProvider.removeItem('1');
      expect(cartProvider.items.containsKey('1'), isFalse);
    });

    test('Remove single item decreases quantity', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 2,
      );
      cartProvider.removeSingleItem('1');
      expect(cartProvider.items['1']!.quantity, 1);
    });

    test('Remove single item removes if quantity is 1', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 1,
      );
      cartProvider.removeSingleItem('1');
      expect(cartProvider.items.containsKey('1'), isFalse);
    });

    test('Clear cart removes all items', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 1,
      );
      cartProvider.addItem(
        productId: '2',
        title: 'Banana',
        price: 5.0,
        quantity: 3,
      );
      cartProvider.clear();
      expect(cartProvider.items, isEmpty);
    });

    test('Total and subtotal calculation', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 2,
      );
      cartProvider.addItem(
        productId: '2',
        title: 'Banana',
        price: 5.0,
        quantity: 3,
      );
      expect(cartProvider.subtotal, 10.0 * 2 + 5.0 * 3);
      expect(cartProvider.totalAmount, cartProvider.subtotal); // If no extra fees
    });

    test('Update item quantity', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 2,
      );
      cartProvider.updateItemQuantity('1', 5);
      expect(cartProvider.items['1']!.quantity, 5);
    });

    test('Update item quantity to zero removes item', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 2,
      );
      cartProvider.updateItemQuantity('1', 0);
      expect(cartProvider.items.containsKey('1'), isFalse);
    });

    test('Add item with farm details', () {
      cartProvider.addItem(
        productId: '1',
        title: 'Apple',
        price: 10.0,
        quantity: 1,
        farmId: 'farm1',
        farmName: 'Farm Fresh',
        unit: 'kg',
        imageUrl: 'http://image.url/apple.png',
      );
      final item = cartProvider.items['1']!;
      expect(item.farmId, 'farm1');
      expect(item.farmName, 'Farm Fresh');
      expect(item.unit, 'kg');
      expect(item.imageUrl, 'http://image.url/apple.png');
    });
  });
}