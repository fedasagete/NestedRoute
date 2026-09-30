import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/learning_app.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/scenarios.dart';

void main() {
  testWidgets(
      'fraction discovery fits pieces before definition and new numbers',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = ProgressStore(backend: MemoryProgressBackend());
    await tester.pumpWidget(
        HerregaApp(store: store, catalogue: [buildScenarios().first]));
    await tester.pumpAndSettle();
    final card = find.byKey(const ValueKey('discovery-fractionDivision'));
    await tester.scrollUntilVisible(card, 250);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('definition-card')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('fraction-division-split')));
    await tester.pumpAndSettle();
    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byKey(ValueKey('fraction-division-slot-$i')));
      await tester.pump();
    }
    final next = find.byKey(const ValueKey('lesson-continue'));
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('definition-card')), findsOneWidget);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('5/6 ÷ 1/6 = ?'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('transfer-input')), '5');
    await tester.tap(find.byKey(const ValueKey('transfer-check')));
    await tester.pumpAndSettle();
    expect((await store.load()).entry('discovery-fractionDivision').independent,
        isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('English matching hides the outer answer reference', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(HerregaApp(store: ProgressStore(backend: MemoryProgressBackend()),
      catalogue: [buildScenarios().first]));
    await tester.pumpAndSettle();
    final card = find.byKey(const ValueKey('discovery-englishNumbers'));
    await tester.scrollUntilVisible(card, 250);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();
    final match = find.byKey(const ValueKey('english-numbers-next'));
    await tester.scrollUntilVisible(match, 250);
    await tester.pumpAndSettle();
    await tester.tap(match);
    await tester.pumpAndSettle();
    // Only the shuffled word card names THREE; the outer goal is not a key.
    expect(find.textContaining('THREE'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
