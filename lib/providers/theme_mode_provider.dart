import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final themeModeProvider = ChangeNotifierProvider<ThemeModeProvider>((ref) {
  // Inject dependencies here if needed
  return ThemeModeProvider();
});

class ThemeModeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeModeProvider();

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}