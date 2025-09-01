import 'package:farm_bracket/screens/home/welcome_screen.dart';
import 'package:farm_bracket/screens/profile/help_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import 'providers/theme_data_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'providers/language_provider.dart';
import 'providers/onboarding_complete_provider.dart';

// Routes
import 'routes/app_routes.dart';
import 'routes/navigation_analytics_observer.dart';

// Screens
import 'screens/onboarding/onboarding_flow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('cart');
  await Hive.openBox('favorites');
  await Hive.openBox('settings');

  // Check if it's the first launch
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(ProviderScope(child: FarmBracketApp(isFirstLaunch: isFirstLaunch)));
}

class FarmBracketApp extends ConsumerWidget {
  final bool isFirstLaunch;
  const FarmBracketApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);
    final themeMode = ref.watch(themeModeProvider).themeMode;
    final locale = ref.watch(languageProvider).currentLocale;
    final onboardingComplete = ref.watch(onboardingCompleteProvider);

    // If first launch, show onboarding regardless of onboardingComplete
    final showOnboarding = isFirstLaunch || !onboardingComplete;

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
      home: showOnboarding
          ? OnboardingFlow(
              onComplete: () async {
                ref
                    .read(onboardingCompleteProvider.notifier)
                    .completeOnboarding();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstLaunch', false);
              },
            )
          : PopScope(
              canPop: true,
              onPopInvokedWithResult: (didPop, result) {},
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
            ),
    );
  }
}
