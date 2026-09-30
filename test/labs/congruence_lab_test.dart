import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/labs/congruence_lab.dart';

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
  test(
      'rigid motions preserve actual triangle side lengths and vertex identity',
      () {
    const target = CongruenceTriangle();
    const moved =
        CongruenceTriangle(rotationDegrees: 137, translation: Offset(-.8, .6));
    expect(target.sideLengths, orderedEquals([3, 4, 5]));
    for (var i = 0; i < 3; i++) {
      expect(moved.sideLengths[i], closeTo(target.sideLengths[i], 1e-9));
      expect(moved.angleDegrees[i], closeTo(target.angleDegrees[i], 1e-9));
    }
    expect(moved.matches(target), isFalse);
    expect(
        const CongruenceTriangle(rotationDegrees: 360).matches(target), isTrue);
  });

  test('enlarged triangle has the same angles but cannot overlay the target',
      () {
    const target = CongruenceTriangle();
    const enlarged = CongruenceTriangle(scale: 1.5);
    expect(enlarged.sideLengths, orderedEquals([4.5, 6, 7.5]));
    for (var i = 0; i < 3; i++) {
      expect(enlarged.angleDegrees[i], closeTo(target.angleDegrees[i], 1e-9));
    }
    expect(enlarged.matches(target), isFalse);
  });

  testWidgets(
      'overlay needs translation and rotation before showing correspondence',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, CongruenceLab(onResult: results.add));
    expect(results, [false]);
    expect(
        find.byKey(const ValueKey('congruence-correspondence')), findsNothing);
    await tapKey(tester, 'congruence-right', 2);
    await tapKey(tester, 'congruence-up', 2);
    expect(results.last, isFalse);
    await tapKey(tester, 'congruence-rotate-left');
    expect(results.last, isFalse);
    await tapKey(tester, 'congruence-rotate-left');
    expect(results.last, isTrue);
    expect(find.byKey(const ValueKey('congruence-correspondence')),
        findsOneWidget);
    expect(find.text('RRR · SSS'), findsOneWidget);
    await tapKey(tester, 'congruence-left');
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('congruence-correspondence')), findsNothing);
    await tapKey(tester, 'congruence-reset');
    expect(results.last, isFalse);
    expect(find.text('90°'), findsOneWidget);
  });

  testWidgets('same-angle distractor is rejected at the matched position',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, CongruenceLab(onResult: results.add));
    await tapKey(tester, 'congruence-scale-large');
    expect(find.text('4.5 · 6 · 7.5'), findsOneWidget);
    await tapKey(tester, 'congruence-right', 2);
    await tapKey(tester, 'congruence-up', 2);
    await tapKey(tester, 'congruence-rotate-left', 2);
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('congruence-correspondence')), findsNothing);
    await tapKey(tester, 'congruence-scale-original');
    expect(results.last, isTrue);
    await tapKey(tester, 'congruence-scale-large');
    expect(results.last, isFalse);
    await tapKey(tester, 'congruence-reset');
    expect(results.last, isFalse);
    expect(find.text('3 · 4 · 5'), findsNWidgets(2));
  });

  testWidgets('dragging the triangle moves its pose without changing its sides',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, CongruenceLab(onResult: results.add));
    await tapKey(tester, 'congruence-rotate-left', 2);
    final board = find.byKey(const ValueKey('congruence-canvas'));
    await tester.ensureVisible(board);
    await tester.drag(board, const Offset(22, -22));
    await tester.pump();
    expect(results.last, isTrue);
    expect(find.text('3 · 4 · 5'), findsNWidgets(2));
  });

  testWidgets('hint highlights motion without solving or resetting the pose',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, CongruenceLab(onResult: results.add));
    await tapKey(tester, 'congruence-rotate-left');
    await showLab(tester, CongruenceLab(onResult: results.add, showHint: true));
    expect(find.text('45°'), findsOneWidget);
    expect(find.byKey(const ValueKey('congruence-hint')), findsOneWidget);
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('congruence-correspondence')), findsNothing);
  });

  testWidgets('all controls fit a 240px board with large text and 48px targets',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await showLab(tester, CongruenceLab(onResult: (_) {}, showHint: true),
        textScale: 1.6, padding: 40);
    expect(tester.takeException(), isNull);
    for (final key in [
      'congruence-left',
      'congruence-right',
      'congruence-up',
      'congruence-down',
      'congruence-rotate-left',
      'congruence-rotate-right',
      'congruence-scale-original',
      'congruence-scale-large',
      'congruence-reset',
    ]) {
      await tapKey(tester, key);
      expect(tester.getSize(find.byKey(ValueKey(key))).shortestSide,
          greaterThanOrEqualTo(48),
          reason: key);
      expect(tester.takeException(), isNull, reason: key);
    }
  });
}
