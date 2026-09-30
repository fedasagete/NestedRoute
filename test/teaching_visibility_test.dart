import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/learning_app.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/scenarios.dart';

void main() {
  final examples = <LearningScenario, String>{
    scenariosFor(GameKind.numberLine).firstWhere(
            (s) => s.values['start'] == 3 && s.values['delta'] == 2):
        'market-cart-fruit-3',
    scenariosFor(GameKind.equalGroups).firstWhere(
            (s) => s.values['groups'] == 2 && s.values['each'] == 2):
        'packing-fruit-0-0',
    scenariosFor(GameKind.sharing).firstWhere(
            (s) => s.values['total'] == 9 && s.values['people'] == 3):
        'picnic-fruit-0-0',
  };
  for (final example in examples.entries) {
    for (final friends in [false, true]) {
      testWidgets(
          '${example.key.kind.name} teacher move is visible at320px/1.6 friends=$friends',
          (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.6;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(HerregaApp(
            store: ProgressStore(backend: MemoryProgressBackend()),
            catalogue: [example.key]));
        await tester.pumpAndSettle();
        if (friends) {
          await tester
              .ensureVisible(find.byKey(const ValueKey('mode-friends')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const ValueKey('mode-friends')));
          await tester.pumpAndSettle();
        }
        await tester
            .ensureVisible(find.byKey(const ValueKey('recommended-start')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('recommended-start')));
        await tester.pump();
        final fruit = find.byKey(ValueKey(example.value));
        for (var frame = 0; frame < 60 && fruit.evaluate().isEmpty; frame++) {
          await tester.pump(const Duration(milliseconds: 50));
        }
        expect(fruit, findsOneWidget);
        final viewport =
            tester.getRect(find.byType(SingleChildScrollView).first);
        final receiver = tester.getRect(fruit);
        expect(receiver.top, greaterThanOrEqualTo(viewport.top),
            reason:
                'The demonstrated fruit must be on screen: $receiver, viewport $viewport');
        expect(receiver.bottom, lessThanOrEqualTo(viewport.bottom),
            reason:
                'The demonstrated fruit must be on screen: $receiver, viewport $viewport');
        expect(
            tester
                .widget<FilledButton>(
                    find.byKey(const ValueKey('lesson-continue')))
                .onPressed,
            isNull);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
