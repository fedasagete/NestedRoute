/// The twelve direct-manipulation mathematical models in the catalogue.
enum GameKind {
  numberLine,
  equalGroups,
  sharing,
  fractionTiles,
  balance,
  areaGrid,
  angleBuilder,
  similarity,
  volume,
  probability,
  sets,
  data,
}

/// English text is review copy; source pages are printed textbook pages.
class LearningScenario {
  const LearningScenario({
    required this.id,
    required this.kind,
    required this.level,
    required this.values,
    required this.goal,
    required this.explanation,
    required this.transferPrompt,
    required this.transferAnswer,
    this.sourceGrade,
    this.sourcePage,
  });

  final String id;
  final GameKind kind;
  final int level;
  final Map<String, int> values;
  final String goal;
  final String explanation;
  final String transferPrompt;
  final int transferAnswer;
  final int? sourceGrade;
  final int? sourcePage;
}

/// Reusable teaching models with 100 numerical variations each.
///
/// These are prerequisite and representative textbook activities, not complete
/// chapter or exam coverage. The ordering is fixed so stored ids remain useful.
List<LearningScenario> buildScenarios() => _catalogue;

List<LearningScenario> scenariosFor(GameKind kind) =>
    List<LearningScenario>.unmodifiable(
      _catalogue.where((scenario) => scenario.kind == kind),
    );

final List<LearningScenario> _catalogue = _generateScenarios();

List<LearningScenario> _generateScenarios() {
  final scenarios = <LearningScenario>[];
  for (final kind in GameKind.values) {
    final variations = _parameters(kind);
    for (var index = 0; index < variations.length; index++) {
      final values = variations[index];
      final level = index < 34 ? 1 : (index < 67 ? 2 : 3);
      final source =
          level == 1 && _foundationKinds.contains(kind) ? null : _sources[kind];
      final copy = _reviewCopy(kind, values);
      scenarios.add(LearningScenario(
        id: '${kind.name}-${(index + 1).toString().padLeft(3, '0')}',
        kind: kind,
        level: level,
        values: Map<String, int>.unmodifiable(values),
        goal: copy.goal,
        explanation: copy.explanation,
        transferPrompt: copy.prompt,
        transferAnswer: copy.answer,
        sourceGrade: source?[0],
        sourcePage: source?[1],
      ));
    }
  }
  return List<LearningScenario>.unmodifiable(scenarios);
}

List<Map<String, int>> _parameters(GameKind kind) {
  switch (kind) {
    case GameKind.numberLine:
      return [
        for (var i = 0; i < 34; i++) {'start': i ~/ 6, 'delta': 1 + i % 6},
        for (var i = 0; i < 33; i++)
          {'start': 1 + i ~/ 6, 'delta': -(1 + i % 6)},
        for (var i = 0; i < 33; i++)
          {
            'start': -(1 + i ~/ 6),
            'delta': i % 6 < 3 ? 4 + i % 3 : -(4 + i % 3),
          },
      ];
    case GameKind.equalGroups:
      return _ranked([
        for (var groups = 1; groups <= 10; groups++)
          for (var each = 1; each <= 10; each++)
            {'groups': groups, 'each': each},
      ], (v) => v['groups']! * v['each']!);
    case GameKind.sharing:
      return _ranked([
        for (var people = 1; people <= 10; people++)
          for (var each = 1; each <= 10; each++)
            {'total': people * each, 'people': people},
      ], (v) => v['total']!);
    case GameKind.fractionTiles:
      return [
        for (var parts = 2; parts <= 15; parts++)
          for (var selected = 1; selected < parts; selected++)
            {'parts': parts, 'selected': selected},
      ].take(100).toList();
    case GameKind.balance:
      return _ranked(
          [
            for (var factor = 1; factor <= 5; factor++)
              for (var solution = 1; solution <= 5; solution++)
                for (final offset in [0, 1, 3, -1])
                  {'factor': factor, 'offset': offset, 'solution': solution},
          ],
          (v) =>
              v['factor']! * v['solution']! +
              v['offset']!.abs() +
              (v['offset']! < 0 ? 20 : 0));
    case GameKind.areaGrid:
      return _ranked([
        for (var width = 1; width <= 10; width++)
          for (var height = 1; height <= 10; height++)
            {'width': width, 'height': height},
      ], (v) => v['width']! * v['height']!);
    case GameKind.angleBuilder:
      return [
        for (var i = 0; i < 34; i++)
          {'a': 20 + 10 * (i ~/ 7), 'b': 20 + 10 * (i % 7)},
        for (var i = 0; i < 33; i++)
          {'a': 25 + 10 * (i ~/ 6), 'b': 25 + 10 * (i % 6)},
        for (var i = 0; i < 33; i++)
          {'a': 21 + 10 * (i ~/ 6), 'b': 31 + 7 * (i % 6)},
      ];
    case GameKind.similarity:
      return _ranked([
        for (var width = 2; width <= 6; width++)
          for (var height = 2; height <= 6; height++)
            for (var scale = 2; scale <= 5; scale++)
              {'width': width, 'height': height, 'scale': scale},
      ], (v) => v['width']! * v['height']! * v['scale']! * v['scale']!);
    case GameKind.volume:
      return _ranked([
        for (var width = 1; width <= 5; width++)
          for (var depth = 1; depth <= 5; depth++)
            for (var height = 1; height <= 4; height++)
              {'width': width, 'depth': depth, 'height': height},
      ], (v) => v['width']! * v['depth']! * v['height']!);
    case GameKind.probability:
      return _ranked([
        for (var red = 1; red <= 10; red++)
          for (var blue = 1; blue <= 10; blue++) {'red': red, 'blue': blue},
      ], (v) => v['red']! + v['blue']!);
    case GameKind.sets:
      return _ranked([
        for (var aOnly = 1; aOnly <= 5; aOnly++)
          for (var shared = 1; shared <= 4; shared++)
            for (var bOnly = 1; bOnly <= 5; bOnly++)
              {'aOnly': aOnly, 'shared': shared, 'bOnly': bOnly},
      ], (v) => v['aOnly']! + v['shared']! + v['bOnly']!);
    case GameKind.data:
      return [
        for (var mean = 3; mean <= 12; mean++)
          for (var i = 0; i < 10; i++)
            {
              'a': mean - (1 + i % 3),
              'b': mean + i ~/ 3,
              'c': mean + (1 + i % 3),
              'd': mean - i ~/ 3,
              'e': mean,
            },
      ];
  }
}

/// Small quantities precede larger ones. Compare each value to break ties:
/// Dart's sort need not be stable, so score alone would not define an order.
List<Map<String, int>> _ranked(
    List<Map<String, int>> variations, int Function(Map<String, int>) score) {
  variations.sort((left, right) {
    final difficulty = score(left).compareTo(score(right));
    if (difficulty != 0) return difficulty;
    final l = left.values.toList();
    final r = right.values.toList();
    for (var i = 0; i < l.length; i++) {
      final comparison = l[i].compareTo(r[i]);
      if (comparison != 0) return comparison;
    }
    return 0;
  });
  return variations;
}

({String goal, String explanation, String prompt, int answer}) _reviewCopy(
    GameKind kind, Map<String, int> v) {
  switch (kind) {
    case GameKind.numberLine:
      final start = v['start']!;
      final delta = v['delta']!;
      final direction = delta > 0 ? 'right' : 'left';
      return (
        goal: 'Start at $start. Move ${delta.abs()} steps $direction.',
        explanation:
            'Right adds; left subtracts. $start + ($delta) = ${start + delta}.',
        prompt: '${start + 1} + ($delta) = ?',
        answer: start + 1 + delta,
      );
    case GameKind.equalGroups:
      final groups = v['groups']!;
      final each = v['each']!;
      return (
        goal: 'Put $each counters in each of $groups equal groups.',
        explanation:
            'Equal groups make multiplication: $groups × $each = ${groups * each}.',
        prompt: '${groups + 1} × $each = ?',
        answer: (groups + 1) * each,
      );
    case GameKind.sharing:
      final total = v['total']!;
      final people = v['people']!;
      final each = total ~/ people;
      return (
        goal: 'Share $total counters equally between $people people.',
        explanation:
            'Division shares equally: $total ÷ $people = $each for each person.',
        prompt: '${total + people} ÷ $people = ?',
        answer: each + 1,
      );
    case GameKind.fractionTiles:
      final parts = v['parts']!;
      final selected = v['selected']!;
      return (
        goal: 'Shade $selected of $parts equal tiles.',
        explanation:
            '$selected shaded out of $parts equal parts is $selected/$parts. '
            'The denominator counts all equal parts.',
        prompt: '${selected + 1}/${parts + 1}: denominator = ?',
        answer: parts + 1,
      );
    case GameKind.balance:
      final factor = v['factor']!;
      final offset = v['offset']!;
      final solution = v['solution']!;
      final target = factor * solution + offset;
      final newOffset = offset + (offset < 0 ? -1 : 1);
      final newTarget = factor * (solution + 1) + newOffset;
      return (
        goal: 'Balance $factor × ? + ($offset) with $target.',
        explanation: 'Equal sides have the same value. ? = $solution: '
            '$factor × $solution + ($offset) = $target.',
        prompt: '$factor × ? + ($newOffset) = $newTarget',
        answer: solution + 1,
      );
    case GameKind.areaGrid:
      final width = v['width']!;
      final height = v['height']!;
      return (
        goal: 'Cover a $width × $height rectangle with unit squares.',
        explanation: 'Area counts squares, not edge length: '
            '$width × $height = ${width * height} square units.',
        prompt: '${width + 1} × $height = ? square units',
        answer: (width + 1) * height,
      );
    case GameKind.angleBuilder:
      final a = v['a']!;
      final b = v['b']!;
      return (
        goal: 'Complete the triangle: $a° + $b° + ?° = 180°.',
        explanation: 'Three triangle corners make a straight angle. '
            'The missing angle is ${180 - a - b}°.',
        prompt: '${a + 1}° + $b° + ?° = 180°',
        answer: 180 - (a + 1) - b,
      );
    case GameKind.similarity:
      final width = v['width']!;
      final height = v['height']!;
      final scale = v['scale']!;
      return (
        goal: 'Enlarge both sides of $width × $height by scale $scale.',
        explanation: 'Multiply every side by $scale: '
            '${width * scale} × ${height * scale}. Angles stay the same.',
        prompt: 'Side ${width + 1} × scale $scale = ?',
        answer: (width + 1) * scale,
      );
    case GameKind.volume:
      final width = v['width']!;
      final depth = v['depth']!;
      final height = v['height']!;
      final layer = width * depth;
      return (
        goal: 'Build a $width × $depth × $height prism from unit cubes.',
        explanation: 'Each layer has $layer cubes. $height layers hold '
            '${layer * height} cubic units.',
        prompt: '${width + 1} × $depth × $height = ? cubic units',
        answer: (width + 1) * depth * height,
      );
    case GameKind.probability:
      final red = v['red']!;
      final blue = v['blue']!;
      return (
        goal:
            'Draw from $red red and $blue blue counters, then build the probability of red.',
        explanation: 'For an equally likely draw, $red of ${red + blue} '
            'outcomes are red: probability $red/${red + blue}.',
        prompt: '${red + 1} red + ${blue + 1} blue = ? possible outcomes',
        answer: red + blue + 2,
      );
    case GameKind.sets:
      final aOnly = v['aOnly']!;
      final shared = v['shared']!;
      final bOnly = v['bOnly']!;
      return (
        goal: 'Sort $aOnly only A, $shared both, and $bOnly only B.',
        explanation: 'The intersection has $shared shared members. '
            'The union has ${aOnly + shared + bOnly}; count shared members once.',
        prompt:
            '${aOnly + 1} only A + $shared shared + ${bOnly + 1} only B = ? in A ∪ B',
        answer: aOnly + shared + bOnly + 2,
      );
    case GameKind.data:
      final numbers = v.values.toList();
      final total = numbers.reduce((a, b) => a + b);
      final transfer = numbers.reversed.map((value) => value + 1).toList();
      return (
        goal: 'Share ${numbers.join(', ')} equally across five stacks.',
        explanation:
            'Mean is the equal share: total $total ÷ 5 = ${total ~/ 5}.',
        prompt: 'Mean: ${transfer.join(', ')} = ?',
        answer: transfer.reduce((a, b) => a + b) ~/ 5,
      );
  }
}

const _foundationKinds = {
  GameKind.numberLine,
  GameKind.equalGroups,
  GameKind.sharing,
  GameKind.fractionTiles,
};

// Printed pages in the supplied 2022 editions, rather than PDF viewer indices.
// Activities are adaptations, not transcriptions of textbook exercises.
const _sources = {
  GameKind.numberLine: [7, 36],
  GameKind.equalGroups: [7, 41],
  GameKind.sharing: [7, 45],
  GameKind.fractionTiles: [8, 3],
  GameKind.balance: [7, 96],
  GameKind.areaGrid: [7, 147],
  GameKind.angleBuilder: [8, 118],
  GameKind.similarity: [8, 97],
  GameKind.volume: [8, 191],
  GameKind.probability: [8, 210],
  GameKind.sets: [7, 11],
  GameKind.data: [7, 199],
};
