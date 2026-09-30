import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/labs/fraction_division_lab.dart';
import 'package:nested_nav/labs/ratio_lab.dart';
import 'package:nested_nav/labs/signed_products_lab.dart';

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

Future<void> tap(WidgetTester tester, String key, [int times = 1]) async {
  final control = find.byKey(ValueKey(key));
  expect(control, findsOneWidget, reason: 'The lab exposes $key.');
  await tester.ensureVisible(control);
  for (var i = 0; i < times; i++) {
    await tester.tap(control);
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets(
      'hard arithmetic labs fit the 240 pixel lesson panel with large text',
      (tester) async {
    final results = <bool>[];
    final labs = <Widget>[
      FractionDivisionLab(onResult: results.add, showHint: true),
      SignedProductsLab(onResult: results.add, showHint: true),
      RatioLab(onResult: results.add, showHint: true),
    ];
    final controls = [
      'fraction-division-split',
      'signed-products-add-pair',
      'ratio-add-amber'
    ];
    for (var i = 0; i < labs.length; i++) {
      await showLab(tester, labs[i],
          width: 320, contentWidth: 240, textScale: 1.6);
      expect(tester.takeException(), isNull,
          reason: '${controls[i]} must fit the lesson panel');
      final size = tester.getSize(find.byKey(ValueKey(controls[i])));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
      await tap(tester, controls[i]);
      if (i == 0) {
        for (var slot = 0; slot < 6; slot++) {
          await tap(tester, 'fraction-division-slot-$slot');
        }
        expect(results.last, isTrue);
      } else if (i == 1) {
        await tap(tester, 'signed-products-add-pair', 5);
        await tap(tester, 'signed-products-remove', 3);
        expect(results.last, isTrue);
      }
      expect(tester.takeException(), isNull);
    }
    await tap(tester, 'ratio-add-amber', 3);
    await tap(tester, 'ratio-add-blue', 6);
    expect(results.last, isTrue);
    for (final key in [
      'ratio-add-amber',
      'ratio-remove-amber',
      'ratio-add-blue',
      'ratio-remove-blue'
    ]) {
      final size = tester.getSize(find.byKey(ValueKey(key)));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    }
    expect(tester.takeException(), isNull);
  });
  testWidgets(
      'fraction division splits quarters before counting fitted eighths',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, FractionDivisionLab(onResult: results.add));
    expect(
        find.byKey(const ValueKey('fraction-division-formula')), findsNothing);
    expect(find.byKey(const ValueKey('fraction-division-quarter-3')),
        findsOneWidget);
    expect(
        find.byKey(const ValueKey('fraction-division-slot-0')), findsNothing);
    await tap(tester, 'fraction-division-split');
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('fraction-division-slot-7')), findsOneWidget);
    await tap(tester, 'fraction-division-slot-6');
    for (var i = 0; i < 6; i++) {
      await tap(tester, 'fraction-division-slot-$i');
    }
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('fraction-division-formula')), findsNothing);
    await tap(tester, 'fraction-division-slot-6');
    expect(results.last, isTrue);
    expect(find.byKey(const ValueKey('fraction-division-formula')),
        findsOneWidget);
    expect(find.text('3/4 × 8/1 = 6'), findsOneWidget);
    await tap(tester, 'fraction-division-slot-0');
    expect(results.last, isFalse);
    expect(
        find.byKey(const ValueKey('fraction-division-formula')), findsNothing);
  });

  testWidgets('fraction division reset reconstructs four quarters',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, FractionDivisionLab(onResult: results.add));
    await tap(tester, 'fraction-division-split');
    await tap(tester, 'fraction-division-slot-0');
    await tap(tester, 'fraction-division-reset');
    expect(results.last, isFalse);
    expect(find.byKey(const ValueKey('fraction-division-quarter-3')),
        findsOneWidget);
    expect(
        find.byKey(const ValueKey('fraction-division-slot-0')), findsNothing);
  });

  testWidgets('signed product starts with neutral pairs and removes debt pairs',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, SignedProductsLab(onResult: results.add));
    await tap(tester, 'signed-products-remove');
    expect(results, isEmpty);
    await tap(tester, 'signed-products-add-pair', 6);
    expect(find.text('+1'), findsNWidgets(6));
    expect(find.text('−1'), findsNWidgets(6));
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('signed-products-net')),
            matching: find.text('0')),
        findsOneWidget);
    expect(results.last, isFalse);
    await tap(tester, 'signed-products-remove');
    expect(results.last, isFalse);
    expect(find.text('−1'), findsNWidgets(4));
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('signed-products-net')),
            matching: find.text('+2')),
        findsOneWidget);
    await tap(tester, 'signed-products-remove', 2);
    expect(results.last, isTrue);
    expect(find.text('−1'), findsNothing);
    expect(find.text('+1'), findsNWidgets(6));
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('signed-products-net')),
            matching: find.text('+6')),
        findsOneWidget);
    await tap(tester, 'signed-products-restore');
    expect(results.last, isFalse);
    expect(find.text('−1'), findsNWidgets(2));
    await tap(tester, 'signed-products-remove');
    expect(results.last, isTrue);
    await tap(tester, 'signed-products-reset');
    expect(results.last, isFalse);
    expect(find.text('+1'), findsNothing);
    expect(find.text('−1'), findsNothing);
  });

  testWidgets('ratio rejects an equal mixture and recognises two 2 to 3 groups',
      (tester) async {
    final results = <bool>[];
    await showLab(tester, RatioLab(onResult: results.add));
    await tap(tester, 'ratio-add-amber', 5);
    await tap(tester, 'ratio-add-blue', 5);
    expect(results.last, isFalse);
    expect(find.byKey(const ValueKey('ratio-formula')), findsNothing);
    await tap(tester, 'ratio-remove-amber');
    await tap(tester, 'ratio-add-blue');
    expect(results.last, isTrue);
    expect(find.byKey(const ValueKey('ratio-full-group-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('ratio-full-group-1')), findsOneWidget);
    expect(find.text('2 : 3 = 4 : 6'), findsOneWidget);
    await tap(tester, 'ratio-remove-blue');
    expect(results.last, isFalse);
    expect(find.byKey(const ValueKey('ratio-formula')), findsNothing);
    await tap(tester, 'ratio-reset');
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('ratio-total')),
            matching: find.text('0 / 10')),
        findsOneWidget);
    expect(results.last, isFalse);
  });

  testWidgets('hints do not construct pieces or emit results', (tester) async {
    final results = <bool>[];
    final labs = <Widget>[
      FractionDivisionLab(onResult: results.add, showHint: true),
      SignedProductsLab(onResult: results.add, showHint: true),
      RatioLab(onResult: results.add, showHint: true),
    ];
    final keys = [
      'fraction-division-hint',
      'signed-products-hint',
      'ratio-hint'
    ];
    for (var i = 0; i < labs.length; i++) {
      await showLab(tester, labs[i]);
      expect(find.byKey(ValueKey(keys[i])), findsOneWidget);
      expect(results, isEmpty);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
      'all hard arithmetic labs remain usable on a narrow large-text phone',
      (tester) async {
    final results = <bool>[];
    await showLab(
        tester, FractionDivisionLab(onResult: results.add, showHint: true),
        width: 320, textScale: 1.8);
    await tap(tester, 'fraction-division-split');
    await tap(tester, 'fraction-division-slot-5');
    expect(tester.takeException(), isNull);
    await showLab(
        tester, SignedProductsLab(onResult: results.add, showHint: true),
        width: 320, textScale: 1.8);
    await tap(tester, 'signed-products-add-pair', 6);
    await tap(tester, 'signed-products-remove', 3);
    expect(results.last, isTrue);
    expect(tester.takeException(), isNull);
    await showLab(tester, RatioLab(onResult: results.add, showHint: true),
        width: 320, textScale: 1.8);
    await tap(tester, 'ratio-add-amber', 4);
    await tap(tester, 'ratio-add-blue', 6);
    expect(results.last, isTrue);
    expect(tester.takeException(), isNull);
  });
}
