import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Text is found', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Hello, FarmBracket!'))),
    );
    expect(find.text('Hello, FarmBracket!'), findsOneWidget);
  });

  testWidgets('Text is centered and uses correct style', (
    WidgetTester tester,
  ) async {
    const testKey = Key('test_text');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Hello, FarmBracket!',
              key: testKey,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(testKey), findsOneWidget);
    final centerFinder = find.ancestor(
      of: find.byKey(testKey),
      matching: find.byType(Center),
    );
    expect(centerFinder, findsOneWidget);
    final textWidget = tester.widget<Text>(find.byKey(testKey));
    expect(textWidget.style?.fontSize, 24);
    expect(textWidget.style?.fontWeight, FontWeight.bold);
  });

  testWidgets('Text is inside a Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Hello, FarmBracket!'))),
    );
    final scaffoldFinder = find.ancestor(
      of: find.text('Hello, FarmBracket!'),
      matching: find.byType(Scaffold),
    );
    expect(scaffoldFinder, findsOneWidget);
  });
}
