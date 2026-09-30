import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/learning_app.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/scenarios.dart';
import 'package:nested_nav/learning/discoveries.dart';

void main() {
  final starterMissions = [
    scenariosFor(GameKind.numberLine)
        .firstWhere((s) => s.values['start'] == 5 && s.values['delta'] == 4),
    scenariosFor(GameKind.equalGroups)
        .firstWhere((s) => s.values['groups'] == 4 && s.values['each'] == 5),
    scenariosFor(GameKind.sharing)
        .firstWhere((s) => s.values['people'] == 4 && s.values['total'] == 20),
  ];
  for (final mission in starterMissions) {
    for (final friends in [false, true]) {
      testWidgets(
          '${mission.kind.name} story shell fits 320px/1.6 friends=$friends',
          (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.6;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(HerregaApp(
            store: ProgressStore(backend: MemoryProgressBackend()),
            catalogue: [mission]));
        await tester.pumpAndSettle();
        if (friends) {
          await tester
              .ensureVisible(find.byKey(const ValueKey('mode-friends')));
          await tester.tap(find.byKey(const ValueKey('mode-friends')));
          await tester.pumpAndSettle();
        }
        await tester
            .ensureVisible(find.byKey(const ValueKey('recommended-start')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('recommended-start')));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Tartiiba'));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('optional-instructions')),
            findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const ValueKey('instructions-close')));
        await tester.pumpAndSettle();
        expect(
            tester
                .getSize(find.byKey(const ValueKey('lesson-continue')))
                .height,
            greaterThanOrEqualTo(48));
        expect(tester.takeException(), isNull);
      });
    }
  }
  for (final kind in GameKind.values) {
    testWidgets(
        '${kind.name} fits a 320px phone with large text through the real shell',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(HerregaApp(
          store: ProgressStore(backend: MemoryProgressBackend()),
          catalogue: [scenariosFor(kind).last]));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Home must fit');
      await tester
          .ensureVisible(find.byKey(const ValueKey('recommended-start')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('recommended-start')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Board must fit');
      await tester.tap(find.byKey(const ValueKey('lesson-help')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Hint must fit');
      final action =
          tester.getRect(find.byKey(const ValueKey('lesson-continue')));
      expect(action.bottom, lessThanOrEqualTo(640));
      expect(action.height, greaterThanOrEqualTo(48));
      if (kind == GameKind.data) {
        expect(tester.getSize(find.byKey(const ValueKey('data-pile-0'))).width,
            greaterThanOrEqualTo(48));
      }
    });
  }
  for (final activity in discoveryActivities) {
    testWidgets('${activity.scenario.id} fits the real 320px large-text lesson',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(HerregaApp(
          store: ProgressStore(backend: MemoryProgressBackend()),
          catalogue: [buildScenarios().first]));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
          find.byKey(ValueKey(activity.scenario.id)), 250);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey(activity.scenario.id)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('lesson-help')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
