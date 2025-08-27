import 'package:flutter/material.dart';
import 'onboarding_screen_2.dart';


class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/farm_logo.jpg', height: 120),
            const SizedBox(height: 32),
            Text('Welcome to FarmBracket!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text('Your gateway to fresh, local farm produce delivered to your door.', textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OnboardingScreen2()),
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
