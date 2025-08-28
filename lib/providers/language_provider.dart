import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');
  Locale _currentLocale = const Locale('en', 'ZA');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final languageCode = _settingsBox.get('language', defaultValue: 'en');
    _currentLocale = Locale(languageCode, 'ZA');
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode, 'ZA');
    await _settingsBox.put('language', languageCode);
    notifyListeners();
  }

  String getCurrentLanguage() {
    return _currentLocale.languageCode;
  }

  // South African languages support
  static const Map<String, String> languages = {
    'en': 'English',
    'af': 'Afrikaans',
    'zu': 'Zulu',
  };
}

// Riverpod provider
final languageProvider = ChangeNotifierProvider<LanguageProvider>((ref) {
  // Inject dependencies here if needed
  return LanguageProvider();
});