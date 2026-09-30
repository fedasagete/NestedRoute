import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/scenarios.dart';

void main() {
  test('catalogue contains 1200 deterministic scenarios with unique ids', () {
    final first = buildScenarios();
    final second = buildScenarios();

    expect(first, hasLength(1200));
    expect(first.map((scenario) => scenario.id).toSet(), hasLength(1200));
    expect(first.map(_record).toList(), second.map(_record).toList());
  });

  for (final kind in GameKind.values) {
    test('${kind.name} has 100 unique constructions across three levels', () {
      final scenarios = scenariosFor(kind);

      expect(scenarios, hasLength(100));
      expect(scenarios.every((scenario) => scenario.kind == kind), isTrue);
      expect(scenarios.map((scenario) => jsonEncode(scenario.values)).toSet(),
          hasLength(100));
      expect(scenarios.map((scenario) => scenario.level).toSet(), {1, 2, 3});
      for (final level in [1, 2, 3]) {
        expect(scenarios.where((scenario) => scenario.level == level).length,
            greaterThanOrEqualTo(30));
      }
      expect(
          scenarios.map((scenario) => scenario.id).toSet(),
          buildScenarios()
              .where((scenario) => scenario.kind == kind)
              .map((scenario) => scenario.id)
              .toSet());
    });

    test('${kind.name} values satisfy its mathematical construction', () {
      final scenarios = scenariosFor(kind);
      expect(scenarios, isNotEmpty);
      for (final scenario in scenarios) {
        final values = scenario.values;
        expect(values.keys.toSet(), _keys[kind], reason: scenario.id);
        switch (kind) {
          case GameKind.numberLine:
            expect(values['delta'], isNot(0));
            expect(
                values['start']! + values['delta']!, inInclusiveRange(-20, 20));
            break;
          case GameKind.equalGroups:
            expect(values['groups'], greaterThan(0));
            expect(values['each'], greaterThan(0));
            break;
          case GameKind.sharing:
            expect(values['people'], greaterThan(0));
            expect(values['total'], greaterThan(0));
            expect(values['total']! % values['people']!, 0);
            break;
          case GameKind.fractionTiles:
            expect(values['parts'], greaterThanOrEqualTo(2));
            expect(values['selected'], inInclusiveRange(1, values['parts']!));
            break;
          case GameKind.balance:
            expect(values['factor'], greaterThan(0));
            expect(values['solution'], greaterThan(0));
            expect(values['factor']! * values['solution']! + values['offset']!,
                greaterThanOrEqualTo(0));
            break;
          case GameKind.areaGrid:
            expect(values['width'], greaterThan(0));
            expect(values['height'], greaterThan(0));
            break;
          case GameKind.angleBuilder:
            expect(values['a'], greaterThan(0));
            expect(values['b'], greaterThan(0));
            expect(180 - values['a']! - values['b']!, greaterThan(0));
            break;
          case GameKind.similarity:
            expect(values['width'], greaterThan(0));
            expect(values['height'], greaterThan(0));
            expect(values['scale'], greaterThan(1));
            break;
          case GameKind.volume:
            expect(values.values.every((value) => value > 0), isTrue);
            break;
          case GameKind.probability:
            expect(values['red'], greaterThan(0));
            expect(values['blue'], greaterThan(0));
            break;
          case GameKind.sets:
            expect(values.values.every((value) => value > 0), isTrue);
            break;
          case GameKind.data:
            expect(values.values.every((value) => value >= 0), isTrue);
            expect(values.values.reduce((a, b) => a + b) % 5, 0);
            break;
        }
      }
    });

    test('${kind.name} transfer asks the same concept with changed numbers',
        () {
      final scenarios = scenariosFor(kind);
      expect(scenarios, isNotEmpty);
      for (final scenario in scenarios) {
        final numbers = RegExp(r'-?\d+')
            .allMatches(scenario.transferPrompt)
            .map((match) => int.parse(match.group(0)!))
            .toList();
        final values = scenario.values;
        int expected;
        switch (kind) {
          case GameKind.numberLine:
            expect(numbers, hasLength(2));
            expect(numbers[0], isNot(values['start']));
            expected = numbers[0] + numbers[1];
            break;
          case GameKind.equalGroups:
          case GameKind.areaGrid:
          case GameKind.similarity:
            expect(numbers, hasLength(2));
            final original = kind == GameKind.equalGroups
                ? values['groups']
                : values['width'];
            expect(numbers[0], isNot(original));
            expected = numbers[0] * numbers[1];
            break;
          case GameKind.sharing:
            expect(numbers, hasLength(2));
            expect(numbers[0], isNot(values['total']));
            expect(numbers[0] % numbers[1], 0);
            expected = numbers[0] ~/ numbers[1];
            break;
          case GameKind.fractionTiles:
            expect(numbers, hasLength(2));
            expect(numbers[0], isNot(values['selected']));
            expect(numbers[1], isNot(values['parts']));
            expect(numbers[0], inInclusiveRange(1, numbers[1]));
            expect(scenario.transferPrompt, contains('denominator'));
            expected = numbers[1];
            break;
          case GameKind.balance:
            expect(numbers, hasLength(3));
            expect(numbers[1], isNot(values['offset']));
            expect((numbers[2] - numbers[1]) % numbers[0], 0);
            expected = (numbers[2] - numbers[1]) ~/ numbers[0];
            expect(expected, isNot(values['solution']));
            break;
          case GameKind.angleBuilder:
            expect(numbers, hasLength(3));
            expect(numbers[0], isNot(values['a']));
            expect(numbers[2], 180);
            expected = 180 - numbers[0] - numbers[1];
            expect(expected, greaterThan(0));
            break;
          case GameKind.volume:
            expect(numbers, hasLength(3));
            expect(numbers[0], isNot(values['width']));
            expected = numbers.reduce((a, b) => a * b);
            break;
          case GameKind.probability:
            expect(numbers, hasLength(2));
            expect(numbers[0], isNot(values['red']));
            expect(numbers[1], isNot(values['blue']));
            expect(numbers.every((value) => value > 0), isTrue);
            expected = numbers[0] + numbers[1];
            break;
          case GameKind.sets:
            expect(numbers, hasLength(3));
            expect(numbers[0], isNot(values['aOnly']));
            expect(numbers[2], isNot(values['bOnly']));
            expect(scenario.transferPrompt, contains('∪'));
            expected = numbers.reduce((a, b) => a + b);
            break;
          case GameKind.data:
            expect(numbers, hasLength(5));
            expect(numbers, isNot(values.values.toList()));
            expect(numbers.reduce((a, b) => a + b) % 5, 0);
            expected = numbers.reduce((a, b) => a + b) ~/ 5;
            break;
        }
        expect(scenario.transferAnswer, expected, reason: scenario.id);
      }
    });
  }

  test('review copy explains each scenario and sources match its concept', () {
    final scenarios = buildScenarios();
    expect(scenarios, isNotEmpty);
    var prerequisites = 0;
    for (final scenario in scenarios) {
      expect(scenario.goal.trim(), isNotEmpty);
      expect(scenario.explanation.trim(), isNotEmpty);
      expect(scenario.transferPrompt.trim(), isNotEmpty);
      if (scenario.sourceGrade == null) {
        prerequisites++;
        expect(scenario.sourcePage, isNull);
        expect(scenario.level, 1);
        expect({
          GameKind.numberLine,
          GameKind.equalGroups,
          GameKind.sharing,
          GameKind.fractionTiles
        }, contains(scenario.kind));
      } else {
        expect([scenario.sourceGrade, scenario.sourcePage],
            _sources[scenario.kind]);
      }
    }
    expect(prerequisites, greaterThan(0));
  });

  test('signed number-line and balance variants extend foundation practice',
      () {
    final lines = scenariosFor(GameKind.numberLine);
    final balances = scenariosFor(GameKind.balance);
    expect(lines.any((scenario) => scenario.values['start']! < 0), isTrue);
    expect(lines.any((scenario) => scenario.values['delta']! < 0), isTrue);
    expect(balances.any((scenario) => scenario.values['offset']! < 0), isTrue);
    expect(balances.any((scenario) => scenario.values['factor']! > 1), isTrue);
  });
}

String _record(LearningScenario scenario) => jsonEncode({
      'id': scenario.id,
      'kind': scenario.kind.name,
      'level': scenario.level,
      'values': scenario.values,
      'goal': scenario.goal,
      'explanation': scenario.explanation,
      'transferPrompt': scenario.transferPrompt,
      'transferAnswer': scenario.transferAnswer,
      'sourceGrade': scenario.sourceGrade,
      'sourcePage': scenario.sourcePage,
    });

const _keys = {
  GameKind.numberLine: {'start', 'delta'},
  GameKind.equalGroups: {'groups', 'each'},
  GameKind.sharing: {'total', 'people'},
  GameKind.fractionTiles: {'parts', 'selected'},
  GameKind.balance: {'factor', 'offset', 'solution'},
  GameKind.areaGrid: {'width', 'height'},
  GameKind.angleBuilder: {'a', 'b'},
  GameKind.similarity: {'width', 'height', 'scale'},
  GameKind.volume: {'width', 'depth', 'height'},
  GameKind.probability: {'red', 'blue'},
  GameKind.sets: {'aOnly', 'shared', 'bOnly'},
  GameKind.data: {'a', 'b', 'c', 'd', 'e'},
};

// Printed page references, checked against the textbook reading notes and
// the extracted Grade 7 sections for set operations and the mean definition.
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
