import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/learning_app.dart';
import 'package:nested_nav/learning/progress.dart';

void main() {
  testWidgets('friends take turns and advance without a written quiz or star',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final backend = MemoryProgressBackend();
    await tester.pumpWidget(HerregaApp(store: ProgressStore(backend: backend)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('mode-friends')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('recommended-start')));
    await tester.tap(find.byKey(const ValueKey('recommended-start')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('team-turn-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson-guide')), findsNothing);
    expect(find.text('3 + 2 = ?'), findsNothing);
    await tester.ensureVisible(find.byKey(const ValueKey('line-right')));
    await tester.tap(find.byKey(const ValueKey('line-right')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('team-turn-2')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('line-right')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('team-turn-1')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('definition-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('transfer-input')), findsNothing);
    expect(find.byKey(const ValueKey('team-next')), findsOneWidget);
    final saved = ProgressState.decode(backend.value!);
    expect(saved.entry('numberLine-020').construction, isTrue);
    expect(saved.entry('numberLine-020').assisted, isTrue);
    expect(saved.stars, 0);
    await tester.tap(find.byKey(const ValueKey('team-next')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('market-order-board')), findsOneWidget);
    expect(find.byKey(const ValueKey('definition-card')), findsNothing);
    expect(find.byKey(const ValueKey('team-progress')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'optional solution explains the new problem and marks it assisted',
      (tester) async {
    final backend = MemoryProgressBackend();
    await tester.pumpWidget(HerregaApp(store: ProgressStore(backend: backend)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('recommended-start')));
    await tester.tap(find.byKey(const ValueKey('recommended-start')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    final add = find.byKey(const ValueKey('line-right'));
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('solution-open')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('worked-solution')), findsOneWidget);
    expect(find.byKey(const ValueKey('guide-step-0')), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const ValueKey('guide-step-0'))).data,
        isNotEmpty);
    await tester.tap(find.byKey(const ValueKey('solution-close')));
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('transfer-input'));
    await tester.ensureVisible(field);
    await tester.enterText(field, '6');
    await tester.tap(find.byKey(const ValueKey('transfer-check')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('completion-card')), findsOneWidget);
    expect(ProgressState.decode(backend.value!).stars, 0);
  });

  testWidgets('solo goals continue the sequence without requiring a quiz',
      (tester) async {
    final backend = MemoryProgressBackend();
    await tester.pumpWidget(HerregaApp(store: ProgressStore(backend: backend)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('recommended-start')));
    await tester.tap(find.byKey(const ValueKey('recommended-start')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    final add = find.byKey(const ValueKey('line-right'));
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('transfer-input')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('mission-next')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    final state = ProgressState.decode(backend.value!);
    expect(state.practiceCount, 1);
    expect(state.stars, 0);
    expect(find.text('Muuzii 6 naaf kenni.'), findsOneWidget);
    expect(find.byKey(const ValueKey('definition-card')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
