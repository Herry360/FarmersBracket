import 'package:flutter/material.dart';
import 'onboarding_screen_3.dart';


class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 100, color: Colors.green),
            const SizedBox(height: 32),
            Text('Discover Fresh Farm Products', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text('Browse a wide variety of organic fruits, vegetables, and dairy from local farms.', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen3()),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
