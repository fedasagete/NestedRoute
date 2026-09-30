import 'progress.dart';
import 'scenarios.dart';

/// Suggested independent practice, rather than a claim of topic mastery.
class PracticeRouteStage {
  const PracticeRouteStage(this.kind, this.independentRounds);
  final GameKind kind;
  final int independentRounds;
}

const recommendedPracticeRoute = <PracticeRouteStage>[
  PracticeRouteStage(GameKind.numberLine, 6),
  PracticeRouteStage(GameKind.equalGroups, 4),
  PracticeRouteStage(GameKind.sharing, 4),
  PracticeRouteStage(GameKind.fractionTiles, 4),
  PracticeRouteStage(GameKind.balance, 1),
  PracticeRouteStage(GameKind.areaGrid, 1),
  PracticeRouteStage(GameKind.angleBuilder, 1),
  PracticeRouteStage(GameKind.similarity, 1),
  PracticeRouteStage(GameKind.volume, 1),
  PracticeRouteStage(GameKind.sets, 1),
  PracticeRouteStage(GameKind.data, 1),
  PracticeRouteStage(GameKind.probability, 1),
];

// Shared goals advance through practice; they are not independent assessments.
const cooperativePracticeRoute = <PracticeRouteStage>[
  PracticeRouteStage(GameKind.numberLine, 3),
  PracticeRouteStage(GameKind.equalGroups, 3),
  PracticeRouteStage(GameKind.sharing, 3),
  PracticeRouteStage(GameKind.fractionTiles, 3),
  PracticeRouteStage(GameKind.areaGrid, 1),
  PracticeRouteStage(GameKind.balance, 1),
  PracticeRouteStage(GameKind.angleBuilder, 1),
  PracticeRouteStage(GameKind.similarity, 1),
  PracticeRouteStage(GameKind.volume, 1),
  PracticeRouteStage(GameKind.sets, 1),
  PracticeRouteStage(GameKind.data, 1),
  PracticeRouteStage(GameKind.probability, 1),
];

/// Recommendations never lock an activity or change the learner's progress.
///
/// Only independently solved transfer questions advance the introduction.
/// After it, a deterministic cycle returns unsolved questions from different
/// representations, using the easiest remaining level in each family. Empty
/// catalogues return null; a completed catalogue offers a stable review round.
LearningScenario? recommendScenario(
    List<LearningScenario> catalogue, ProgressState progress,
    {bool cooperative = false, bool includePractice = false}) {
  if (catalogue.isEmpty) return null;
  final guided = cooperative || includePractice;
  final route = guided ? cooperativePracticeRoute : recommendedPracticeRoute;
  final families = {
    for (final kind in GameKind.values) kind: <LearningScenario>[],
  };
  final completed = {
    for (final kind in GameKind.values) kind: <LearningScenario>[],
  };
  final remaining = {
    for (final kind in GameKind.values) kind: <LearningScenario>[],
  };
  for (final scenario in catalogue) {
    families[scenario.kind]!.add(scenario);
    final entry = progress.entry(scenario.id);
    (entry.independent || (cooperative || includePractice) && entry.construction
            ? completed[scenario.kind]!
            : remaining[scenario.kind]!)
        .add(scenario);
  }

  var introductionSize = 0;
  for (final stage in route) {
    final available = families[stage.kind]!.length;
    final goal = available < stage.independentRounds
        ? available
        : stage.independentRounds;
    introductionSize += goal;
    if (completed[stage.kind]!.length < goal) {
      return _choose(remaining[stage.kind]!, completed[stage.kind]!,
          introductory: true, guided: guided);
    }
  }

  // Count only this catalogue: progress from a discovery lab cannot shift it.
  final solved =
      completed.values.fold<int>(0, (sum, family) => sum + family.length);
  final cycle = (solved - introductionSize) % route.length;
  for (var offset = 0; offset < route.length; offset++) {
    final kind = route[(cycle + offset) % route.length].kind;
    if (remaining[kind]!.isNotEmpty) {
      return _choose(remaining[kind]!, completed[kind]!, introductory: false);
    }
  }

  for (final stage in route) {
    if (families[stage.kind]!.isNotEmpty) {
      return _choose(families[stage.kind]!, const [], introductory: true);
    }
  }
  return null;
}

LearningScenario _choose(
    List<LearningScenario> remaining, List<LearningScenario> completed,
    {required bool introductory, bool guided = false}) {
  final candidates = introductory
      ? _introductoryCandidates(remaining, completed.length)
      : remaining;
  if (introductory && guided) {
    final sequences = <GameKind, List<Map<String, int>>>{
      GameKind.numberLine: [
        {'start': 3, 'delta': 2},
        {'start': 3, 'delta': 3},
        {'start': 4, 'delta': 3},
      ],
      GameKind.equalGroups: [
        {'groups': 2, 'each': 2},
        {'groups': 2, 'each': 3},
        {'groups': 3, 'each': 3},
      ],
      GameKind.sharing: [
        {'total': 9, 'people': 3},
        {'total': 12, 'people': 3},
        {'total': 12, 'people': 4},
      ],
      GameKind.fractionTiles: [
        {'parts': 4, 'selected': 1},
        {'parts': 4, 'selected': 2},
        {'parts': 6, 'selected': 2},
      ],
    };
    final sequence = sequences[remaining.first.kind];
    if (sequence != null) {
      for (final parameters in sequence) {
        for (final scenario in remaining) {
          if (parameters.entries
              .every((e) => scenario.values[e.key] == e.value)) return scenario;
        }
      }
    }
  }
  if (introductory &&
      completed.isEmpty &&
      remaining.first.kind == GameKind.numberLine) {
    for (final scenario in candidates) {
      if (scenario.values['start'] == 3 && scenario.values['delta'] == 2) {
        return scenario;
      }
    }
  }
  final easiestLevel = candidates
      .map((scenario) => scenario.level)
      .reduce((left, right) => left < right ? left : right);
  final frequencies = <String, int>{};
  for (final scenario in completed) {
    for (final feature in _features(scenario).entries) {
      final key = '${feature.key}:${feature.value}';
      frequencies[key] = (frequencies[key] ?? 0) + 1;
    }
  }
  final ranked = <_RankedScenario>[];
  for (final scenario
      in candidates.where((scenario) => scenario.level == easiestLevel)) {
    final repetition = _features(scenario).entries.fold<int>(
        0,
        (sum, feature) =>
            sum + (frequencies['${feature.key}:${feature.value}'] ?? 0));
    ranked.add(_RankedScenario(scenario, repetition, _complexity(scenario)));
  }
  ranked.sort((left, right) {
    final variety = left.repetition.compareTo(right.repetition);
    if (variety != 0) return variety;
    final size = left.complexity.compareTo(right.complexity);
    if (size != 0) return size;
    return left.scenario.id.compareTo(right.scenario.id);
  });
  return ranked.first.scenario;
}

List<LearningScenario> _introductoryCandidates(
    List<LearningScenario> remaining, int completed) {
  if (remaining.first.kind == GameKind.numberLine) {
    final phase = remaining
        .where((scenario) =>
            completed < 3 ? _smallSum(scenario) : _smallSubtraction(scenario))
        .toList();
    if (phase.isNotEmpty) return phase;
  }
  final meaningful = remaining.where((scenario) {
    final v = scenario.values;
    switch (scenario.kind) {
      case GameKind.numberLine:
        return _smallSum(scenario) || _smallSubtraction(scenario);
      case GameKind.equalGroups:
        return v['groups']! >= 2 &&
            v['each']! >= 2 &&
            v['groups']! * v['each']! <= 20;
      case GameKind.sharing:
        return v['people']! >= 2 &&
            v['total']! ~/ v['people']! >= 2 &&
            v['total']! <= 20;
      case GameKind.fractionTiles:
        return v['parts']! <= 6;
      default:
        return true;
    }
  }).toList();
  // Small injected catalogues can contain only one-group/unit cases.
  return meaningful.isEmpty ? remaining : meaningful;
}

bool _smallSum(LearningScenario scenario) {
  final start = scenario.values['start']!;
  final delta = scenario.values['delta']!;
  return start > 0 && delta > 0 && delta <= 3 && start + delta <= 8;
}

bool _smallSubtraction(LearningScenario scenario) {
  final start = scenario.values['start']!;
  final delta = scenario.values['delta']!;
  return delta < 0 && delta >= -3 && start <= 6 && start + delta >= 0;
}

Map<String, int> _features(LearningScenario scenario) {
  final v = scenario.values;
  switch (scenario.kind) {
    case GameKind.numberLine:
      return {...v, 'target': v['start']! + v['delta']!};
    case GameKind.sharing:
      return {'people': v['people']!, 'each': v['total']! ~/ v['people']!};
    case GameKind.fractionTiles:
      return {...v, 'shadedSide': (v['selected']! * 2).compareTo(v['parts']!)};
    default:
      return v;
  }
}

int _complexity(LearningScenario scenario) {
  final v = scenario.values;
  switch (scenario.kind) {
    case GameKind.numberLine:
      return v['start']!.abs() + v['delta']!.abs();
    case GameKind.equalGroups:
      return v['groups']! * v['each']!;
    case GameKind.sharing:
      return v['total']!;
    case GameKind.fractionTiles:
      return v['parts']!;
    case GameKind.balance:
      return v['factor']! * v['solution']! + v['offset']!.abs();
    case GameKind.areaGrid:
      return v['width']! * v['height']!;
    case GameKind.angleBuilder:
      return v['a']! + v['b']!;
    case GameKind.similarity:
      return v['width']! * v['height']! * v['scale']! * v['scale']!;
    case GameKind.volume:
      return v['width']! * v['depth']! * v['height']!;
    case GameKind.probability:
      return v['red']! + v['blue']!;
    case GameKind.sets:
      return v['aOnly']! + v['shared']! + v['bOnly']!;
    case GameKind.data:
      return v.values.fold(0, (sum, value) => sum + value);
  }
}

class _RankedScenario {
  const _RankedScenario(this.scenario, this.repetition, this.complexity);
  final LearningScenario scenario;
  final int repetition, complexity;
}
