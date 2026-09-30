import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/games/angle_builder_board.dart';
import 'package:nested_nav/games/area_grid_board.dart';
import 'package:nested_nav/games/similarity_board.dart';
import 'package:nested_nav/games/volume_board.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario scenario(GameKind kind, Map<String, int> values,
        {String id = 'geometry-one'}) =>
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
  await tester.pumpWidget(MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(16), child: board),
      ),
    ),
  ));
  await tester.pump();
}

Future<void> tapKey(WidgetTester tester, String key, [int times = 1]) async {
  for (var i = 0; i < times; i++) {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pump();
  }
}

void main() {
  testWidgets('area counts unit squares rather than the boundary',
      (tester) async {
    final results = <bool>[];
    final task = scenario(GameKind.areaGrid, {'width': 3, 'height': 2});
    await showBoard(tester,
        AreaGridBoard(scenario: task, onResult: results.add, showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('area-hint')), findsOneWidget);
    expect(find.text('Naannawa · 10'), findsOneWidget);
    await tapKey(tester, 'area-tile-0-0');
    expect(results.last, isFalse);
    for (var row = 0; row < 2; row++) {
      for (var column = 0; column < 3; column++) {
        if (row != 0 || column != 0) {
          await tapKey(tester, 'area-tile-$row-$column');
        }
      }
    }
    expect(results.last, isTrue);
    expect(find.text('Bal’ina · 6'), findsOneWidget);
    await tapKey(tester, 'area-tile-0-0');
    expect(results.last, isFalse);
  });

  testWidgets('area resets selected squares for a different scenario id',
      (tester) async {
    final results = <bool>[];
    final values = {'width': 2, 'height': 2};
    await showBoard(
        tester,
        AreaGridBoard(
            scenario: scenario(GameKind.areaGrid, values),
            onResult: results.add));
    await tapKey(tester, 'area-tile-0-0');
    await showBoard(
        tester,
        AreaGridBoard(
            scenario: scenario(GameKind.areaGrid, values, id: 'geometry-two'),
            onResult: results.add));
    expect(results.last, isFalse);
    expect(find.text('Bal’ina · 0'), findsOneWidget);
  });

  testWidgets('angle completion requires a full 180 degree straight line',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        AngleBuilderBoard(
            scenario: scenario(GameKind.angleBuilder, {'a': 60, 'b': 70}),
            onResult: results.add,
            showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('angle-hint')), findsOneWidget);
    await tapKey(tester, 'angle-plus', 5);
    expect(results.last, isFalse);
    await tapKey(tester, 'angle-plus', 45);
    expect(results.last, isTrue);
    expect(find.text('60° + 70° + 50° = 180°'), findsOneWidget);
    await tapKey(tester, 'angle-plus');
    expect(results.last, isFalse);
  });

  testWidgets('angle resets the movable wedge on scenario change',
      (tester) async {
    final results = <bool>[];
    final values = {'a': 60, 'b': 70};
    await showBoard(
        tester,
        AngleBuilderBoard(
            scenario: scenario(GameKind.angleBuilder, values),
            onResult: results.add));
    await tapKey(tester, 'angle-plus', 50);
    await showBoard(
        tester,
        AngleBuilderBoard(
            scenario:
                scenario(GameKind.angleBuilder, values, id: 'geometry-two'),
            onResult: results.add));
    expect(results.last, isFalse);
    expect(find.text('0°'), findsWidgets);
  });

  testWidgets('showing an angle hint preserves the learner construction',
      (tester) async {
    final results = <bool>[];
    final task = scenario(GameKind.angleBuilder, {'a': 60, 'b': 70});
    await showBoard(
        tester, AngleBuilderBoard(scenario: task, onResult: results.add));
    await tapKey(tester, 'angle-plus', 5);
    await showBoard(
        tester,
        AngleBuilderBoard(
            scenario: task, onResult: results.add, showHint: true));
    expect(find.text('5°'), findsWidgets);
    expect(find.byKey(const ValueKey('angle-hint')), findsOneWidget);
    expect(results.last, isFalse);
  });

  testWidgets('similarity needs the same scale factor on both sides',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        SimilarityBoard(
            scenario: scenario(
                GameKind.similarity, {'width': 2, 'height': 3, 'scale': 2}),
            onResult: results.add,
            showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('similarity-hint')), findsOneWidget);
    await tapKey(tester, 'similarity-width-plus', 3);
    expect(results.last, isFalse);
    await tapKey(tester, 'similarity-height-plus', 5);
    expect(results.last, isTrue);
    await tapKey(tester, 'similarity-height-minus');
    expect(results.last, isFalse);
  });

  testWidgets('similarity resets both independently adjustable sides',
      (tester) async {
    final results = <bool>[];
    final values = {'width': 2, 'height': 3, 'scale': 2};
    await showBoard(
        tester,
        SimilarityBoard(
            scenario: scenario(GameKind.similarity, values),
            onResult: results.add));
    await tapKey(tester, 'similarity-width-plus', 3);
    await tapKey(tester, 'similarity-height-plus', 5);
    await showBoard(
        tester,
        SimilarityBoard(
            scenario: scenario(GameKind.similarity, values, id: 'geometry-two'),
            onResult: results.add));
    expect(results.last, isFalse);
    expect(find.text('1 × 1'), findsOneWidget);
  });

  testWidgets('volume builds a base and repeats it in layers', (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        VolumeBoard(
            scenario: scenario(
                GameKind.volume, {'width': 3, 'depth': 2, 'height': 2}),
            onResult: results.add,
            showHint: true));
    expect(results, [false]);
    expect(find.byKey(const ValueKey('volume-hint')), findsOneWidget);
    await tapKey(tester, 'volume-width-plus', 2);
    await tapKey(tester, 'volume-depth-plus');
    expect(results.last, isFalse);
    await tapKey(tester, 'volume-height-plus', 2);
    expect(results.last, isTrue);
    expect(find.text('3 × 2 × 2 = 12'), findsOneWidget);
    await tapKey(tester, 'volume-width-minus');
    expect(results.last, isFalse);
  });

  testWidgets('volume resets base and layers on scenario change',
      (tester) async {
    final results = <bool>[];
    final values = {'width': 3, 'depth': 2, 'height': 2};
    await showBoard(
        tester,
        VolumeBoard(
            scenario: scenario(GameKind.volume, values),
            onResult: results.add));
    await tapKey(tester, 'volume-width-plus', 2);
    await tapKey(tester, 'volume-depth-plus');
    await tapKey(tester, 'volume-height-plus', 2);
    await showBoard(
        tester,
        VolumeBoard(
            scenario: scenario(GameKind.volume, values, id: 'geometry-two'),
            onResult: results.add));
    expect(results.last, isFalse);
    expect(find.text('1 × 1 × 0 = 0'), findsOneWidget);
  });

  testWidgets('all geometry boards fit a small phone without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boards = <Widget>[
      AreaGridBoard(
          scenario: scenario(GameKind.areaGrid, {'width': 8, 'height': 7}),
          onResult: (_) {}),
      AngleBuilderBoard(
          scenario: scenario(GameKind.angleBuilder, {'a': 35, 'b': 75}),
          onResult: (_) {}),
      SimilarityBoard(
          scenario: scenario(
              GameKind.similarity, {'width': 5, 'height': 4, 'scale': 3}),
          onResult: (_) {}),
      VolumeBoard(
          scenario:
              scenario(GameKind.volume, {'width': 5, 'depth': 4, 'height': 3}),
          onResult: (_) {}),
    ];
    for (final board in boards) {
      await showBoard(tester, board);
      expect(tester.takeException(), isNull, reason: '${board.runtimeType}');
    }
  });

  testWidgets(
      'largest catalogue geometry supports large text and touch targets',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boards = <(Widget, String)>[
      (
        AreaGridBoard(
          scenario: scenario(GameKind.areaGrid, {'width': 10, 'height': 10}),
          onResult: (_) {},
          showHint: true,
        ),
        'area-tile-9-9'
      ),
      (
        AngleBuilderBoard(
          scenario: scenario(GameKind.angleBuilder, {'a': 71, 'b': 66}),
          onResult: (_) {},
          showHint: true,
        ),
        'angle-plus'
      ),
      (
        SimilarityBoard(
          scenario: scenario(
              GameKind.similarity, {'width': 6, 'height': 6, 'scale': 5}),
          onResult: (_) {},
          showHint: true,
        ),
        'similarity-width-plus'
      ),
      (
        VolumeBoard(
          scenario:
              scenario(GameKind.volume, {'width': 5, 'depth': 5, 'height': 4}),
          onResult: (_) {},
          showHint: true,
        ),
        'volume-height-plus'
      ),
    ];
    for (final (board, control) in boards) {
      await showBoard(tester, board, textScale: 1.6);
      expect(tester.takeException(), isNull, reason: '${board.runtimeType}');
      await tapKey(tester, control);
      expect(tester.getSize(find.byKey(ValueKey(control))).shortestSide,
          greaterThanOrEqualTo(48));
      expect(tester.takeException(), isNull, reason: '${board.runtimeType}');
    }
  });
}
