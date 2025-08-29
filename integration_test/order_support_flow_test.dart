import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:farm_bracket/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Order & Support Flow Integration Tests', () {
    testWidgets('ORDER-01: View Order History', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_history_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('order_history_list')), findsOneWidget);
    });

    testWidgets('ORDER-02: View Order Details', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_history_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_tile_0')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('order_details_screen')), findsOneWidget);
    });

    testWidgets('ORDER-03: Track an Active Order (Mocked)', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('track_order_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('order_tracking_map')), findsOneWidget);
      expect(find.byKey(const Key('driver_location_icon')), findsOneWidget);
    });

    testWidgets('ORDER-04: Reorder a Previous Order', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_history_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reorder_button_0')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('cart_screen')), findsOneWidget);
    });

    testWidgets('SUPP-01: Write a Review for a Purchased Product', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_history_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_tile_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('write_review_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('review_text_field')),
        'Great product!',
      );
      await tester.tap(find.byKey(const Key('submit_review_button')));
      await tester.pumpAndSettle();
      expect(find.text('Great product!'), findsOneWidget);
    });

    testWidgets('SUPP-02: Report a Damaged Item from Order History', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_history_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_tile_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report_damaged_item_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('support_ticket_text_field')),
        'Item was damaged',
      );
      await tester.tap(find.byKey(const Key('upload_photo_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('submit_ticket_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Ticket created'), findsOneWidget);
    });

    testWidgets('SUPP-03: Report a Missing Item from Order History', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_history_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('order_tile_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report_missing_item_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('support_ticket_text_field')),
        'Item was missing',
      );
      await tester.tap(find.byKey(const Key('submit_ticket_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Ticket created'), findsOneWidget);
    });

    testWidgets('SUPP-04: Initiate a Chat for a Late Delivery', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('track_order_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('late_delivery_chat_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('support_chat_screen')), findsOneWidget);
      expect(find.textContaining('Order details'), findsOneWidget);
    });

    testWidgets('SUPP-05: View Support Ticket History', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('support_tickets_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('support_ticket_history_list')),
        findsOneWidget,
      );
    });
  });
}
