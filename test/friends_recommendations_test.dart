import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/recommendations.dart';
import 'package:nested_nav/learning/scenarios.dart';

void main() {
  test('shared completed constructions advance without independent stars', () {
    final catalogue = buildScenarios();
    final progress = ProgressState();
    final seen = <String>{};
    final kinds = <GameKind>[];
    for (var i = 0; i < 10; i++) {
      final next = recommendScenario(catalogue, progress, cooperative: true)!;
      expect(seen.add(next.id), isTrue);
      kinds.add(next.kind);
      progress.recordConstruction(next.id, assisted: true);
    }
    expect(kinds.take(3), everyElement(GameKind.numberLine));
    expect(kinds.skip(3).take(3), everyElement(GameKind.equalGroups));
    expect(kinds.skip(6).take(3), everyElement(GameKind.sharing));
    expect(progress.stars, 0);
    expect(progress.practiceCount, 10);
    expect(recommendScenario(catalogue, progress)!.kind, GameKind.numberLine);
  });

  test('first real mission is an order with three bananas and two to add', () {
    final next = recommendScenario(buildScenarios(), ProgressState())!;
    expect(next.values, {'start': 3, 'delta': 2});
  });

  test('team arithmetic starts with positive tangible orders', () {
    final progress = ProgressState();
    for (var i = 0; i < 3; i++) {
      final next =
          recommendScenario(buildScenarios(), progress, cooperative: true)!;
      expect(next.values['start'], greaterThan(0));
      expect(next.values['delta'], greaterThan(0));
      progress.recordConstruction(next.id, assisted: true);
    }
  });

  test('opening practice changes one parameter inside each familiar game', () {
    final progress = ProgressState();
    final rounds = <LearningScenario>[];
    for (var i = 0; i < 12; i++) {
      final next =
          recommendScenario(buildScenarios(), progress, includePractice: true)!;
      rounds.add(next);
      progress.recordConstruction(next.id, assisted: true);
    }
    for (var start = 0; start < 12; start += 3) {
      for (var i = start + 1; i < start + 3; i++) {
        expect(rounds[i].kind, rounds[i - 1].kind);
        expect(
            rounds[i]
                .values
                .keys
                .where(
                    (key) => rounds[i].values[key] != rounds[i - 1].values[key])
                .length,
            1);
      }
    }
    expect(progress.stars, 0);
  });
}
