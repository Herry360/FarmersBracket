
import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/auth_provider.dart';


void main() {
  group('AuthProvider UI-only tests', () {
    late AuthProvider provider;

    setUp(() {
      provider = AuthProvider();
    });

    test('Sign up sets user', () async {
      await provider.signUp(
        name: 'Test',
        email: 'test@example.com',
        phone: '1234567890',
        address: 'Test Address',
      );
      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser!.name, 'Test');
    });

    test('Sign in sets mock user', () async {
      await provider.signIn(email: 'test@example.com');
      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser!.email, 'test@example.com');
    });

    test('Sign out clears user', () {
      provider.signOut();
      expect(provider.currentUser, isNull);
    });

    test('Reset password does not throw', () async {
      await provider.resetPassword('test@example.com');
      expect(provider.isLoading, isFalse);
    });

    test('Clear error sets errorMessage to null', () {
      provider.clearError();
      expect(provider.errorMessage, isNull);
    });

    test('Loading state is set correctly during signUp', () async {
      final future = provider.signUp(
        name: 'Test',
        email: 'test@example.com',
        phone: '1234567890',
        address: 'Test Address',
      );
      expect(provider.isLoading, true);
      await future;
      expect(provider.isLoading, false);
    });
  });
}
