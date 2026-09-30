import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/games/mission_art.dart';
import 'package:nested_nav/games/packing_mission_board.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario mission(
        {String id = 'packing', int groups = 2, int each = 3}) =>
    LearningScenario(
        id: id,
        kind: GameKind.equalGroups,
        level: 1,
        values: {'groups': groups, 'each': each},
        goal: '',
        explanation: '',
        transferPrompt: '',
        transferAnswer: 0);

Future<void> show(WidgetTester tester, PackingMissionBoard board,
    {double scale = 1,
    bool reducedMotion = false,
    double introHeight = 0}) async {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          appBar: introHeight > 0 ? AppBar() : null,
          body: MediaQuery(
            data: MediaQueryData(
                size: const Size(320, 640),
                textScaleFactor: scale,
                disableAnimations: reducedMotion),
            child: SizedBox(
                height: introHeight > 0 ? 500 : 640,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(children: [
                          if (introHeight > 0) SizedBox(height: introHeight),
                          board,
                        ])))),
          ))));
  await tester.pump();
}

Future<void> tap(WidgetTester tester, String key, [int times = 1]) async {
  final target = find.byKey(ValueKey(key));
  expect(target, findsOneWidget);
  for (var i = 0; i < times; i++) {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    if (key == 'packing-demo') {
      await tester.pump();
      for (var frame = 0;
          frame < 10 &&
              find
                  .byKey(const ValueKey('packing-demo-status'))
                  .evaluate()
                  .isEmpty;
          frame++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
  }
}

int count(WidgetTester tester, String key) =>
    int.parse(tester.widget<Text>(find.byKey(ValueKey(key))).data!);

Future<void> waitForExample(
    WidgetTester tester, int Function() helps, int expected) async {
  for (var frame = 0; frame < 10 && helps() < expected; frame++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pump();
  expect(helps(), expected);
}

void main() {
  testWidgets('preparation blocks duplicate examples and stale fruit callbacks',
      (tester) async {
    var helps = 0;
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(each: 2),
            onResult: (_) {},
            onHelpUsed: () => helps++,
            onAction: () => actions++),
        scale: 1.6,
        introHeight: 700);
    final exampleFinder = find.byKey(const ValueKey('packing-demo'));
    await Scrollable.ensureVisible(tester.element(exampleFinder), alignment: 1);
    await tester.pumpAndSettle();
    final example = tester.widget<OutlinedButton>(exampleFinder).onPressed!;
    final add = tester
        .widget<IconButton>(find.byKey(const ValueKey('group-add-0')))
        .onPressed!;
    final select = tester
        .widget<InkWell>(find.byKey(const ValueKey('packing-loose-0')))
        .onTap!;
    example();
    example();
    add();
    select();
    await tester.pump();
    expect(helps, 0, reason: 'The teacher waits until the basket is visible.');
    expect(actions, 0);
    expect(count(tester, 'groups-total'), 0);
    expect(
        tester
            .widget<IconButton>(find.byKey(const ValueKey('group-add-0')))
            .onPressed,
        isNull);
    expect(
        tester
            .widget<IconButton>(find.byKey(const ValueKey('packing-reset')))
            .onPressed,
        isNull);
    expect(tester.widget<OutlinedButton>(exampleFinder).onPressed, isNull);
    await waitForExample(tester, () => helps, 1);
    await tester.pump(const Duration(milliseconds: 1500));
    expect(helps, 1);
    expect(actions, 0);
    expect(count(tester, 'groups-total'), 0);
    // The stale selection must not survive preparation and demonstration.
    await tap(tester, 'group-count-0');
    expect(count(tester, 'groups-total'), 0);
  });

  testWidgets(
      'manual example reveals receiving fruit and restores the learner basket',
      (tester) async {
    var helps = 0;
    var actions = 0;
    final results = <bool>[];
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(each: 2),
            onResult: results.add,
            onHelpUsed: () => helps++,
            onAction: () => actions++),
        scale: 1.6,
        introHeight: 700);
    await tap(tester, 'group-add-1');
    final example = find.byKey(const ValueKey('packing-demo'));
    await Scrollable.ensureVisible(tester.element(example), alignment: 1);
    await tester.pumpAndSettle();
    await tester.tap(example);
    await tester.pump();
    await waitForExample(tester, () => helps, 1);
    await tester.pump(const Duration(milliseconds: 250));
    final fruit =
        tester.getRect(find.byKey(const ValueKey('packing-fruit-0-0')));
    final counter = tester.getRect(find.byKey(const ValueKey('group-count-0')));
    expect(fruit.top, greaterThanOrEqualTo(56));
    expect(fruit.bottom, lessThanOrEqualTo(556));
    expect(counter.top, greaterThanOrEqualTo(56));
    expect(counter.bottom, lessThanOrEqualTo(556));
    expect(results, everyElement(isFalse));
    expect(actions, 1);
    await tester.pump(const Duration(milliseconds: 1250));
    expect(count(tester, 'group-count-0'), 0);
    expect(count(tester, 'group-count-1'), 1);
    expect(count(tester, 'packing-supply-count'), 3);
    expect(actions, 1);
  });

  testWidgets(
      'automatic teacher move is visible in a constrained large-text shell',
      (tester) async {
    final results = <bool>[];
    var helps = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(each: 2),
            onResult: results.add,
            demonstrateOnStart: true,
            onHelpUsed: () => helps++),
        scale: 1.6,
        introHeight: 700);
    await waitForExample(tester, () => helps, 1);
    await tester.pump(const Duration(milliseconds: 250));
    final fruit =
        tester.getRect(find.byKey(const ValueKey('packing-fruit-0-0')));
    final counter = tester.getRect(find.byKey(const ValueKey('group-count-0')));
    expect(fruit.top, greaterThanOrEqualTo(56));
    expect(fruit.bottom, lessThanOrEqualTo(556));
    expect(counter.top, greaterThanOrEqualTo(56));
    expect(counter.bottom, lessThanOrEqualTo(556));
    expect(helps, 1);
    expect(results, everyElement(isFalse));
    await tester.pump(const Duration(milliseconds: 1250));
    expect(count(tester, 'groups-total'), 0);
  });

  testWidgets(
      'pending entry scroll cannot demonstrate an old scenario or disposed board',
      (tester) async {
    var helps = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(),
            onResult: (_) {},
            demonstrateOnStart: true,
            onHelpUsed: () => helps++),
        scale: 1.6,
        introHeight: 700);
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(id: 'next'),
            onResult: (_) {},
            onHelpUsed: () => helps++),
        scale: 1.6,
        introHeight: 700);
    await tester.pump(const Duration(seconds: 2));
    expect(helps, 0);
    expect(count(tester, 'groups-total'), 0);
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(id: 'third'),
            onResult: (_) {},
            demonstrateOnStart: true,
            onHelpUsed: () => helps++),
        scale: 1.6,
        introHeight: 1400);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    expect(helps, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'first entry teaches once, restores work, and does not repeat on language rebuild',
      (tester) async {
    final results = <bool>[];
    var helps = 0;
    var actions = 0;
    PackingMissionBoard board({bool english = false, String id = 'packing'}) =>
        PackingMissionBoard(
            scenario: mission(id: id, groups: 4, each: 5),
            onResult: results.add,
            demonstrateOnStart: true,
            english: english,
            onHelpUsed: () => helps++,
            onAction: () => actions++);
    await show(tester, board());
    await waitForExample(tester, () => helps, 1);
    expect(helps, 1);
    await tester.pump(const Duration(milliseconds: 250));
    expect(count(tester, 'groups-total'), 1);
    await tester.pump(const Duration(milliseconds: 750));
    expect(count(tester, 'groups-total'), lessThanOrEqualTo(5));
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'groups-total'), 0);
    expect(count(tester, 'packing-supply-count'), 20);
    expect(results, everyElement(isFalse));
    expect(actions, 0);
    await show(tester, board(english: true));
    await tester.pump(const Duration(seconds: 2));
    expect(helps, 1);
    await show(tester, board(id: 'next'));
    await waitForExample(tester, () => helps, 2);
    expect(helps, 2);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the fruit tray keeps basket positions stable as fruit moves',
      (tester) async {
    await show(
        tester, PackingMissionBoard(scenario: mission(), onResult: (_) {}));
    final basket = find.byKey(const ValueKey('group-basket-0'));
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    final before = tester.getTopLeft(basket).dy + scroll.position.pixels;
    await tap(tester, 'group-add-0', 4);
    final after = tester.getTopLeft(basket).dy + scroll.position.pixels;
    expect(after, before);
  });

  testWidgets('visible supply is conserved and no equation precedes action',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(),
            onResult: results.add,
            onAction: () => actions++));
    expect(
        tester
            .widgetList<BananaToken>(find.byType(BananaToken))
            .where((fruit) => !fruit.ghost)
            .length,
        6);
    expect(find.byKey(const ValueKey('packing-equation')), findsNothing);
    expect(count(tester, 'packing-supply-count'), 6);
    await tap(tester, 'group-add-0');
    expect(count(tester, 'group-count-0'), 1);
    expect(count(tester, 'packing-supply-count'), 5);
    expect(count(tester, 'groups-total'), 1);
    expect(actions, 1);
    expect(results.last, isFalse);
    expect(
        tester
            .widgetList<BananaToken>(find.byType(BananaToken))
            .where((fruit) => !fruit.ghost)
            .length,
        6);
  });

  testWidgets(
      'unequal baskets fail even with all fruit packed; undo repairs them',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(),
            onResult: results.add,
            onAction: () => actions++));
    await tap(tester, 'group-add-0', 4);
    await tap(tester, 'group-add-1', 2);
    expect(count(tester, 'packing-supply-count'), 0);
    expect(results.last, isFalse);
    await tap(tester, 'group-add-1');
    expect(actions, 6, reason: 'Adding with an empty supply is a no-op.');
    await tap(tester, 'group-remove-0');
    await tap(tester, 'group-add-1');
    expect(results.last, isTrue);
    expect(
        tester.widget<MissionPerson>(find.byType(MissionPerson)).happy, isTrue);
    expect(find.byKey(const ValueKey('packing-equation')), findsOneWidget);
    await tap(tester, 'group-remove-1');
    expect(results.last, isFalse);
    expect(actions, 9);
  });

  testWidgets(
      'tap supply then ghost slot moves that piece; placed tap removes it',
      (tester) async {
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(), onResult: (_) {}, onAction: () => actions++));
    await tap(tester, 'packing-loose-0');
    expect(actions, 0, reason: 'Selecting a banana is not an object move.');
    await tap(tester, 'packing-slot-1-0');
    expect(count(tester, 'group-count-1'), 1);
    expect(find.byKey(const ValueKey('packing-loose-0')), findsNothing);
    await tap(tester, 'packing-fruit-1-0');
    expect(count(tester, 'group-count-1'), 0);
    expect(find.byKey(const ValueKey('packing-loose-0')), findsOneWidget);
    expect(actions, 2);
  });

  testWidgets(
      'basket header places selected fruit and nested return moves only once',
      (tester) async {
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(), onResult: (_) {}, onAction: () => actions++));
    await tap(tester, 'packing-loose-0');
    await tap(tester, 'group-count-0');
    expect(count(tester, 'group-count-0'), 1);
    expect(count(tester, 'packing-supply-count'), 5);
    expect(find.byKey(const ValueKey('packing-fruit-0-0')), findsOneWidget);
    expect(actions, 1);

    // A selected loose fruit must not be added by the parent when a child
    // placed-fruit target handles this tap as a removal.
    await tap(tester, 'packing-loose-1');
    await tap(tester, 'packing-fruit-0-0');
    expect(count(tester, 'group-count-0'), 0);
    expect(count(tester, 'packing-supply-count'), 6);
    expect(find.byKey(const ValueKey('packing-fruit-0-1')), findsNothing);
    expect(actions, 2);
    expect(
        tester
            .widgetList<BananaToken>(find.byType(BananaToken))
            .where((fruit) => !fruit.ghost)
            .length,
        6);
  });

  testWidgets('holding and dragging a loose banana moves the same piece once',
      (tester) async {
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(), onResult: (_) {}, onAction: () => actions++));
    final source = find.byKey(const ValueKey('packing-loose-0'));
    final destination = find.byKey(const ValueKey('group-basket-0'));
    final gesture = await tester.startGesture(tester.getCenter(source));
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.moveTo(tester.getCenter(destination));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(count(tester, 'group-count-0'), 1);
    expect(count(tester, 'packing-supply-count'), 5);
    expect(find.byKey(const ValueKey('packing-fruit-0-0')), findsOneWidget);
    expect(actions, 1);
  });

  testWidgets(
      'reset and new scenario restore loose supply without counting actions',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(),
            onResult: results.add,
            onAction: () => actions++));
    await tap(tester, 'group-add-0');
    await tap(tester, 'packing-reset');
    expect(count(tester, 'packing-supply-count'), 6);
    expect(results.last, isFalse);
    expect(actions, 1);
    await tap(tester, 'group-add-1');
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(id: 'next', groups: 3, each: 2),
            onResult: results.add,
            onAction: () => actions++));
    expect(count(tester, 'groups-total'), 0);
    expect(count(tester, 'group-count-2'), 0);
    expect(results.last, isFalse);
    expect(actions, 2);
  });

  testWidgets(
      'demo uses visible pieces, suppresses success, restores partial work',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    var helps = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(each: 2),
            onResult: results.add,
            onAction: () => actions++,
            onHelpUsed: () => helps++));
    await tap(tester, 'group-add-1');
    results.clear();
    await tap(tester, 'packing-demo');
    expect(helps, 1);
    expect(count(tester, 'groups-total'), 0);
    await tester.pump(const Duration(milliseconds: 250));
    expect(count(tester, 'groups-total'), 1);
    expect(
        tester
            .widget<IconButton>(find.byKey(const ValueKey('group-add-0')))
            .onPressed,
        isNull);
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    expect(count(tester, 'groups-total'), 4);
    expect(results, everyElement(isFalse));
    expect(actions, 1);
    await tester.pump(const Duration(milliseconds: 700));
    expect(count(tester, 'group-count-0'), 0);
    expect(count(tester, 'group-count-1'), 1);
    expect(count(tester, 'packing-supply-count'), 3);
    expect(results.last, isFalse);
    expect(actions, 1);
  });

  testWidgets('reduced-motion demo restores an already-correct construction',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(groups: 1, each: 1),
            onResult: results.add,
            onAction: () => actions++),
        reducedMotion: true);
    await tap(tester, 'group-add-0');
    results.clear();
    await tap(tester, 'packing-demo');
    expect(count(tester, 'groups-total'), 1);
    expect(results, everyElement(isFalse));
    await tester.pump(const Duration(milliseconds: 1500));
    expect(count(tester, 'group-count-0'), 1);
    expect(results.last, isTrue);
    expect(actions, 1);
  });

  testWidgets('changing scenario and disposing cancel demonstration timers',
      (tester) async {
    final results = <bool>[];
    await show(tester,
        PackingMissionBoard(scenario: mission(), onResult: results.add));
    await tap(tester, 'packing-demo');
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(id: 'next', groups: 1, each: 2),
            onResult: results.add));
    await tester.pump(const Duration(seconds: 10));
    expect(count(tester, 'groups-total'), 0);
    expect(count(tester, 'packing-supply-count'), 2);
    await tap(tester, 'packing-demo');
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 10));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'four five-fruit baskets fit 264px at text scale 1.6 with large controls',
      (tester) async {
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(groups: 4, each: 5),
            onResult: (_) {},
            english: true,
            showHint: true),
        scale: 1.6);
    expect(tester.takeException(), isNull);
    for (var i = 0; i < 4; i++) {
      expect(tester.getSize(find.byKey(ValueKey('group-add-$i'))).shortestSide,
          greaterThanOrEqualTo(48));
      expect(
          tester.getSize(find.byKey(ValueKey('group-remove-$i'))).shortestSide,
          greaterThanOrEqualTo(48));
    }
    await tap(tester, 'group-add-0', 6);
    await tap(tester, 'group-add-3', 5);
    expect(tester.takeException(), isNull);
    await show(
        tester,
        PackingMissionBoard(
            scenario: mission(id: 'oromo', groups: 4, each: 5),
            onResult: (_) {},
            showHint: true),
        scale: 1.6);
    expect(tester.takeException(), isNull);
  });
}
