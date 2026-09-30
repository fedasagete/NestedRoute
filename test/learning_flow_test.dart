import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/learning_app.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/scenarios.dart';

const lesson = LearningScenario(
    id: 'numberLine-test',
    kind: GameKind.numberLine,
    level: 1,
    values: {'start': 0, 'delta': 2},
    goal: 'Move two steps',
    explanation: 'Two steps add two',
    transferPrompt: '1 + 2 = ?',
    transferAnswer: 3);

Future<void> start(WidgetTester tester, ProgressStore store) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(HerregaApp(store: store, catalogue: const [lesson]));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('recommended-start')));
  await tester.pumpAndSettle();
}

Future<void> construct(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('line-right')));
  await tester.tap(find.byKey(const ValueKey('line-right')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('lesson-continue')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'actions precede definition; transfer awards a single persisted star',
      (tester) async {
    final store = ProgressStore(backend: MemoryProgressBackend());
    await start(tester, store);
    expect(find.byKey(const ValueKey('definition-card')), findsNothing);
    expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('lesson-continue')))
            .onPressed,
        isNull);
    await construct(tester);
    expect(find.byKey(const ValueKey('definition-card')), findsOneWidget);
    expect((await store.load()).masteredCount, 0);
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('transfer-input')), '2');
    await tester.tap(find.byKey(const ValueKey('transfer-check')));
    await tester.pumpAndSettle();
    expect((await store.load()).masteredCount, 0);
    await tester.enterText(find.byKey(const ValueKey('transfer-input')), '3');
    await tester.tap(find.byKey(const ValueKey('transfer-check')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('completion-card')), findsOneWidget);
    expect((await store.load()).stars, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('answer help keeps the result as guided practice',
      (tester) async {
    final store = ProgressStore(backend: MemoryProgressBackend());
    await start(tester, store);
    await construct(tester);
    await tester.tap(find.byKey(const ValueKey('lesson-continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('lesson-help')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('transfer-input')), '3');
    await tester.tap(find.byKey(const ValueKey('transfer-check')));
    await tester.pumpAndSettle();
    expect((await store.load()).stars, 0);
    expect((await store.load()).practiceCount, 1);
  });

  testWidgets('storage failure does not prevent playing but remains visible',
      (tester) async {
    await start(tester, ProgressStore(backend: BrokenStorage()));
    expect(find.byKey(const ValueKey('storage-warning')), findsOneWidget);
    expect(find.byKey(const ValueKey('line-right')), findsOneWidget);
  });

  testWidgets('a failure while saving becomes visible in the active lesson',
      (tester) async {
    await start(tester, ProgressStore(backend: WriteFailureStorage()));
    expect(find.byKey(const ValueKey('storage-warning')), findsNothing);
    await construct(tester);
    expect(find.byKey(const ValueKey('storage-warning')), findsOneWidget);
    expect(find.byKey(const ValueKey('definition-card')), findsOneWidget);
  });

  testWidgets('rapid continue taps cannot skip the definition while saving',
      (tester) async {
    final backend = DelayedStorage();
    await start(tester, ProgressStore(backend: backend));
    await tester.tap(find.byKey(const ValueKey('line-right')));
    await tester.tap(find.byKey(const ValueKey('line-right')));
    await tester.pumpAndSettle();
    final button = find.byKey(const ValueKey('lesson-continue'));
    await tester.tap(button);
    await tester.tap(button);
    await tester.pump();
    backend.release.complete();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('definition-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('transfer-input')), findsNothing);
  });
}

class BrokenStorage implements ProgressBackend {
  @override
  Future<String?> read() async => throw StateError('unavailable');
  @override
  Future<void> write(String data) async => throw StateError('unavailable');
}

class WriteFailureStorage implements ProgressBackend {
  @override
  Future<String?> read() async => null;
  @override
  Future<void> write(String data) async => throw StateError('unavailable');
}

class DelayedStorage extends MemoryProgressBackend {
  final release = Completer<void>();
  @override
  Future<void> write(String data) async {
    await release.future;
    await super.write(data);
  }
}
