import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

final themeDataProvider = ChangeNotifierProvider<ThemeDataProvider>((ref) {
  // Inject dependencies here if needed
  return ThemeDataProvider();
});

class ThemeDataProvider with ChangeNotifier {
  ThemeData _lightTheme = AppTheme.lightTheme;
  ThemeData _darkTheme = AppTheme.darkTheme;

  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;

  ThemeDataProvider() {
    _loadThemeData();
  }

  Future<void> _loadThemeData() async {
    notifyListeners();
  }

  Future<void> updateLightTheme(ThemeData newTheme) async {
    _lightTheme = newTheme;
    notifyListeners();
  }

  Future<void> updateDarkTheme(ThemeData newTheme) async {
    _darkTheme = newTheme;
    notifyListeners();
  }
}