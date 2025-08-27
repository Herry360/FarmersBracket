import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());


class AuthProvider with ChangeNotifier {
  final SupabaseClient _supabase;
  final Box _authBox;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider({SupabaseClient? supabase, Box? authBox})
      : _supabase = supabase ?? Supabase.instance.client,
        _authBox = authBox ?? Hive.box('auth') {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final storedSession = _authBox.get('session');
    if (storedSession != null) {
      _currentUser = _supabase.auth.currentUser;
    }
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      _currentUser = response.user;
      await _authBox.put('session', response.session?.toJson());
      
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _currentUser = response.user;
      await _authBox.put('session', response.session?.toJson());
      
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _authBox.clear();
      _currentUser = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error signing out';
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      _errorMessage = 'Error sending password reset email';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
