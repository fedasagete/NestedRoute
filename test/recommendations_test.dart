import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/progress.dart';
import 'package:nested_nav/learning/recommendations.dart';
import 'package:nested_nav/learning/scenarios.dart';

void solve(ProgressState progress, LearningScenario item) =>
    progress.recordTransfer(item.id, correct: true, assisted: false);

LearningScenario item(String id, GameKind kind, Map<String, int> values,
        {int level = 1}) =>
    LearningScenario(
        id: id,
        kind: kind,
        level: level,
        values: values,
        goal: '',
        explanation: '',
        transferPrompt: '',
        transferAnswer: 0);

void main() {
  test('route recommends practice rounds without claiming topic mastery', () {
    expect(recommendedPracticeRoute.map((stage) => stage.independentRounds),
        [6, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1]);
    expect(recommendedPracticeRoute.map((stage) => stage.kind), [
      GameKind.numberLine,
      GameKind.equalGroups,
      GameKind.sharing,
      GameKind.fractionTiles,
      GameKind.balance,
      GameKind.areaGrid,
      GameKind.angleBuilder,
      GameKind.similarity,
      GameKind.volume,
      GameKind.sets,
      GameKind.data,
      GameKind.probability,
    ]);
  });

  test('one successful addition keeps the recommendation in arithmetic', () {
    final catalogue = buildScenarios();
    final progress = ProgressState();
    final first = recommendScenario(catalogue, progress)!;
    expect(first.kind, GameKind.numberLine);
    expect(first.values['start'], greaterThan(0));
    expect(first.values['delta'], greaterThan(0));
    solve(progress, first);
    final next = recommendScenario(catalogue, progress)!;
    expect(next.kind, GameKind.numberLine);
    expect(next.id, isNot(first.id));
  });

  test('foundation rounds precede algebra and geometry with varied quantities',
      () {
    final catalogue = buildScenarios();
    final progress = ProgressState();
    final rounds = <LearningScenario>[];
    for (var i = 0; i < 26; i++) {
      final next = recommendScenario(catalogue, progress)!;
      rounds.add(next);
      solve(progress, next);
    }
    expect(
        rounds.take(6).map((s) => s.kind), everyElement(GameKind.numberLine));
    expect(rounds.skip(6).take(4).map((s) => s.kind),
        everyElement(GameKind.equalGroups));
    expect(rounds.skip(10).take(4).map((s) => s.kind),
        everyElement(GameKind.sharing));
    expect(rounds.skip(14).take(4).map((s) => s.kind),
        everyElement(GameKind.fractionTiles));
    expect(rounds.skip(18).map((s) => s.kind), [
      GameKind.balance,
      GameKind.areaGrid,
      GameKind.angleBuilder,
      GameKind.similarity,
      GameKind.volume,
      GameKind.sets,
      GameKind.data,
      GameKind.probability,
    ]);
    expect(rounds.take(3).map((s) => s.values['delta']!),
        everyElement(isPositive));
    expect(rounds.skip(3).take(3).map((s) => s.values['delta']!),
        everyElement(isNegative));
    expect(rounds.take(6).map((s) => s.values['start']).toSet().length,
        greaterThanOrEqualTo(3));
    final groups = rounds.skip(6).take(4);
    expect(groups.map((s) => s.values['groups']!),
        everyElement(greaterThanOrEqualTo(2)));
    expect(groups.map((s) => s.values['each']!),
        everyElement(greaterThanOrEqualTo(2)));
    expect(groups.map((s) => s.values['groups']).toSet().length,
        greaterThanOrEqualTo(3));
    final shares = rounds.skip(10).take(4);
    expect(shares.map((s) => s.values['people']!),
        everyElement(greaterThanOrEqualTo(2)));
    expect(shares.map((s) => s.values['total']! ~/ s.values['people']!),
        everyElement(greaterThanOrEqualTo(2)));
    expect(shares.map((s) => s.values['people']).toSet().length,
        greaterThanOrEqualTo(3));
    expect(rounds.skip(14).take(4).map((s) => s.values['parts']).toSet().length,
        greaterThanOrEqualTo(3));
  });

  test(
      'guided success and mistakes stay on the step until independent correction',
      () {
    final catalogue = buildScenarios();
    final progress = ProgressState();
    final first = recommendScenario(catalogue, progress)!;
    progress.recordConstruction(first.id, assisted: true);
    progress.recordTransfer(first.id, correct: true, assisted: true);
    expect(recommendScenario(catalogue, progress)!.id, first.id);
    progress.recordTransfer(first.id, correct: false, assisted: false);
    expect(recommendScenario(catalogue, progress)!.id, first.id);
    solve(progress, first);
    expect(progress.entry(first.id).assisted, isTrue);
    expect(recommendScenario(catalogue, progress)!.id, isNot(first.id));
    expect(recommendScenario(catalogue, progress)!.kind, GameKind.numberLine);
  });

  test(
      'recommendations are deterministic across restoration and catalogue order',
      () {
    final catalogue = buildScenarios();
    final originalIds = catalogue.map((s) => s.id).toList();
    final progress = ProgressState();
    for (var i = 0; i < 23; i++) {
      solve(progress, recommendScenario(catalogue, progress)!);
    }
    final expected = recommendScenario(catalogue, progress)!.id;
    final restored = ProgressState.decode(progress.encode());
    expect(
        recommendScenario(catalogue.reversed.toList(), restored)!.id, expected);
    expect(recommendScenario(catalogue, progress)!.id, expected);
    expect(catalogue.map((s) => s.id), originalIds);
  });

  test(
      'after introduction the route cycles representations and reaches every entry',
      () {
    final catalogue = buildScenarios();
    final progress = ProgressState();
    final visited = <String>{};
    final cyclingKinds = <GameKind>[];
    final lastLevel = <GameKind, int>{};
    for (var i = 0; i < catalogue.length; i++) {
      final next = recommendScenario(catalogue, progress)!;
      expect(visited.add(next.id), isTrue,
          reason: 'Unsolved work must remain reachable.');
      if (i >= 26) {
        expect(next.level, greaterThanOrEqualTo(lastLevel[next.kind] ?? 1));
        lastLevel[next.kind] = next.level;
        if (i < 38) cyclingKinds.add(next.kind);
      }
      solve(progress, next);
    }
    expect(visited, catalogue.map((s) => s.id).toSet());
    expect(cyclingKinds, recommendedPracticeRoute.map((stage) => stage.kind));
    final encoded = progress.encode();
    final review = recommendScenario(catalogue, progress);
    expect(review, isNotNull);
    expect(visited, contains(review!.id));
    expect(recommendScenario(catalogue, progress)!.id, review.id);
    expect(progress.encode(), encoded);
  });

  test(
      'tiny injected catalogues exhaust available stages and skip absent families',
      () {
    final catalogue = [
      item('area', GameKind.areaGrid, {'width': 2, 'height': 2}),
      item('sum', GameKind.numberLine, {'start': 1, 'delta': 2}),
      item('groups', GameKind.equalGroups, {'groups': 2, 'each': 2}),
      item('subtract', GameKind.numberLine, {'start': 3, 'delta': -1}),
    ];
    final progress = ProgressState();
    final order = <String>[];
    for (var i = 0; i < catalogue.length; i++) {
      final next = recommendScenario(catalogue, progress)!;
      order.add(next.id);
      solve(progress, next);
    }
    expect(order, ['sum', 'subtract', 'groups', 'area']);
    expect(recommendScenario(catalogue, progress), isNotNull);
  });

  test('single-case, empty, and only trivial prerequisite catalogues are safe',
      () {
    final progress = ProgressState();
    expect(recommendScenario([], progress), isNull);
    final single = item('only', GameKind.sharing, {'total': 1, 'people': 1});
    expect(recommendScenario([single], progress), same(single));
    solve(progress, single);
    expect(recommendScenario([single], progress), same(single));
    final group = item('unit', GameKind.equalGroups, {'groups': 1, 'each': 1});
    expect(recommendScenario([single, group], progress), same(group));
  });

  test(
      'progress for hard labs outside the injected catalogue does not skip arithmetic',
      () {
    final catalogue = buildScenarios();
    final progress = ProgressState();
    final before = recommendScenario(catalogue, progress)!.id;
    for (var i = 0; i < 40; i++) {
      progress.recordTransfer('lab-$i', correct: true, assisted: false);
    }
    expect(recommendScenario(catalogue, progress)!.id, before);
  });
}
