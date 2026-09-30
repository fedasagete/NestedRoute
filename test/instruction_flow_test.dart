import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/learning_app.dart';
import 'package:nested_nav/learning/progress.dart';

Future<void> openHome(WidgetTester tester) async {
  tester.view.physicalSize = const Size(320, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
      HerregaApp(store: ProgressStore(backend: MemoryProgressBackend())));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'optional instructions preserve the learner board and do not solve it',
      (tester) async {
    await openHome(tester);
    await tester.tap(find.byKey(const ValueKey('recommended-start')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('lesson-guide')), findsNothing);
    await tester.tap(find.byTooltip('Tartiiba'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('lesson-guide')), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-step-0')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('guide-next')));
    await tester.tap(find.byKey(const ValueKey('guide-next')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('guide-step-1')), findsOneWidget);
    expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('lesson-continue')))
            .onPressed,
        isNull);
    await tester.tap(find.byKey(const ValueKey('instructions-close')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('line-right')));
    await tester.tap(find.byKey(const ValueKey('line-right')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('line-right')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('plain-language-definition')),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('hard lesson opens related basics and Back returns to that lab',
      (tester) async {
    await openHome(tester);
    final lab = find.byKey(const ValueKey('discovery-fractionDivision'));
    await tester.scrollUntilVisible(lab, 400,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(lab);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('guide-next')));
    await tester.pumpAndSettle();
    final split = find.byKey(const ValueKey('fraction-division-split'));
    await tester.ensureVisible(split);
    await tester.tap(split);
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('fraction-division-slot-0')), findsOneWidget);
    final basics = find.byKey(const ValueKey('basics-fractionTiles'));
    expect(basics, findsOneWidget);
    await tester.ensureVisible(basics);
    await tester.tap(basics);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('fraction-tile-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('fraction-division-split')), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
        find.byKey(const ValueKey('fraction-division-split')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('fraction-division-slot-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson-guide')), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-step-1')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
