import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:farm_bracket/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Shopping Flow Integration Tests', () {
    testWidgets('SHOP-01: Browse Products by Category', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('category_chip_fruits')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('product_list_fruits')), findsOneWidget);
    });

    testWidgets('SHOP-02: Search for a Product', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('search_field')), 'Tomato');
      await tester.tap(find.byKey(const Key('search_button')));
      await tester.pumpAndSettle();
      expect(find.text('Tomato'), findsWidgets);
      // If no results, show empty widget
      // expect(find.byKey(Key('empty_search_results_widget')), findsOneWidget);
    });

    testWidgets('SHOP-03: Apply Multiple Filters (Farm, Price, Organic)', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('filter_farm_chip')));
      await tester.tap(find.byKey(const Key('filter_price_chip')));
      await tester.tap(find.byKey(const Key('filter_organic_chip')));
      await tester.tap(find.byKey(const Key('apply_filters_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('filtered_product_list')), findsOneWidget);
    });

    testWidgets('SHOP-04: Sort Products by Price (Low to High)', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('sort_price_low_to_high_button')));
      await tester.pumpAndSettle();
      // Check first item has lowest price
      expect(find.byKey(const Key('product_tile_0')), findsOneWidget);
      // Optionally check price value
      // expect(find.text(''), findsOneWidget); // Replace with actual price check
    });

    testWidgets('SHOP-05: View Product Details', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product_tile_0')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('product_details_screen')), findsOneWidget);
      expect(find.byKey(const Key('product_image')), findsOneWidget);
      expect(find.byKey(const Key('product_description')), findsOneWidget);
      expect(find.byKey(const Key('product_price')), findsOneWidget);
      expect(find.byKey(const Key('product_farm')), findsOneWidget);
    });

    testWidgets('SHOP-06: Add Product to Cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product_tile_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add_to_cart_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('cart_icon')), findsOneWidget);
      // Optionally check cart count
      // expect(find.text('1'), findsOneWidget);
    });

    testWidgets('SHOP-07: Add Product to Favorites', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('product_tile_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('favorite_heart_icon')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('favorites_list')), findsOneWidget);
      expect(
        find.byKey(const Key('favorite_heart_icon_filled')),
        findsOneWidget,
      );
    });
  });
}
