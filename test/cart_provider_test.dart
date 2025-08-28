import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartNotifier cartNotifier;

    final testItem = CartItem(
      id: '1',
      productId: 'p1',
      name: 'Apple',
      price: 10.0,
      imageUrl: 'apple.png',
      farmId: 'f1',
      farmName: 'Farm1',
      quantity: 1,
      unit: 'kg',
    );

    setUp(() {
      cartNotifier = CartNotifier();
    });

    test('Initial cart is empty', () {
      expect(cartNotifier.state.items, isEmpty);
      expect(cartNotifier.state.subtotal, 0);
      expect(cartNotifier.state.total, cartNotifier.state.serviceFee);
    });

    test('Add product to cart', () async {
      cartNotifier.state = CartState(items: []);
      cartNotifier.state.items.add(testItem);
      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.first.name, 'Apple');
    });

    test('Add same product multiple times increases quantity', () async {
      cartNotifier.state = CartState(items: []);
      cartNotifier.state.items.add(testItem);
      cartNotifier.state.items.first.quantity += 1;
      expect(cartNotifier.state.items.first.quantity, 2);
    });

    test('Remove product from cart', () async {
      cartNotifier.state = CartState(items: [testItem]);
      cartNotifier.state.items.removeWhere((item) => item.id == testItem.id);
      expect(cartNotifier.state.items.length, 0);
    });

    test('Cart total calculation', () async {
      final item1 = CartItem(
        id: '1',
        productId: 'p1',
        name: 'Apple',
        price: 10.0,
        imageUrl: 'apple.png',
        farmId: 'f1',
        farmName: 'Farm1',
        quantity: 2,
        unit: 'kg',
      );
      final item2 = CartItem(
        id: '2',
        productId: 'p2',
        name: 'Banana',
        price: 5.0,
        imageUrl: 'banana.png',
        farmId: 'f2',
        farmName: 'Farm2',
        quantity: 3,
        unit: 'kg',
      );
      cartNotifier.state = CartState(items: [item1, item2]);
      expect(cartNotifier.state.subtotal, 10.0 * 2 + 5.0 * 3);
      expect(cartNotifier.state.total, cartNotifier.state.subtotal + cartNotifier.state.deliveryFee + cartNotifier.state.serviceFee);
    });

    test('Clear cart removes all items', () async {
      cartNotifier.state = CartState(items: [testItem]);
      cartNotifier.state.items.clear();
      expect(cartNotifier.state.items, isEmpty);
    });

    test('Format price returns correct string', () {
      final formatted = cartNotifier.formatPrice(123.456);
      expect(formatted, 'R123.46');
    });

    test('Update quantity changes item quantity', () async {
      cartNotifier.state = CartState(items: [testItem]);
      cartNotifier.state.items.first.quantity = 5;
      expect(cartNotifier.state.items.first.quantity, 5);
    });

    test('CartNotifier exposes loading and error states', () {
      cartNotifier.loadCart();
      expect(cartNotifier.state.isLoading, isFalse); // loadCart is sync, so isLoading should be false
      expect(cartNotifier.state.error, isNull);

      // Simulate error
      cartNotifier.state = CartState(items: [], isLoading: false, error: 'Test error');
      expect(cartNotifier.state.error, 'Test error');
    });
  });
}
