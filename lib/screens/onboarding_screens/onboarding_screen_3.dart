import 'package:flutter/material.dart';
import '../main_navigation.dart';


class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 100, color: Colors.brown),
            const SizedBox(height: 32),
            Text('Easy Ordering & Fast Delivery', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text('Order in a few taps and get your produce delivered quickly and safely.', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
