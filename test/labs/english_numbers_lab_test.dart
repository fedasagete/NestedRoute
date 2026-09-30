import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/labs/english_numbers_lab.dart';

const words = {1: 'ONE', 2: 'TWO', 3: 'THREE', 4: 'FOUR'};

Future<void> showLab(WidgetTester tester, Widget lab,
    {double width = 390, double textScale = 1, double? contentWidth}) async {
  tester.view.physicalSize = Size(width, 844);
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: contentWidth == null
              ? lab
              : Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(width: contentWidth, child: lab),
                ),
        ),
      ),
    ),
  ));
}

Future<void> tap(WidgetTester tester, String key) async {
  final control = find.byKey(ValueKey(key));
  expect(control, findsOneWidget, reason: 'The lab exposes $key.');
  await tester.ensureVisible(control);
  await tester.tap(control);
  await tester.pumpAndSettle();
}

Future<void> match(WidgetTester tester, int word, int target) async {
  await tap(tester, 'english-numbers-word-$word');
  await tap(tester, 'english-numbers-target-$target');
}

Finder inside(String key, Finder content) =>
    find.descendant(of: find.byKey(ValueKey(key)), matching: content);

void main() {
  testWidgets('studying the four words does not complete recognition',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, EnglishNumbersLab(onResult: results.add));
    for (final entry in words.entries) {
      final card = 'english-numbers-study-${entry.key}';
      expect(inside(card, find.text(entry.value)), findsOneWidget);
      expect(inside(card, find.text('${entry.key}')), findsOneWidget);
      for (var dot = 0; dot < entry.key; dot++) {
        expect(
            find.byKey(ValueKey('english-numbers-study-dot-${entry.key}-$dot')),
            findsOneWidget);
      }
    }
    expect(results, [false]);
    expect(
        find.byKey(const ValueKey('english-numbers-complete')), findsNothing);
    expect(find.byKey(const ValueKey('english-numbers-next')), findsOneWidget);
  });

  testWidgets('matching hides the reference and changes both card orders',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, EnglishNumbersLab(onResult: results.add));
    await tap(tester, 'english-numbers-next');
    expect(find.byKey(const ValueKey('english-numbers-study-1')), findsNothing);
    expect(
        find.byKey(const ValueKey('english-numbers-reference')), findsNothing);
    final wordOrder = [3, 1, 4, 2];
    final targetOrder = [2, 4, 1, 3];
    for (var i = 0; i < 4; i++) {
      final word = wordOrder[i];
      final target = targetOrder[i];
      expect(inside('english-numbers-word-$word', find.byType(Text)),
          findsOneWidget);
      expect(inside('english-numbers-word-$word', find.text(words[word]!)),
          findsOneWidget);
      expect(inside('english-numbers-target-$target', find.text('$target')),
          findsOneWidget);
      if (i > 0) {
        expect(
            tester
                .getTopLeft(find.byKey(
                    ValueKey('english-numbers-word-${wordOrder[i - 1]}')))
                .dy,
            lessThan(tester
                .getTopLeft(find.byKey(ValueKey('english-numbers-word-$word')))
                .dy));
        expect(
            tester
                .getTopLeft(find.byKey(
                    ValueKey('english-numbers-target-${targetOrder[i - 1]}')))
                .dy,
            lessThan(tester
                .getTopLeft(
                    find.byKey(ValueKey('english-numbers-target-$target')))
                .dy));
      }
      expect(word, isNot(target),
          reason: 'Corresponding positions must not supply the answer.');
    }
    expect(results.contains(true), isFalse);
  });

  testWidgets('wrong matching remains visible and can be repaired',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, EnglishNumbersLab(onResult: results.add));
    await tap(tester, 'english-numbers-next');
    await match(tester, 3, 2);
    expect(
        find.byKey(const ValueKey('english-numbers-error-2')), findsOneWidget);
    expect(
        inside('english-numbers-target-2', find.text('THREE')), findsOneWidget);
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('english-numbers-complete')), findsNothing);
    await match(tester, 3, 3);
    expect(find.byKey(const ValueKey('english-numbers-error-2')), findsNothing);
    expect(
        inside('english-numbers-target-2', find.text('THREE')), findsNothing);
    expect(
        inside('english-numbers-target-3', find.text('THREE')), findsOneWidget);
    expect(results.last, isFalse);
    for (final value in [1, 4, 2]) {
      await match(tester, value, value);
    }
    expect(results.last, isTrue);
    expect(
        find.byKey(const ValueKey('english-numbers-complete')), findsOneWidget);
  });

  testWidgets('only all four correct matches complete and reset clears them',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, EnglishNumbersLab(onResult: results.add));
    await tap(tester, 'english-numbers-next');
    for (final value in [4, 2, 1]) {
      await match(tester, value, value);
      expect(results.last, isFalse);
    }
    await match(tester, 3, 3);
    expect(results.last, isTrue);
    await match(tester, 1, 4);
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('english-numbers-error-4')), findsOneWidget);
    await tap(tester, 'english-numbers-reset');
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('english-numbers-study-1')), findsOneWidget);
    await tap(tester, 'english-numbers-next');
    for (final value in words.keys) {
      expect(inside('english-numbers-target-$value', find.byType(Text)),
          findsOneWidget);
    }
    expect(
        find.byKey(const ValueKey('english-numbers-complete')), findsNothing);
  });

  testWidgets('selecting cards and viewing a hint never fills answers',
      (tester) async {
    final results = <bool>[];
    await showLab(
        tester, EnglishNumbersLab(onResult: results.add, showHint: true));
    await tap(tester, 'english-numbers-next');
    expect(find.byKey(const ValueKey('english-numbers-reference')),
        findsOneWidget);
    for (final value in words.keys) {
      await tap(tester, 'english-numbers-word-$value');
    }
    expect(results.contains(true), isFalse);
    for (final value in words.keys) {
      expect(inside('english-numbers-target-$value', find.byType(Text)),
          findsOneWidget);
    }
  });

  testWidgets('controls fit a 240 pixel panel at 1.6 text scale',
      (tester) async {
    final results = <bool>[];
    await showLab(
        tester, EnglishNumbersLab(onResult: results.add, showHint: true),
        width: 320, contentWidth: 240, textScale: 1.6);
    void expectTouchTarget(String key) {
      expect(find.byKey(ValueKey(key)), findsOneWidget);
      final size = tester.getSize(find.byKey(ValueKey(key)));
      expect(size.width, greaterThanOrEqualTo(48), reason: key);
      expect(size.height, greaterThanOrEqualTo(48), reason: key);
    }

    expect(tester.takeException(), isNull);
    expectTouchTarget('english-numbers-next');
    expectTouchTarget('english-numbers-reset');
    await tap(tester, 'english-numbers-next');
    for (final value in words.keys) {
      expectTouchTarget('english-numbers-word-$value');
      expectTouchTarget('english-numbers-target-$value');
      await match(tester, value, value);
      expect(tester.takeException(), isNull);
    }
    expect(results.last, isTrue);
    expect(tester.takeException(), isNull);
    await tap(tester, 'english-numbers-reset');
    expect(results.last, isFalse);
    expect(tester.takeException(), isNull);
  });
}
