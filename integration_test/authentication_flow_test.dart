import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:farm_bracket/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('AUTH-01: Successful User Registration with Email', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to registration screen
      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle();

      // Fill registration form
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'testuser@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'TestPassword123',
      );
      await tester.enterText(find.byKey(const Key('name_field')), 'Test User');
      await tester.tap(find.byKey(const Key('submit_registration_button')));
      await tester.pumpAndSettle();

      // Expect navigation to Home Screen
      expect(find.byKey(const Key('home_screen')), findsOneWidget);
    });

    testWidgets('AUTH-02: Successful Login with Google/Apple', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap Google login button
      await tester.tap(find.byKey(const Key('google_login_button')));
      await tester.pumpAndSettle();
      // Simulate successful login (mock or test environment)
      expect(find.byKey(const Key('home_screen')), findsOneWidget);

      // Optionally test Apple login
      // await tester.tap(find.byKey(Key('apple_login_button')));
      // await tester.pumpAndSettle();
      // expect(find.byKey(Key('home_screen')), findsOneWidget);
    });

    testWidgets('AUTH-03: Failed Login (Invalid Credentials)', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('email_field')),
        'wronguser@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'WrongPassword',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Expect error message
      expect(find.textContaining('Invalid credentials'), findsOneWidget);
    });

    testWidgets('AUTH-04: Location Permission Granted', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate granting location permission
      await tester.tap(
        find.byKey(const Key('location_permission_grant_button')),
      );
      await tester.pumpAndSettle();

      // Expect homepage shows nearby farms
      expect(find.byKey(const Key('nearby_farms_list')), findsOneWidget);
    });

    testWidgets('AUTH-05: Location Permission Denied -> Zip Code Entry', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate denying location permission
      await tester.tap(
        find.byKey(const Key('location_permission_deny_button')),
      );
      await tester.pumpAndSettle();

      // Enter zip code
      await tester.enterText(find.byKey(const Key('zip_code_field')), '12345');
      await tester.tap(find.byKey(const Key('submit_zip_code_button')));
      await tester.pumpAndSettle();

      // Expect homepage updates accordingly
      expect(find.byKey(const Key('homepage')), findsOneWidget);
      expect(find.textContaining('12345'), findsOneWidget);
    });

    testWidgets('AUTH-06: Interest Selection Persists', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Select interests
      await tester.tap(find.byKey(const Key('interest_chip_fruits')));
      await tester.tap(find.byKey(const Key('interest_chip_vegetables')));
      await tester.tap(find.byKey(const Key('submit_interests_button')));
      await tester.pumpAndSettle();

      // Restart app to check persistence
      app.main();
      await tester.pumpAndSettle();

      // Expect homepage feed influenced by selected interests
      expect(find.byKey(const Key('homepage_feed_fruits')), findsOneWidget);
      expect(find.byKey(const Key('homepage_feed_vegetables')), findsOneWidget);
    });
  });
}
