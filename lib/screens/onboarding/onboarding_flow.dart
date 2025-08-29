import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../main_navigation.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required Future<Null> Function() onComplete});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> pages = [
    const _OnboardingPageData(
      lottie: 'assets/lottie/onboarding_1.json',
      title: 'Welcome to FarmBracket!',
      description:
          'Your gateway to fresh, local farm produce delivered to your door.',
    ),
    const _OnboardingPageData(
      lottie: 'assets/lottie/onboarding_2.json',
      title: 'Discover Fresh Farm Products',
      description:
          'Browse a wide variety of organic fruits, vegetables, and dairy from local farms.',
    ),
    const _OnboardingPageData(
      lottie: 'assets/lottie/onboarding_3.json',
      title: 'Easy Ordering & Fast Delivery',
      description:
          'Order in a few taps and get your produce delivered quickly and safely.',
    ),
  ];

  void _navigateToMainApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToMainApp,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(page.lottie, height: 180, repeat: true),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(page.description, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      _navigateToMainApp();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String lottie;
  final String title;
  final String description;
  const _OnboardingPageData({
    required this.lottie,
    required this.title,
    required this.description,
  });
}