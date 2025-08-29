import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          key: const Key('navigateButton'),
          child: const Text('Go to Next'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NextScreen()),
            );
          },
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next')),
      body: const Center(child: Text('Next Screen')),
    );
  }
}

void main() {
  testWidgets('Home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byKey(const Key('navigateButton')), findsOneWidget);
  });

  testWidgets('Navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.tap(find.byKey(const Key('navigateButton')));
    await tester.pumpAndSettle();
    expect(find.byType(NextScreen), findsOneWidget);
    expect(find.text('Next Screen'), findsOneWidget);
  });
}
