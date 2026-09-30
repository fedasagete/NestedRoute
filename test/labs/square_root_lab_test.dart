import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/labs/square_root_lab.dart';

Future<void> showLab(WidgetTester tester, Widget lab,
    {double textScale = 1}) async {
  tester.view.physicalSize = const Size(320, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: child!,
    ),
    home: Scaffold(
        body: SingleChildScrollView(
            child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(width: 240, child: lab),
    ))),
  ));
}

Finder prefix(String value) => find.byWidgetPredicate((widget) {
      final key = widget.key;
      return key is ValueKey<String> && key.value.startsWith(value);
    });

Future<void> tap(WidgetTester tester, String key, [int times = 1]) async {
  final control = find.byKey(ValueKey(key));
  expect(control, findsOneWidget);
  await tester.ensureVisible(control);
  for (var i = 0; i < times; i++) {
    await tester.tap(control);
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets(
      'twenty five tiles in a strip have the right area but are not a square',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add));
    expect(prefix('square-root-unit-'), findsNWidgets(25));
    expect(find.text('1 × 25 = 25'), findsOneWidget);
    expect(find.byKey(const ValueKey('square-root-definition')), findsNothing);
    expect(results, isEmpty);
    await tap(tester, 'square-root-decrease-side');
    expect(results, isEmpty);
    expect(find.text('1 × 25 = 25'), findsOneWidget);
  });

  testWidgets('a four by four candidate leaves nine visible tiles outside',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add));
    await tap(tester, 'square-root-increase-side', 3);
    expect(results.last, isFalse);
    expect(find.text('4 × 4 = 16'), findsOneWidget);
    expect(prefix('square-root-unit-'), findsNWidgets(25));
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('square-root-spare')),
            matching: prefix('square-root-unit-')),
        findsNWidgets(9));
    expect(prefix('square-root-empty-'), findsNothing);
    expect(find.byKey(const ValueKey('square-root-definition')), findsNothing);
  });

  testWidgets(
      'six by six conserves twenty five tiles and exposes eleven empty spaces',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add));
    await tap(tester, 'square-root-increase-side', 5);
    expect(results.last, isFalse);
    expect(find.text('6 × 6 = 36'), findsOneWidget);
    expect(prefix('square-root-unit-'), findsNWidgets(25));
    expect(prefix('square-root-empty-'), findsNWidgets(11));
    expect(find.byKey(const ValueKey('square-root-spare')), findsNothing);
    expect(find.byKey(const ValueKey('square-root-definition')), findsNothing);
    await tap(tester, 'square-root-decrease-side');
    expect(results.last, isTrue);
    expect(prefix('square-root-empty-'), findsNothing);
    expect(find.text('5 × 5 = 5² = 25'), findsOneWidget);
    expect(find.text('√25 = 5 ≥ 0'), findsOneWidget);
    expect(find.text('x² = 25 ⇒ x = ±5'), findsOneWidget);
    expect(find.text('√25 = ±5'), findsNothing);
    expect(find.byKey(const ValueKey('square-root-edge-x-5')), findsOneWidget);
    expect(find.byKey(const ValueKey('square-root-edge-y-5')), findsOneWidget);
    expect(tester.getSize(find.byKey(const ValueKey('square-root-unit-0'))),
        tester.getSize(find.byKey(const ValueKey('square-root-unit-24'))));
  });

  testWidgets('reset returns the square to an uncompleted strip',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add));
    await tap(tester, 'square-root-increase-side', 4);
    expect(results.last, isTrue);
    await tap(tester, 'square-root-reset');
    expect(results.last, isFalse);
    expect(find.text('1 × 25 = 25'), findsOneWidget);
    expect(prefix('square-root-unit-'), findsNWidgets(25));
    expect(find.byKey(const ValueKey('square-root-definition')), findsNothing);
  });

  testWidgets('a hint preserves exploration and does not complete the square',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add));
    await tap(tester, 'square-root-increase-side', 3);
    final before = List<bool>.of(results);
    await showLab(tester, SquareRootLab(onResult: results.add, showHint: true));
    expect(find.byKey(const ValueKey('square-root-hint')), findsOneWidget);
    expect(find.text('4 × 4 = 16'), findsOneWidget);
    expect(results, before);
    expect(find.byKey(const ValueKey('square-root-definition')), findsNothing);
    await tap(tester, 'square-root-increase-side');
    expect(results.last, isTrue);
  });

  testWidgets('every arrangement retains all twenty five real unit tiles',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add));
    for (var side = 1; side <= 7; side++) {
      expect(prefix('square-root-unit-'), findsNWidgets(25));
      final empty = side * side > 25 ? side * side - 25 : 0;
      expect(prefix('square-root-empty-'), findsNWidgets(empty));
      if (side < 7) await tap(tester, 'square-root-increase-side');
    }
    await tap(tester, 'square-root-increase-side');
    expect(prefix('square-root-empty-'), findsNWidgets(24));
    expect(results.last, isFalse);
  });

  testWidgets(
      'square root exploration fits 240 pixels with large text and full touch targets',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SquareRootLab(onResult: results.add, showHint: true),
        textScale: 1.6);
    expect(tester.takeException(), isNull);
    for (final key in [
      'square-root-decrease-side',
      'square-root-increase-side',
      'square-root-reset'
    ]) {
      final size = tester.getSize(find.byKey(ValueKey(key)));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
    await tap(tester, 'square-root-increase-side', 5);
    expect(prefix('square-root-empty-'), findsNWidgets(11));
    expect(tester.takeException(), isNull);
    await tap(tester, 'square-root-decrease-side');
    expect(results.last, isTrue);
    expect(tester.takeException(), isNull);
  });
}
