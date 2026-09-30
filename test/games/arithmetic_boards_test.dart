import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/games/equal_groups_board.dart';
import 'package:nested_nav/games/fraction_tiles_board.dart';
import 'package:nested_nav/games/number_line_board.dart';
import 'package:nested_nav/games/sharing_board.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario scenario(
  GameKind kind,
  Map<String, int> values, {
  String id = 'board-test',
}) =>
    LearningScenario(
      id: id,
      kind: kind,
      level: 1,
      values: values,
      goal: '',
      explanation: '',
      transferPrompt: '',
      transferAnswer: 0,
    );

Future<void> showBoard(WidgetTester tester, Widget board,
    {double textScale = 1}) async {
  tester.view.physicalSize = const Size(390, 844);
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
        child: Padding(padding: const EdgeInsets.all(20), child: board),
      ),
    ),
  ));
}

Future<void> tap(WidgetTester tester, String key, [int times = 1]) async {
  final control = find.byKey(ValueKey(key));
  expect(control, findsOneWidget, reason: 'The board exposes $key.');
  await tester.ensureVisible(control);
  for (var i = 0; i < times; i++) {
    await tester.tap(control);
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets('number line allows wrong move, correction, and overshoot',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        NumberLineBoard(
          scenario: scenario(GameKind.numberLine, {'start': 3, 'delta': 2}),
          onResult: results.add,
        ));
    await tap(tester, 'line-left');
    expect(results.last, isFalse);
    expect(find.text('2'), findsWidgets);
    await tap(tester, 'line-right', 3);
    expect(results.last, isTrue);
    expect(find.byKey(const ValueKey('line-current')), findsOneWidget);
    await tap(tester, 'line-right');
    expect(results.last, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('number line models subtraction and resets to the new start',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        NumberLineBoard(
          scenario: scenario(GameKind.numberLine, {'start': 8, 'delta': -3}),
          onResult: results.add,
        ));
    await tap(tester, 'line-left', 3);
    expect(results.last, isTrue);
    await showBoard(
        tester,
        NumberLineBoard(
          scenario: scenario(GameKind.numberLine, {'start': 2, 'delta': 1},
              id: 'next'),
          onResult: results.add,
        ));
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('line-current')),
            matching: find.text('2')),
        findsOneWidget);
    await tap(tester, 'line-right');
    expect(results.last, isTrue);
  });

  testWidgets('equal groups accepts only the requested amount in every basket',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        EqualGroupsBoard(
          scenario: scenario(GameKind.equalGroups, {'groups': 2, 'each': 3}),
          onResult: results.add,
        ));
    await tap(tester, 'group-add-0', 4);
    await tap(tester, 'group-add-1', 3);
    expect(results.last, isFalse);
    await tap(tester, 'group-remove-0');
    expect(results.last, isTrue);
    await tap(tester, 'group-remove-1');
    expect(results.last, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('equal groups resets constructed baskets on a new scenario',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        EqualGroupsBoard(
          scenario: scenario(GameKind.equalGroups, {'groups': 2, 'each': 2}),
          onResult: results.add,
        ));
    await tap(tester, 'group-add-0', 2);
    await tap(tester, 'group-add-1', 2);
    await showBoard(
        tester,
        EqualGroupsBoard(
          scenario: scenario(GameKind.equalGroups, {'groups': 2, 'each': 1},
              id: 'next'),
          onResult: results.add,
        ));
    await tap(tester, 'group-add-0');
    expect(results.last, isFalse);
    await tap(tester, 'group-add-1');
    expect(results.last, isTrue);
  });

  testWidgets(
      'sharing conserves the supply and permits correcting unfair shares',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        SharingBoard(
          scenario: scenario(GameKind.sharing, {'total': 6, 'people': 2}),
          onResult: results.add,
        ));
    await tap(tester, 'sharing-add-0', 6);
    expect(results.last, isFalse);
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('sharing-supply-count')),
            matching: find.text('0')),
        findsOneWidget);
    await tap(tester, 'sharing-add-1');
    expect(results.last, isFalse);
    await tap(tester, 'sharing-remove-0', 3);
    await tap(tester, 'sharing-add-1', 3);
    expect(results.last, isTrue);
    await tap(tester, 'sharing-remove-1');
    expect(results.last, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sharing restores the entire supply when the scenario changes',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        SharingBoard(
          scenario: scenario(GameKind.sharing, {'total': 6, 'people': 2}),
          onResult: results.add,
        ));
    await tap(tester, 'sharing-add-0', 3);
    await showBoard(
        tester,
        SharingBoard(
          scenario:
              scenario(GameKind.sharing, {'total': 4, 'people': 2}, id: 'next'),
          onResult: results.add,
        ));
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('sharing-supply-count')),
            matching: find.text('4')),
        findsOneWidget);
    await tap(tester, 'sharing-add-0', 2);
    await tap(tester, 'sharing-add-1', 2);
    expect(results.last, isTrue);
  });

  testWidgets('fraction tiles are equal parts and accept any correct subset',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        FractionTilesBoard(
          scenario:
              scenario(GameKind.fractionTiles, {'parts': 4, 'selected': 2}),
          onResult: results.add,
        ));
    await tap(tester, 'fraction-tile-1');
    expect(results.last, isFalse);
    await tap(tester, 'fraction-tile-3');
    expect(results.last, isTrue);
    await tap(tester, 'fraction-tile-0');
    expect(results.last, isFalse);
    await tap(tester, 'fraction-tile-1');
    expect(results.last, isTrue);
    expect(tester.getSize(find.byKey(const ValueKey('fraction-tile-0'))),
        tester.getSize(find.byKey(const ValueKey('fraction-tile-3'))));
    expect(tester.takeException(), isNull);
  });

  testWidgets('fraction tiles reset shading when a new scenario arrives',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        FractionTilesBoard(
          scenario:
              scenario(GameKind.fractionTiles, {'parts': 4, 'selected': 2}),
          onResult: results.add,
        ));
    await tap(tester, 'fraction-tile-0');
    await tap(tester, 'fraction-tile-1');
    await showBoard(
        tester,
        FractionTilesBoard(
          scenario: scenario(
              GameKind.fractionTiles, {'parts': 3, 'selected': 1},
              id: 'next'),
          onResult: results.add,
        ));
    await tap(tester, 'fraction-tile-2');
    expect(results.last, isTrue);
    expect(find.byKey(const ValueKey('fraction-tile-3')), findsNothing);
  });

  testWidgets('visual hints leave the construction and result untouched',
      (tester) async {
    final results = <bool>[];
    final boards = <Widget>[
      NumberLineBoard(
          scenario: scenario(GameKind.numberLine, {'start': 3, 'delta': 2}),
          onResult: results.add,
          showHint: true),
      EqualGroupsBoard(
          scenario: scenario(GameKind.equalGroups, {'groups': 2, 'each': 3}),
          onResult: results.add,
          showHint: true),
      SharingBoard(
          scenario: scenario(GameKind.sharing, {'total': 6, 'people': 2}),
          onResult: results.add,
          showHint: true),
      FractionTilesBoard(
          scenario:
              scenario(GameKind.fractionTiles, {'parts': 4, 'selected': 2}),
          onResult: results.add,
          showHint: true),
    ];
    final hints = ['line-hint', 'groups-hint', 'sharing-hint', 'fraction-hint'];
    for (var i = 0; i < boards.length; i++) {
      await showBoard(tester, boards[i]);
      expect(find.byKey(ValueKey(hints[i])), findsOneWidget);
      expect(results, isEmpty);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('showing a hint preserves a partly constructed number line',
      (tester) async {
    final results = <bool>[];
    final item = scenario(GameKind.numberLine, {'start': 3, 'delta': 2});
    await showBoard(
        tester, NumberLineBoard(scenario: item, onResult: results.add));
    await tap(tester, 'line-right');
    await showBoard(tester,
        NumberLineBoard(scenario: item, onResult: results.add, showHint: true));
    expect(results, [false]);
    await tap(tester, 'line-right');
    expect(results.last, isTrue);
  });

  testWidgets('all arithmetic controls remain usable with large phone text',
      (tester) async {
    final results = <bool>[];
    final boards = <Widget>[
      NumberLineBoard(
          scenario: scenario(GameKind.numberLine, {'start': -6, 'delta': -6}),
          onResult: results.add,
          showHint: true),
      EqualGroupsBoard(
          scenario: scenario(GameKind.equalGroups, {'groups': 10, 'each': 10}),
          onResult: results.add,
          showHint: true),
      SharingBoard(
          scenario: scenario(GameKind.sharing, {'total': 100, 'people': 10}),
          onResult: results.add,
          showHint: true),
      FractionTilesBoard(
          scenario:
              scenario(GameKind.fractionTiles, {'parts': 15, 'selected': 14}),
          onResult: results.add,
          showHint: true),
    ];
    final controls = [
      'line-left',
      'group-add-9',
      'sharing-add-9',
      'fraction-tile-14'
    ];
    for (var i = 0; i < boards.length; i++) {
      await showBoard(tester, boards[i], textScale: 1.6);
      await tap(tester, controls[i]);
      expect(results.last, isFalse);
      expect(tester.takeException(), isNull);
    }
  });
}
