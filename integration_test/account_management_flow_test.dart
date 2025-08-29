import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:farm_bracket/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Account Management Flow Integration Tests', () {
    testWidgets('ACCT-01: Edit Profile Information', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('profile_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('edit_profile_button')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('name_field')), 'New Name');
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'newemail@example.com',
      );
      await tester.tap(find.byKey(const Key('save_profile_button')));
      await tester.pumpAndSettle();
      expect(find.text('New Name'), findsOneWidget);
      expect(find.text('newemail@example.com'), findsOneWidget);
    });

    testWidgets('ACCT-02: Change Password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('profile_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('change_password_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('old_password_field')),
        'OldPassword123',
      );
      await tester.enterText(
        find.byKey(const Key('new_password_field')),
        'NewPassword456',
      );
      await tester.tap(find.byKey(const Key('save_password_button')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Password changed'), findsOneWidget);
    });

    testWidgets('ACCT-03: Toggle Notification Preferences', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('profile_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('notification_toggle')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('notification_toggle')), findsOneWidget);
      // Optionally check for confirmation message
      // expect(find.textContaining('Notifications updated'), findsOneWidget);
    });

    testWidgets('ACCT-04: Switch between Light and Dark Theme', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('theme_switch_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('dark_theme')), findsOneWidget);
      await tester.tap(find.byKey(const Key('theme_switch_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('light_theme')), findsOneWidget);
    });
  });
}
