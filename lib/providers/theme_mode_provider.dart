import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final themeModeProvider = ChangeNotifierProvider<ThemeModeProvider>((ref) => ThemeModeProvider());

class ThemeModeProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeModeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeModeIndex = _settingsBox.get('themeMode', defaultValue: ThemeMode.system.index);
    _themeMode = ThemeMode.values[themeModeIndex];
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsBox.put('themeMode', mode.index);
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _settingsBox.put('themeMode', _themeMode.index);
    notifyListeners();
  }
}