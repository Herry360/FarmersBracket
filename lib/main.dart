import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Providers
import 'providers/theme_data_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'providers/language_provider.dart';

// Routes
import 'routes/app_routes.dart';

// Screens
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('auth');
  await Hive.openBox('cart');
  await Hive.openBox('favorites');
  await Hive.openBox('settings');

  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(
    const ProviderScope(
      child: FarmBracketApp(),
    ),
  );
}

class FarmBracketApp extends ConsumerWidget {
  const FarmBracketApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);
    final themeMode = ref.watch(themeModeProvider).themeMode;
    final locale = ref.watch(languageProvider).currentLocale;

    return MaterialApp(
      title: 'FarmBracket',
      debugShowCheckedModeBanner: false,
      theme: themeData.lightTheme,
      darkTheme: themeData.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en', 'ZA'),
        Locale('af', 'ZA'),
        Locale('zu', 'ZA'),
      ],
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
      home: const WelcomeScreen(),
    );
  }
}