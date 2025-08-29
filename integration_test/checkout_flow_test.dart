import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:farm_bracket/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Checkout Flow Integration Tests', () {
    testWidgets('CHECK-01: Navigate Checkout Steps', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      // Tap through checkout steps
      await tester.tap(find.byKey(const Key('checkout_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('address_step')), findsOneWidget);
      await tester.tap(find.byKey(const Key('next_step_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('time_step')), findsOneWidget);
      await tester.tap(find.byKey(const Key('next_step_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('payment_step')), findsOneWidget);
      await tester.tap(find.byKey(const Key('next_step_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('review_step')), findsOneWidget);
    });

    testWidgets('CHECK-02: Select a Saved Delivery Address', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('checkout_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('saved_address_tile_0')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('selected_address_display')), findsOneWidget);
    });

    testWidgets('CHECK-03: Add a New Address During Checkout', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('checkout_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_new_address_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('address_field')),
        '123 Farm Lane',
      );
      await tester.enterText(find.byKey(const Key('city_field')), 'Farmville');
      await tester.enterText(find.byKey(const Key('zip_field')), '54321');
      await tester.tap(find.byKey(const Key('save_address_button')));
      await tester.pumpAndSettle();
      expect(find.text('123 Farm Lane'), findsOneWidget);
    });

    testWidgets('CHECK-04: Select Delivery Time Slot', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('checkout_button')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('next_step_button')),
      ); // Address -> Time
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('time_slot_0')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('selected_time_display')), findsOneWidget);
    });

    testWidgets('CHECK-05: Complete Order with Mock Payment', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('checkout_button')));
      await tester.pumpAndSettle();
      // Go to payment step
      await tester.tap(find.byKey(const Key('next_step_button'))); // Address
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('next_step_button'))); // Time
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('next_step_button'))); // Payment
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('pay_now_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('order_confirmation_screen')),
        findsOneWidget,
      );
    });
  });
}
