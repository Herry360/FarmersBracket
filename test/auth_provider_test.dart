import 'package:flutter_test/flutter_test.dart';
import 'package:farm_bracket/providers/auth_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Removed unused import

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockAuthBox extends Mock implements Box {}
class MockAuthResponse extends Mock implements AuthResponse {}
class MockUser extends Mock implements User {}
class MockSession extends Mock implements Session {}

void main() {
  late AuthProvider authProvider;
  late MockSupabaseClient mockSupabase;
  late MockAuthBox mockAuthBox;
  late MockUser mockUser;
  late MockSession mockSession;
  late MockAuthResponse mockAuthResponse;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockAuthBox = MockAuthBox();
    mockUser = MockUser();
    mockSession = MockSession();
    mockAuthResponse = MockAuthResponse();

  authProvider = AuthProvider(supabase: mockSupabase, authBox: mockAuthBox);
  });

  group('AuthProvider', () {
    test('Register with valid data', () async {
      when(mockSupabase.auth.signUp(
        email: anyNamed('email'),
        password: anyNamed('password') ?? '',
        data: anyNamed('data'),
      )).thenAnswer((_) async => mockAuthResponse);
      when(mockAuthResponse.user).thenReturn(mockUser);
      when(mockAuthResponse.session).thenReturn(mockSession);
      when(mockSession.toJson()).thenReturn({'token': 'abc'});

      await authProvider.signUp(
        email: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe',
        phoneNumber: '1234567890',
      );

  expect(authProvider.currentUser, mockUser);
  expect(authProvider.errorMessage, isNull);
  verify(mockAuthBox.put('session', any ?? '')).called(1);
    });

    test('Register with missing fields', () async {
      when(mockSupabase.auth.signUp(
        email: anyNamed('email'),
        password: anyNamed('password') ?? '',
        data: anyNamed('data'),
      )).thenThrow(AuthException('Missing fields'));

      await authProvider.signUp(
        email: '',
        password: '',
        firstName: '',
        lastName: '',
        phoneNumber: '',
      );

      expect(authProvider.currentUser, isNull);
      expect(authProvider.errorMessage, isNotNull);
    });

    test('Duplicate registration', () async {
      when(mockSupabase.auth.signUp(
        email: anyNamed('email'),
        password: anyNamed('password') ?? '',
        data: anyNamed('data'),
      )).thenThrow(AuthException('User already exists'));

      await authProvider.signUp(
        email: 'duplicate@example.com',
        password: 'password123',
        firstName: 'Jane',
        lastName: 'Doe',
        phoneNumber: '0987654321',
      );

      expect(authProvider.currentUser, isNull);
      expect(authProvider.errorMessage, contains('User already exists'));
    });

    test('Login with correct credentials', () async {
      when(mockSupabase.auth.signInWithPassword(
        email: anyNamed('email'),
        password: anyNamed('password') ?? '',
      )).thenAnswer((_) async => mockAuthResponse);
      when(mockAuthResponse.user).thenReturn(mockUser);
      when(mockAuthResponse.session).thenReturn(mockSession);
      when(mockSession.toJson()).thenReturn({'token': 'xyz'});

      await authProvider.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(authProvider.currentUser, mockUser);
      expect(authProvider.errorMessage, isNull);
      verify(mockAuthBox.put('session', any)).called(1);
    });

    test('Login with incorrect credentials', () async {
      when(mockSupabase.auth.signInWithPassword(
        email: anyNamed('email'),
        password: anyNamed('password') ?? '',
      )).thenThrow(AuthException('Invalid credentials'));

      await authProvider.signIn(
        email: 'wrong@example.com',
        password: 'wrongpassword',
      );

      expect(authProvider.currentUser, isNull);
      expect(authProvider.errorMessage, contains('Invalid credentials'));
    });

    test('Sign out clears user and session', () async {
      when(mockSupabase.auth.signOut()).thenAnswer((_) async {});
      when(mockAuthBox.clear()).thenAnswer((_) async => Future.value(0));

      // Instead of accessing private field, simulate sign in first
      await authProvider.signIn(
        email: 'test@example.com',
        password: 'password123',
      );
      await authProvider.signOut();

      expect(authProvider.currentUser, isNull);
      expect(authProvider.errorMessage, isNull);
      verify(mockAuthBox.clear()).called(1);
    });

    test('Sign out handles error', () async {
      when(mockSupabase.auth.signOut()).thenThrow(Exception('Sign out failed'));

      await authProvider.signOut();

      expect(authProvider.errorMessage, contains('Error signing out'));
    });

    test('Reset password sends email', () async {
      when(mockSupabase.auth.resetPasswordForEmail(any)).thenAnswer((_) async {});

      await authProvider.resetPassword('test@example.com');

      expect(authProvider.errorMessage, isNull);
    });

    test('Reset password handles error', () async {
      when(mockSupabase.auth.resetPasswordForEmail(any)).thenThrow(Exception('Failed'));

      await authProvider.resetPassword('test@example.com');
    test('Clear error sets errorMessage to null', () {
      when(mockSupabase.auth.signInWithPassword(
        email: anyNamed('email'),
        password: anyNamed('password') ?? '',
      )).thenThrow(AuthException('Some error'));

      authProvider.signIn(email: '', password: '');
      authProvider.clearError();
      expect(authProvider.errorMessage, isNull);
    });
    });

    test('Loading state is set correctly during signUp', () async {
      when(mockSupabase.auth.signUp(
        email: anyNamed('email'),
        password: anyNamed('password'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => mockAuthResponse);
      when(mockAuthResponse.user).thenReturn(mockUser);

      final future = authProvider.signUp(
        email: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe',
        phoneNumber: '1234567890',
      );

      expect(authProvider.isLoading, true);
      await future;
      expect(authProvider.isLoading, false);
    });
  });
}
