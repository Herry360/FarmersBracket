import 'package:flutter/material.dart';

class MockUser {
  final String name;
  final String email;
  final String phone;
  final String address;
  MockUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}

class AuthProvider with ChangeNotifier {
  MockUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  MockUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = MockUser(
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn({required String email}) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = MockUser(
      name: 'Test',
      email: email,
      phone: '1234567890',
      address: 'Test Address',
    );
    _isLoading = false;
    notifyListeners();
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 100));
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
