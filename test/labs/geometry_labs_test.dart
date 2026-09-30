import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/labs/circle_angles_lab.dart';
import 'package:nested_nav/labs/inequality_lab.dart';
import 'package:nested_nav/labs/pythagoras_lab.dart';

Future<void> showLab(WidgetTester tester, Widget lab,
    {double textScale = 1, double padding = 16}) async {
  await tester.pumpWidget(MaterialApp(
    builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
        child: child!),
    home: Scaffold(
        body: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(padding), child: lab))),
  ));
  await tester.pump();
}

Future<void> tapKey(WidgetTester tester, String key, [int times = 1]) async {
  for (var i = 0; i < times; i++) {
    final control = find.byKey(ValueKey(key));
    await tester.ensureVisible(control);
    await tester.tap(control);
    await tester.pump();
  }
}

void main() {
  testWidgets('Pythagoras conserves the two square areas while moving rows',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, PythagorasLab(onResult: results.add, showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('pythagoras-hint')), findsOneWidget);
    expect(find.text('0 + 0 = 0'), findsOneWidget);
    for (var row = 0; row < 3; row++) {
      await tapKey(tester, 'pythagoras-row-3-$row');
    }
    expect(results.last, isFalse);
    expect(find.text('9 + 0 = 9'), findsOneWidget);
    for (var row = 0; row < 4; row++) {
      await tapKey(tester, 'pythagoras-row-4-$row');
    }
    expect(results.last, isTrue);
    expect(find.text('9 + 16 = 25'), findsOneWidget);
    await tapKey(tester, 'pythagoras-row-3-0');
    expect(results.last, isFalse);
    expect(find.text('6 + 16 = 22'), findsOneWidget);
    await tapKey(tester, 'pythagoras-reset');
    expect(results.last, isFalse);
    expect(find.text('0 + 0 = 0'), findsOneWidget);
  });

  testWidgets('circle measurement requires observing a moved point',
      (tester) async {
    final results = <bool>[];
    await showLab(
        tester, CircleAnglesLab(onResult: results.add, showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('circle-hint')), findsOneWidget);
    await tapKey(tester, 'circle-measure-plus', 50);
    expect(results.last, isFalse);
    await tapKey(tester, 'circle-point-left');
    expect(results.last, isTrue);
    await tapKey(tester, 'circle-point-right', 2);
    expect(results.last, isTrue);
    await tapKey(tester, 'circle-measure-plus');
    expect(results.last, isFalse);
    await tapKey(tester, 'circle-reset');
    expect(results.last, isFalse);
  });

  test('circle diagram preserves 50 degrees over the allowed major arc', () {
    for (final point in [20.0, 40.0, 70.0, 90.0, 120.0, 140.0, 160.0]) {
      final geometry = CircleAngleGeometry(point);
      expect(geometry.centralDegrees, closeTo(100, 1e-8));
      expect(geometry.inscribedDegrees, closeTo(50, 1e-8));
    }
  });

  testWidgets('negative inequality needs reversal, open boundary and samples',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, InequalityLab(onResult: results.add, showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('inequality-hint')), findsOneWidget);
    await tapKey(tester, 'inequality-sample-zero');
    expect(find.text('0 < 6  ✓'), findsNothing);
    expect(results, [false]);
    await tapKey(tester, 'inequality-reflect');
    await tapKey(tester, 'inequality-boundary-minus', 3);
    expect(find.text('6 ÷ (-2) = -3'), findsOneWidget);
    await tapKey(tester, 'inequality-left');
    await tapKey(tester, 'inequality-open');
    await tapKey(tester, 'inequality-sample-zero');
    await tapKey(tester, 'inequality-sample-minus-four');
    expect(results.last, isFalse);
    expect(find.text('0 < 6  ✓'), findsOneWidget);
    expect(find.text('8 < 6  ✗'), findsOneWidget);
    await tapKey(tester, 'inequality-right');
    expect(results.last, isFalse);
    await tapKey(tester, 'inequality-sample-zero');
    await tapKey(tester, 'inequality-sample-minus-four');
    expect(results.last, isTrue);
    await tapKey(tester, 'inequality-closed');
    expect(results.last, isFalse);
    await tapKey(tester, 'inequality-reset');
    expect(results.last, isFalse);
  });

  testWidgets('hints support lab actions without completing construction',
      (tester) async {
    final results = <bool>[];
    final labs = [
      PythagorasLab(onResult: results.add, showHint: true),
      CircleAnglesLab(onResult: results.add, showHint: true),
      InequalityLab(onResult: results.add, showHint: true),
    ];
    for (final lab in labs) {
      await showLab(tester, lab);
      expect(results.last, isFalse);
    }
  });

  testWidgets('hard geometry labs fit small phones with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final labs = <(Widget, String)>[
      (PythagorasLab(onResult: (_) {}, showHint: true), 'pythagoras-row-4-3'),
      (CircleAnglesLab(onResult: (_) {}, showHint: true), 'circle-point-left'),
      (InequalityLab(onResult: (_) {}, showHint: true), 'inequality-reflect'),
    ];
    for (final (lab, key) in labs) {
      await showLab(tester, lab, textScale: 1.6, padding: 40);
      expect(tester.takeException(), isNull, reason: '${lab.runtimeType}');
      await tapKey(tester, key);
      expect(tester.getSize(find.byKey(ValueKey(key))).shortestSide,
          greaterThanOrEqualTo(48));
      expect(tester.takeException(), isNull, reason: '${lab.runtimeType}');
    }
  });
}
