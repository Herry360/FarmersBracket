import 'package:flutter/material.dart';

class AppTheme {
  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.light,
      primary: const Color(0xFF2E7D32),
      secondary: const Color(0xFFFF9800),
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      error: Colors.redAccent,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    ),
    cardTheme: const CardThemeData(
      elevation: 3,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFF2E7D32)),
      ),
    ),
  splashColor: Colors.greenAccent.withAlpha(25),
  highlightColor: Colors.greenAccent.withAlpha(13),
    shadowColor: Colors.black12,
    dividerColor: Colors.grey.shade300,
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacing(),
      AppGradients(),
    ],
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.dark,
      primary: const Color(0xFF4CAF50),
      secondary: const Color(0xFFFFA726),
      surface: const Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      error: Colors.redAccent,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    cardTheme: const CardThemeData(
      elevation: 3,
      color: Color(0xFF1E1E1E),
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFF616161)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFF616161)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Color(0xFF4CAF50)),
      ),
    ),
  splashColor: Colors.greenAccent.withAlpha(25),
  highlightColor: Colors.greenAccent.withAlpha(13),
    shadowColor: Colors.black26,
    dividerColor: Colors.grey.shade700,
    extensions: const <ThemeExtension<dynamic>>[
      AppSpacing(),
      AppGradients(),
    ],
  );

}

@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double small;
  final double medium;
  final double large;
  const AppSpacing({this.small = 8, this.medium = 16, this.large = 32});
  @override
  AppSpacing copyWith({double? small, double? medium, double? large}) => AppSpacing(
    small: small ?? this.small,
    medium: medium ?? this.medium,
    large: large ?? this.large,
  );
  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) => this;
}

@immutable
class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primaryGradient;
  final LinearGradient cardGradient;
  const AppGradients()
      : primaryGradient = const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        cardGradient = const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
  @override
  AppGradients copyWith({LinearGradient? primaryGradient, LinearGradient? cardGradient}) => const AppGradients();
  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) => this;
}
