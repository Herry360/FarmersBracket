import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Arithmetic Operations', () {
    test('Addition works', () {
      expect(2 + 3, equals(5));
    });

    test('Subtraction works', () {
      expect(5 - 2, equals(3));
    });

    test('Multiplication works', () {
      expect(4 * 3, equals(12));
    });

    test('Division works', () {
      expect(10 / 2, equals(5));
      expect(10 / 4, equals(2.5));
    });

    test('Integer division works', () {
      expect(10 ~/ 3, equals(3));
      expect(9 ~/ 3, equals(3));
    });

    test('Modulo works', () {
      expect(10 % 3, equals(1));
      expect(12 % 4, equals(0));
    });

    test('Negative numbers addition', () {
      expect(-2 + -3, equals(-5));
      expect(-2 + 3, equals(1));
    });

    test('Zero addition', () {
      expect(0 + 0, equals(0));
      expect(0 + 5, equals(5));
    });

    test('Floating point addition', () {
      expect(2.5 + 3.1, closeTo(5.6, 0.0001));
      expect(-2.5 + 2.5, closeTo(0.0, 0.0001));
    });
  });

  group('String Operations', () {
    test('String concatenation', () {
      expect('Hello ' 'World', equals('Hello World'));
      expect('Dart' 'Lang', equals('DartLang'));
    });

    test('String interpolation', () {
  const name = 'Alice';
  expect('Hello $name', equals('Hello Alice'));
    });

    test('String length', () {
  expect('Hello'.length, equals(5));
      expect(''.length, equals(0));
    });
  });
}