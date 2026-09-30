import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/games/balance_board.dart';
import 'package:nested_nav/games/sets_board.dart';
import 'package:nested_nav/games/data_board.dart';
import 'package:nested_nav/games/probability_board.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario scenario(GameKind kind, Map<String, int> values,
        [String id = 'test']) =>
    LearningScenario(
        id: id,
        kind: kind,
        level: 1,
        values: values,
        goal: '',
        explanation: '',
        transferPrompt: '',
        transferAnswer: 0,
        sourceGrade: 7,
        sourcePage: 1);

Future<void> host(WidgetTester tester, Widget board) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: SingleChildScrollView(child: board))));
}

void main() {
  testWidgets('balance changes all equal bags and recognises equality',
      (tester) async {
    final results = <bool>[];
    await host(
        tester,
        BalanceBoard(
            scenario: scenario(
                GameKind.balance, {'factor': 2, 'offset': 1, 'solution': 3}),
            onResult: results.add));
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('balance-plus')));
      await tester.pumpAndSettle();
    }
    expect(results.last, isTrue);
    await tester.tap(find.byKey(const ValueKey('balance-minus')));
    await tester.pumpAndSettle();
    expect(results.last, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sets require membership, including the overlapping region',
      (tester) async {
    final results = <bool>[];
    await host(
        tester,
        SetsBoard(
            scenario:
                scenario(GameKind.sets, {'aOnly': 1, 'shared': 1, 'bOnly': 1}),
            onResult: results.add));
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(ValueKey('set-token-$i')));
      await tester.pump();
      await tester.tap(
          find.byKey(ValueKey('set-zone-${['aOnly', 'shared', 'bOnly'][i]}')));
      await tester.pumpAndSettle();
    }
    expect(results.last, isTrue);
    // Move a shared token to A-only: count alone cannot award completion.
    await tester.tap(find.byKey(const ValueKey('set-token-1')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('set-zone-aOnly')));
    await tester.pumpAndSettle();
    expect(results.last, isFalse);
  });

  testWidgets('data tiles are conserved while distributing to a common mean',
      (tester) async {
    final results = <bool>[];
    await host(
        tester,
        DataBoard(
            scenario: scenario(
                GameKind.data, {'a': 2, 'b': 0, 'c': 1, 'd': 1, 'e': 1}),
            onResult: results.add));
    await tester.tap(find.byKey(const ValueKey('data-pile-0')));
    await tester.tap(find.byKey(const ValueKey('data-pile-1')));
    await tester.pumpAndSettle();
    expect(results.last, isTrue);
    expect(find.text('5'), findsWidgets);
  });

  testWidgets(
      'probability uses possible outcomes rather than observed frequency',
      (tester) async {
    final results = <bool>[];
    await host(
        tester,
        ProbabilityBoard(
            scenario: scenario(GameKind.probability, {'red': 2, 'blue': 1}),
            onResult: results.add));
    await tester.tap(find.byKey(const ValueKey('probability-draw')));
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(const ValueKey('probability-red-plus')));
    }
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(const ValueKey('probability-total-plus')));
    }
    await tester.pumpAndSettle();
    expect(results.last, isTrue);
    await tester.tap(find.byKey(const ValueKey('probability-total-plus')));
    await tester.pumpAndSettle();
    expect(results.last, isFalse);
  });

  testWidgets('balance resets construction when scenario id changes',
      (tester) async {
    final results = <bool>[];
    final first =
        scenario(GameKind.balance, {'factor': 1, 'offset': 0, 'solution': 1});
    await host(tester, BalanceBoard(scenario: first, onResult: results.add));
    await tester.tap(find.byKey(const ValueKey('balance-plus')));
    await tester.pumpAndSettle();
    expect(results.last, isTrue);
    await host(
        tester,
        BalanceBoard(
            scenario: scenario(GameKind.balance,
                {'factor': 1, 'offset': 0, 'solution': 2}, 'new'),
            onResult: results.add));
    expect(find.text('x = 0'), findsOneWidget);
  });

  testWidgets('mean renders every unit, including piles above twelve',
      (tester) async {
    await host(
        tester,
        DataBoard(
            scenario: scenario(
                GameKind.data, {'a': 11, 'b': 15, 'c': 13, 'd': 9, 'e': 12}),
            onResult: (_) {}));
    expect(find.byKey(const ValueKey('data-unit-1-14')), findsOneWidget);
    expect(find.byKey(const ValueKey('data-unit-2-12')), findsOneWidget);
  });

  testWidgets(
      'reasoning boards fit the actual narrow lesson panel with large text',
      (tester) async {
    final boards = <Widget>[
      BalanceBoard(
          scenario: scenario(
              GameKind.balance, {'factor': 5, 'offset': 3, 'solution': 5}),
          onResult: (_) {},
          showHint: true),
      DataBoard(
          scenario: scenario(
              GameKind.data, {'a': 11, 'b': 15, 'c': 13, 'd': 9, 'e': 12}),
          onResult: (_) {},
          showHint: true),
      SetsBoard(
          scenario:
              scenario(GameKind.sets, {'aOnly': 5, 'shared': 4, 'bOnly': 5}),
          onResult: (_) {},
          showHint: true),
      ProbabilityBoard(
          scenario: scenario(GameKind.probability, {'red': 10, 'blue': 10}),
          onResult: (_) {},
          showHint: true),
    ];
    for (final board in boards) {
      await tester.pumpWidget(MaterialApp(
          home: MediaQuery(
              data: const MediaQueryData(
                  size: Size(320, 844), textScaleFactor: 1.6),
              child: Scaffold(
                  body: SingleChildScrollView(
                      child: Center(
                          child: SizedBox(width: 240, child: board)))))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull,
          reason: '${board.runtimeType} must fit');
    }
  });
}
