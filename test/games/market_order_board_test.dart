import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/games/market_order_board.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario order({String id = 'order', int start = 3, int delta = 2}) =>
    LearningScenario(
      id: id,
      kind: GameKind.numberLine,
      level: 1,
      values: {'start': start, 'delta': delta},
      goal: '',
      explanation: '',
      transferPrompt: '',
      transferAnswer: 0,
    );

Future<void> showOrder(WidgetTester tester, Widget board,
    {double width = 350,
    double textScale = 1,
    bool reducedMotion = false,
    Size viewport = const Size(390, 844),
    double topSpace = 0,
    double bottomSpace = 0}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScale,
        disableAnimations: reducedMotion,
      ),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: topSpace),
          Center(child: SizedBox(width: width, child: board)),
          SizedBox(height: bottomSpace),
        ]),
      ),
    ),
  ));
}

Finder keyed(String key) => find.byKey(ValueKey(key));
Finder fruit(String place) => find.byWidgetPredicate((widget) {
      final key = widget.key;
      return key is ValueKey<String> &&
          key.value.startsWith('market-$place-fruit-');
    });

void conserved(int total, int cart, int pile) {
  expect(fruit('cart'), findsNWidgets(cart));
  expect(fruit('pile'), findsNWidgets(pile));
  expect(cart + pile, total);
}

Future<void> tap(WidgetTester tester, String key) async {
  await tester.ensureVisible(keyed(key));
  await tester.tap(keyed(key));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('manual Watch scrolls back up before moving and restores work',
      (tester) async {
    var helps = 0;
    var actions = 0;
    var receiverWasVisible = false;
    final results = <bool>[];
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          onResult: results.add,
          onAction: () => actions++,
          onHelpUsed: () {
            helps++;
            final target = tester.getRect(keyed('market-cart-slot-4'));
            receiverWasVisible = target.top >= 0 && target.bottom <= 640;
          },
        ),
        width: 264,
        textScale: 1.6,
        viewport: const Size(320, 640),
        topSpace: 400,
        bottomSpace: 600);
    await tap(tester, 'line-right');
    conserved(5, 4, 1);
    await tester.ensureVisible(keyed('market-demo'));
    await tester.pumpAndSettle();
    expect(tester.getRect(keyed('market-cart-drop')).bottom, lessThan(0));
    await tester.tap(keyed('market-demo'));
    await tester.pump(const Duration(milliseconds: 100));
    conserved(5, 4, 1);
    await tester.pumpAndSettle();
    expect(helps, 1);
    expect(receiverWasVisible, isTrue);
    conserved(5, 5, 0);
    expect(keyed('market-delivered'), findsNothing);
    expect(actions, 1);
    expect(results, everyElement(isFalse));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    conserved(5, 4, 1);
    expect(actions, 1);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('small viewport reveals the receiving basket before teaching',
      (tester) async {
    var helps = 0;
    var receiverWasVisible = false;
    final results = <bool>[];
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          demonstrateOnStart: true,
          onResult: results.add,
          onHelpUsed: () {
            helps++;
            final target = tester.getRect(keyed('market-cart-slot-3'));
            receiverWasVisible = target.top >= 0 && target.bottom <= 640;
          },
        ),
        width: 264,
        textScale: 1.6,
        viewport: const Size(320, 640),
        topSpace: 500);
    await tester.pump(const Duration(milliseconds: 100));
    conserved(5, 3, 2);
    expect(helps, 0, reason: 'The teacher waits for the basket to scroll in.');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(helps, 1);
    expect(receiverWasVisible, isTrue);
    conserved(5, 4, 1);
    final shownFruit = tester.getRect(keyed('market-cart-fruit-3'));
    expect(shownFruit.top, greaterThanOrEqualTo(0));
    expect(shownFruit.bottom, lessThanOrEqualTo(640));
    expect(results, everyElement(isFalse));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    conserved(5, 3, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a reset during the visibility scroll cancels the old teacher',
      (tester) async {
    var helps = 0;
    final results = <bool>[];
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          demonstrateOnStart: true,
          onHelpUsed: () => helps++,
          onResult: results.add,
        ),
        width: 264,
        textScale: 1.6,
        viewport: const Size(320, 640),
        topSpace: 500);
    await tester.pump(const Duration(milliseconds: 100));
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(id: 'new-before-demo', start: 1, delta: 2),
          onHelpUsed: () => helps++,
          onResult: results.add,
        ),
        width: 264,
        textScale: 1.6,
        viewport: const Size(320, 640),
        topSpace: 500);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    conserved(3, 1, 2);
    expect(helps, 0);
    expect(results, [false]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('264px supply vacancies keep add and undo stationary throughout',
      (tester) async {
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(start: 6, delta: 6),
          onResult: (_) {},
        ),
        width: 264,
        textScale: 1.6);
    double localY(String key) =>
        tester.getTopLeft(keyed(key)).dy -
        tester.getTopLeft(keyed('market-order-board')).dy;
    final addY = localY('line-right');
    final undoY = localY('line-left');
    final basketY = localY('market-cart-drop');
    final addElement = tester.element(keyed('line-right'));
    final undoElement = tester.element(keyed('line-left'));

    for (var moved = 1; moved <= 6; moved++) {
      await tap(tester, 'line-right');
      conserved(12, 6 + moved, 6 - moved);
      expect(localY('market-cart-drop'), closeTo(basketY, .1));
      expect(localY('line-right'), closeTo(addY, .1),
          reason: 'The add target stays still after $moved moves.');
      expect(localY('line-left'), closeTo(undoY, .1));
      expect(tester.element(keyed('line-right')), same(addElement));
      expect(tester.element(keyed('line-left')), same(undoElement));
    }
    expect(keyed('market-delivered'), findsOneWidget);
    await tap(tester, 'line-left');
    conserved(12, 11, 1);
    expect(localY('line-right'), closeTo(addY, .1));
    expect(localY('line-left'), closeTo(undoY, .1));
    expect(tester.element(keyed('line-right')), same(addElement));
    expect(tester.takeException(), isNull);
  });

  testWidgets('new mission clears shell correctness before learner or demo',
      (tester) async {
    for (final intro in [false, true]) {
      var mission = order(id: 'completed-$intro', start: 0, delta: 1);
      var shellCorrect = false;
      final results = <bool>[];
      late StateSetter updateShell;
      await showOrder(
          tester,
          StatefulBuilder(
            key: ValueKey('shell-$intro'),
            builder: (context, setState) {
              updateShell = setState;
              return MarketOrderBoard(
                scenario: mission,
                demonstrateOnStart: intro && mission.id == 'next-$intro',
                onResult: (result) => setState(() {
                  results.add(result);
                  shellCorrect = result;
                }),
              );
            },
          ));
      await tap(tester, 'line-right');
      expect(shellCorrect, isTrue);
      updateShell(() => mission = order(id: 'next-$intro', start: 1, delta: 2));
      await tester.pump();
      expect(shellCorrect, isFalse);
      expect(results.last, isFalse);
      await tester.pump(const Duration(milliseconds: 100));
      if (intro) {
        conserved(3, 2, 1);
        expect(
            tester.widget<FilledButton>(keyed('line-right')).onPressed, isNull);
      } else {
        conserved(3, 1, 2);
      }
      expect(keyed('market-delivered'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      conserved(3, 1, 2);
      expect(shellCorrect, isFalse);
    }
  });

  testWidgets('first mission demonstrates before asking and never repeats',
      (tester) async {
    final results = <bool>[];
    var helps = 0;
    var actions = 0;
    MarketOrderBoard board({bool english = false, bool hint = false}) =>
        MarketOrderBoard(
          scenario: order(start: 0, delta: 1),
          onResult: results.add,
          onAction: () => actions++,
          onHelpUsed: () => helps++,
          demonstrateOnStart: true,
          english: english,
          showHint: hint,
        );

    await showOrder(tester, board());
    await tester.pump(const Duration(milliseconds: 100));
    conserved(1, 1, 0);
    expect(helps, 1);
    expect(actions, 0);
    expect(results, isNot(contains(true)));
    expect(keyed('market-delivered'), findsNothing);
    expect(tester.widget<FilledButton>(keyed('line-right')).onPressed, isNull);
    expect(tester.widget<OutlinedButton>(keyed('line-left')).onPressed, isNull);
    expect(tester.widget<TextButton>(keyed('market-demo')).onPressed, isNull);

    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();
    conserved(1, 0, 1);
    expect(results, [false, false]);
    await showOrder(tester, board(english: true, hint: true));
    await tester.pump(const Duration(seconds: 2));
    expect(helps, 1);
    conserved(1, 0, 1);
    await tap(tester, 'line-right');
    expect(results.last, isTrue);
    expect(actions, 1);
  });

  testWidgets('new mission id restarts the intro and cancels the old demo',
      (tester) async {
    final results = <bool>[];
    var helps = 0;
    MarketOrderBoard board(String id, int start) => MarketOrderBoard(
          scenario: order(id: id, start: start, delta: 2),
          onResult: results.add,
          onHelpUsed: () => helps++,
          demonstrateOnStart: true,
        );
    await showOrder(tester, board('first', 1));
    await tester.pump(const Duration(milliseconds: 100));
    conserved(3, 2, 1);
    await showOrder(tester, board('second', 3));
    await tester.pump(const Duration(milliseconds: 100));
    conserved(5, 4, 1);
    expect(helps, 2);
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();
    conserved(5, 3, 2);
    expect(results, isNotEmpty);
    expect(results, everyElement(isFalse));
    expect(tester.takeException(), isNull);
  });

  testWidgets('real bananas move into the order and undo returns the last one',
      (tester) async {
    final results = <bool>[];
    await showOrder(
        tester, MarketOrderBoard(scenario: order(), onResult: results.add));
    conserved(5, 3, 2);
    expect(keyed('market-order-board'), findsOneWidget);
    expect(keyed('market-delivered'), findsNothing);
    expect(find.text('3 + 2 = 5'), findsNothing);

    await tap(tester, 'market-pile-fruit-1');
    conserved(5, 4, 1);
    expect(results, [false]);
    await tap(tester, 'line-right');
    conserved(5, 5, 0);
    expect(results.last, isTrue);
    expect(keyed('market-delivered'), findsOneWidget);

    await tap(tester, 'line-left');
    conserved(5, 4, 1);
    expect(keyed('market-pile-fruit-0'), findsOneWidget);
    expect(results.last, isFalse);
    expect(keyed('market-delivered'), findsNothing);
  });

  testWidgets('rapid +1 taps each take a different available banana',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          onResult: results.add,
          onAction: () => actions++,
        ));
    await tester.tap(keyed('line-right'));
    await tester.tap(keyed('line-right'));
    // A stale, still-painted button must also be safe once the pile is empty.
    await tester.tap(keyed('line-right'));
    await tester.pumpAndSettle();
    conserved(5, 5, 0);
    expect(results, [false, true]);
    expect(actions, 2);
    expect(keyed('market-delivered'), findsOneWidget);
  });

  testWidgets('rapid taps on the same fruit never duplicate its identity',
      (tester) async {
    var actions = 0;
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          onResult: (_) {},
          onAction: () => actions++,
        ));
    await tester.tap(keyed('market-pile-fruit-0'));
    await tester.tap(keyed('market-pile-fruit-0'));
    await tester.pumpAndSettle();
    conserved(5, 4, 1);
    expect(actions, 1);
    expect(keyed('market-pile-fruit-1'), findsOneWidget);
  });

  testWidgets('dragging food to the basket makes the same conserved move',
      (tester) async {
    final results = <bool>[];
    var actions = 0;
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          onResult: results.add,
          onAction: () => actions++,
        ));
    final source = keyed('market-pile-fruit-0');
    final target = keyed('market-cart-drop');
    await tester.ensureVisible(source);
    final gesture = await tester.startGesture(tester.getCenter(source));
    await gesture.moveTo(tester.getCenter(target));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    conserved(5, 4, 1);
    expect(results, [false]);
    expect(actions, 1);
  });

  testWidgets('cooperative turns change only for real learner moves',
      (tester) async {
    var actions = 0;
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(),
          onResult: (_) {},
          onAction: () => actions++,
        ));
    await tap(tester, 'line-left');
    expect(actions, 0);
    await tap(tester, 'line-right');
    expect(actions, 1);
    await tester.tap(keyed('market-demo'));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(actions, 1);
    await tap(tester, 'line-left');
    expect(actions, 2);
    await tap(tester, 'market-pile-fruit-1');
    expect(actions, 3);
    await tap(tester, 'line-right');
    await tap(tester, 'line-right');
    expect(actions, 4);
  });

  testWidgets('new source id resets completed order and fruit supply',
      (tester) async {
    final results = <bool>[];
    await showOrder(
        tester, MarketOrderBoard(scenario: order(), onResult: results.add));
    await tap(tester, 'line-right');
    await tap(tester, 'line-right');
    expect(keyed('market-delivered'), findsOneWidget);
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(id: 'next', start: 1, delta: 3),
          onResult: results.add,
        ));
    conserved(4, 1, 3);
    expect(keyed('market-delivered'), findsNothing);
    expect(find.descendant(of: keyed('line-current'), matching: find.text('1')),
        findsOneWidget);
  });

  testWidgets('demo shows a real move, restores learner work, never solves it',
      (tester) async {
    final events = <String>[];
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(start: 0, delta: 1),
          onResult: (value) => events.add('$value'),
          onHelpUsed: () => events.add('help'),
        ));
    await tester.tap(keyed('market-demo'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(events.first, 'help');
    conserved(1, 1, 0);
    expect(keyed('market-delivered'), findsNothing);
    expect(events, isNot(contains('true')));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    conserved(1, 0, 1);
    expect(events.last, 'false');
    await tap(tester, 'line-right');
    expect(events.last, 'true');
  });

  testWidgets('demo preserves a partial construction and cancels on reset',
      (tester) async {
    final results = <bool>[];
    await showOrder(
        tester, MarketOrderBoard(scenario: order(), onResult: results.add));
    await tap(tester, 'line-right');
    await tester.tap(keyed('market-demo'));
    await tester.pump(const Duration(milliseconds: 100));
    conserved(5, 5, 0);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    conserved(5, 4, 1);
    expect(results, everyElement(isFalse));

    await tester.tap(keyed('market-demo'));
    await tester.pump();
    await showOrder(
        tester,
        MarketOrderBoard(
          scenario: order(id: 'fresh', start: 2, delta: 3),
          onResult: results.add,
        ));
    await tester.pump(const Duration(seconds: 2));
    conserved(5, 2, 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo disposal is safe and reduced motion has no repeating work',
      (tester) async {
    final results = <bool>[];
    await showOrder(
        tester, MarketOrderBoard(scenario: order(), onResult: results.add),
        reducedMotion: true);
    await tester.tap(keyed('market-demo'));
    await tester.pump(const Duration(milliseconds: 100));
    conserved(5, 4, 1);
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    expect(results, [false]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('264px lesson panel at 1.6 text retains generous touch targets',
      (tester) async {
    final results = <bool>[];
    for (final english in [false, true]) {
      await showOrder(
          tester,
          MarketOrderBoard(
            scenario: order(id: 'large-$english', start: 6, delta: 6),
            onResult: results.add,
            showHint: true,
            english: english,
          ),
          width: 264,
          textScale: 1.6);
      for (final key in [
        'line-right',
        'line-left',
        'market-demo',
        'market-pile-fruit-0'
      ]) {
        final size = tester.getSize(keyed(key));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
      for (var i = 0; i < 6; i++) {
        await tap(tester, 'line-right');
        expect(tester.takeException(), isNull);
      }
      conserved(12, 12, 0);
      expect(results.last, isTrue);
      await tap(tester, 'line-left');
      expect(results.last, isFalse);
      expect(tester.takeException(), isNull);
    }
  });
}
