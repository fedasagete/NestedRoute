import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/games/mission_art.dart';
import 'package:nested_nav/games/picnic_sharing_board.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario sharing({int total = 8, int people = 4}) => LearningScenario(
    id: 'picnic-$total-$people',
    kind: GameKind.sharing,
    level: 1,
    values: {'total': total, 'people': people},
    goal: '',
    explanation: '',
    transferPrompt: '',
    transferAnswer: total ~/ people);

Future<void> showBoard(WidgetTester tester, Widget board,
    {double width = 390,
    double height = 844,
    double? contentWidth,
    double textScale = 1,
    bool disableAnimations = false}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor: textScale, disableAnimations: disableAnimations),
          child: child!),
      home: Scaffold(
          body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: contentWidth == null
                      ? board
                      : Align(
                          alignment: Alignment.topCenter,
                          child:
                              SizedBox(width: contentWidth, child: board)))))));
}

Future<void> tap(WidgetTester tester, String key, [int times = 1]) async {
  final control = find.byKey(ValueKey(key));
  expect(control, findsOneWidget);
  for (var i = 0; i < times; i++) {
    await tester.ensureVisible(control);
    await tester.tap(control);
    await tester.pump();
  }
}

int count(WidgetTester tester, String key) =>
    int.parse(tester.widget<Text>(find.byKey(ValueKey(key))).data!);

void expectConserved(WidgetTester tester, int total, int people) {
  var conserved = count(tester, 'supply-count');
  for (var i = 0; i < people; i++) {
    conserved += count(tester, 'share-count-$i');
  }
  expect(conserved, total);
  expect(
      tester
          .widgetList<BananaToken>(find.byType(BananaToken))
          .where((banana) => !banana.ghost)
          .length,
      total);
}

void main() {
  testWidgets('entry teacher brings the receiving fruit into a short viewport',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 20),
            onResult: results.add,
            demonstrateOnStart: true,
            showHint: true,
            onAction: () => actions++),
        width: 320,
        height: 640,
        contentWidth: 264,
        textScale: 1.6);
    await tester.pumpAndSettle();
    final plate = find.byKey(const ValueKey('picnic-plate-0'));
    expect(plate.hitTestable(), findsOneWidget,
        reason:
            'The receiving plate must be on screen before the teacher moves.');
    expect(count(tester, 'share-count-0'), 0);
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'share-count-0'), 1);
    expect(find.byKey(const ValueKey('picnic-fruit-0-0')).hitTestable(),
        findsOneWidget,
        reason: 'The moving banana must be visible, not only the source tray.');
    expectConserved(tester, 20, 4);
    expect(results.contains(true), isFalse);
    expect(actions, 0);
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'share-count-0'), 0);
    expect(count(tester, 'supply-count'), 20);
    expectConserved(tester, 20, 4);
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('first entry briefly demonstrates a real move then restores it',
      (tester) async {
    final results = <bool>[];
    var actions = 0, helped = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 4, people: 2),
            onResult: results.add,
            demonstrateOnStart: true,
            showHint: true,
            onAction: () => actions++,
            onHelpUsed: () => helped++));
    await tester.pump();
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsOneWidget);
    expect(helped, 1);
    expect(actions, 0);
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'share-count-0'), 1);
    expect(count(tester, 'supply-count'), 3);
    expectConserved(tester, 4, 2);
    expect(results.contains(true), isFalse);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsNothing);
    expect(count(tester, 'share-count-0'), 0);
    expect(count(tester, 'supply-count'), 4);
    expect(actions, 0);
    expect(results.last, isFalse);
  });

  testWidgets('optional teacher reveals each receiving plate from below',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 20),
            onResult: results.add,
            showHint: true,
            onAction: () => actions++),
        width: 320,
        height: 640,
        contentWidth: 264,
        textScale: 1.6);
    await tap(tester, 'share-add-3', 2);
    await tap(tester, 'picnic-demo');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('share-count-0')).hitTestable(),
        findsOneWidget,
        reason:
            'Starting from the Watch button must reveal the first receiver.');
    for (var step = 0; step < 30; step++) {
      final remaining = count(tester, 'supply-count');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      if (find
          .byKey(const ValueKey('picnic-demo-running'))
          .evaluate()
          .isEmpty) {
        break;
      }
      final now = count(tester, 'supply-count');
      if (now < remaining) {
        final friend = (20 - now - 1) % 4;
        final fruit = count(tester, 'share-count-$friend') - 1;
        expect(
            find.byKey(ValueKey('picnic-fruit-$friend-$fruit')).hitTestable(),
            findsOneWidget,
            reason: 'Each newly moved banana must be visible.');
      }
      expectConserved(tester, 20, 4);
      expect(results.contains(true), isFalse);
    }
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsNothing);
    expect(count(tester, 'share-count-3'), 2);
    expect(count(tester, 'share-count-0'), 0);
    expect(count(tester, 'supply-count'), 18);
    expectConserved(tester, 20, 4);
    expect(actions, 2);
    expect(results.contains(true), isFalse);
  });

  testWidgets(
      'entry demo ignores hint and language rebuilds but runs for a new id',
      (tester) async {
    final results = <bool>[];
    var helped = 0;
    PicnicSharingBoard board(
            {bool english = false, bool hint = false, int total = 4}) =>
        PicnicSharingBoard(
            scenario: sharing(total: total, people: 2),
            onResult: results.add,
            demonstrateOnStart: true,
            english: english,
            showHint: hint,
            onHelpUsed: () => helped++);
    await showBoard(tester, board());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(helped, 1);
    await showBoard(tester, board(english: true, hint: true));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsNothing);
    expect(helped, 1);
    await showBoard(tester, board(total: 6));
    await tester.pump();
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsOneWidget);
    expect(helped, 2);
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'supply-count'), 5);
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'supply-count'), 6);
    expectConserved(tester, 6, 2);
    expect(results.contains(true), isFalse);
  });

  testWidgets('a pending entry scroll cannot start a demo for the old scenario',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 20),
            onResult: results.add,
            demonstrateOnStart: true,
            showHint: true),
        width: 320,
        height: 640,
        contentWidth: 264,
        textScale: 1.6);
    await tester.pump();
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 4, people: 2), onResult: results.add),
        width: 320,
        height: 640,
        contentWidth: 264,
        textScale: 1.6);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    expect(count(tester, 'supply-count'), 4);
    expect(count(tester, 'share-count-0'), 0);
    expectConserved(tester, 4, 2);
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsNothing);
    expect(results.contains(true), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('starts with tangible fruit and no division formula',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester, PicnicSharingBoard(scenario: sharing(), onResult: results.add));
    expect(find.byKey(const ValueKey('picnic-sharing-board')), findsOneWidget);
    expect(find.text('Walqixa hirii.'), findsOneWidget);
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Text && (widget.data?.contains('÷') ?? false)),
        findsNothing);
    expect(count(tester, 'supply-count'), 8);
    expectConserved(tester, 8, 4);
    expect(results, [false]);
    expect(
        tester
            .widgetList<MissionPerson>(find.byType(MissionPerson))
            .every((person) => !person.happy),
        isTrue);
  });

  testWidgets('unequal complete distribution fails until repaired',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(),
            onResult: results.add,
            onAction: () => actions++));
    for (final entry in {0: 3, 1: 2, 2: 2, 3: 1}.entries) {
      await tap(tester, 'share-add-${entry.key}', entry.value);
      expectConserved(tester, 8, 4);
    }
    expect(count(tester, 'supply-count'), 0);
    expect(results.last, isFalse);
    expect(find.byKey(const ValueKey('picnic-unequal')), findsOneWidget);
    expect(actions, 8);
    await tap(tester, 'share-add-0');
    expect(actions, 8, reason: 'An empty supply is a no-op.');
    await tap(tester, 'share-remove-0');
    await tap(tester, 'share-add-3');
    expectConserved(tester, 8, 4);
    expect(results.last, isTrue);
    expect(actions, 10);
    expect(
        tester
            .widgetList<MissionPerson>(find.byType(MissionPerson))
            .every((person) => person.happy),
        isTrue);
  });

  testWidgets('tap a plate, return its fruit, and reset conserve supply',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 4, people: 2),
            onResult: results.add,
            onAction: () => actions++));
    await tap(tester, 'picnic-plate-0');
    expect(count(tester, 'share-count-0'), 1);
    expect(count(tester, 'supply-count'), 3);
    await tap(tester, 'picnic-fruit-0-0');
    expect(count(tester, 'share-count-0'), 0);
    expect(count(tester, 'supply-count'), 4);
    expect(actions, 2);
    await tap(tester, 'share-remove-0');
    expect(actions, 2);
    await tap(tester, 'share-add-1', 2);
    await tap(tester, 'picnic-reset');
    expect(count(tester, 'supply-count'), 4);
    expectConserved(tester, 4, 2);
    expect(actions, 4, reason: 'Reset is not a mathematical learner move.');
    expect(results.last, isFalse);
  });

  testWidgets('dragging supply to a friend moves exactly one fruit',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 4, people: 2),
            onResult: results.add,
            onAction: () => actions++));
    expect(find.byKey(const ValueKey('picnic-supply-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('picnic-plate-0')), findsOneWidget);
    final start =
        tester.getCenter(find.byKey(const ValueKey('picnic-supply-0')));
    final finish =
        tester.getCenter(find.byKey(const ValueKey('picnic-plate-0')));
    await tester.dragFrom(start, finish - start);
    await tester.pump();
    expect(count(tester, 'share-count-0'), 1);
    expect(count(tester, 'supply-count'), 3);
    expectConserved(tester, 4, 2);
    expect(actions, 1);
    expect(results.last, isFalse);
  });

  testWidgets(
      'demo moves real pieces without mastery then restores the learner',
      (tester) async {
    final results = <bool>[];
    var actions = 0, helped = 0;
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(),
            onResult: results.add,
            onAction: () => actions++,
            onHelpUsed: () => helped++));
    await tap(tester, 'share-add-0', 2);
    final traySize = tester.getSize(find.byType(MissionBasket));
    await tap(tester, 'picnic-demo');
    expect(helped, 1);
    expect(count(tester, 'supply-count'), 8);
    expect(
        tester
            .widget<IconButton>(find.byKey(const ValueKey('share-add-0')))
            .onPressed,
        isNull);
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      expectConserved(tester, 8, 4);
      expect(tester.getSize(find.byType(MissionBasket)), traySize,
          reason: 'Demonstration moves must keep the supply footprint.');
      expect(results.contains(true), isFalse);
      expect(actions, 2);
    }
    expect(count(tester, 'supply-count'), 0);
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('picnic-demo-running')), findsNothing);
    expect(count(tester, 'share-count-0'), 2);
    expect(count(tester, 'share-count-1'), 0);
    expect(count(tester, 'supply-count'), 6);
    expectConserved(tester, 8, 4);
    expect(tester.getSize(find.byType(MissionBasket)), traySize);
    expect(actions, 2);
    expect(results.last, isFalse);
  });

  testWidgets('demo disposal and reduced motion leave no active timer',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester, PicnicSharingBoard(scenario: sharing(), onResult: results.add),
        disableAnimations: true);
    await tap(tester, 'picnic-demo');
    expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer).first)
            .duration,
        Duration.zero);
    await tester.pump(const Duration(milliseconds: 500));
    expect(count(tester, 'supply-count'), 7);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 10));
    expect(tester.takeException(), isNull);
    expect(results.contains(true), isFalse);
  });

  testWidgets('twenty fruits fit 264 pixels with large text and touch targets',
      (tester) async {
    final results = <bool>[];
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 20),
            onResult: results.add,
            showHint: true,
            english: true),
        width: 320,
        contentWidth: 264,
        textScale: 1.6);
    expect(tester.takeException(), isNull);
    for (final key in [
      'picnic-reset',
      'picnic-demo',
      for (var i = 0; i < 4; i++) ...['share-add-$i', 'share-remove-$i']
    ]) {
      expect(find.byKey(ValueKey(key)), findsOneWidget);
      final size = tester.getSize(find.byKey(ValueKey(key)));
      expect(size.width, greaterThanOrEqualTo(48), reason: key);
      expect(size.height, greaterThanOrEqualTo(48), reason: key);
    }
    await tap(tester, 'share-add-0', 20);
    expectConserved(tester, 20, 4);
    expect(results.last, isFalse);
    expect(tester.takeException(), isNull);
    await tap(tester, 'picnic-reset');
    expectConserved(tester, 20, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supply rows stay reserved so untouched targets never move',
      (tester) async {
    await showBoard(
        tester,
        PicnicSharingBoard(
            scenario: sharing(total: 20), onResult: (_) {}, showHint: true),
        width: 320,
        contentWidth: 264,
        textScale: 1.6);
    double contentY(String key) =>
        tester.getTopLeft(find.byKey(ValueKey(key))).dy -
        tester
            .getTopLeft(find.byKey(const ValueKey('picnic-sharing-board')))
            .dy;
    final plateY = contentY('picnic-plate-0');
    final addY = contentY('share-add-0');
    final traySize = tester.getSize(find.byType(MissionBasket));
    await tap(tester, 'share-add-3', 4);
    expect(count(tester, 'share-count-0'), 0);
    expect(contentY('picnic-plate-0'), plateY,
        reason: 'Removing a supply row must not lift the first plate.');
    expect(contentY('share-add-0'), addY);
    expect(tester.getSize(find.byType(MissionBasket)), traySize);
    await tap(tester, 'share-add-3', 16);
    expect(count(tester, 'supply-count'), 0);
    expect(count(tester, 'share-count-0'), 0);
    expect(contentY('picnic-plate-0'), plateY);
    expect(contentY('share-add-0'), addY);
    expect(tester.getSize(find.byType(MissionBasket)), traySize,
        reason: 'An empty supply must retain the complete original tray.');
    expectConserved(tester, 20, 4);
    expect(tester.takeException(), isNull);
  });
}
