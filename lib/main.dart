import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Providers
import 'providers/theme_data_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'providers/language_provider.dart';
import 'providers/onboarding_complete_provider.dart';

// Routes
import 'routes/app_routes.dart';
import 'routes/navigation_analytics_observer.dart'; // Importing NavigationAnalyticsObserver

// Screens
import 'screens/welcome_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/onboarding/onboarding_flow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  // ...existing code...
  await Hive.openBox('cart');
  await Hive.openBox('favorites');
  await Hive.openBox('settings');

  // ...existing code...

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

    final onboardingComplete = ref.watch(onboardingCompleteProvider);
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
      routes: {
        ...AppRoutes.routes,
        '/help': (context) => const HelpCenterScreen(),
      },
      onGenerateRoute: AppRoutes.onGenerateRoute,
      navigatorObservers: [NavigationAnalyticsObserver()],
      home: onboardingComplete
          ? PopScope(
              canPop: true,
              onPopInvoked: (didPop) {},
              child: Builder(
                builder: (context) => Scaffold(
                  body: const WelcomeScreen(),
                  floatingActionButton: FloatingActionButton.extended(
                    icon: const Icon(Icons.help_outline),
                    label: const Text('Help Center'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                ),
              ),
            )
          : OnboardingFlow(onComplete: () {
              ref.read(onboardingCompleteProvider.notifier).completeOnboarding();
            }),
    );
  }
}