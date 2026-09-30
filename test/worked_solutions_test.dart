import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/discoveries.dart';
import 'package:nested_nav/learning/lesson_copy.dart';
import 'package:nested_nav/learning/lesson_instruction.dart';
import 'package:nested_nav/learning/scenarios.dart';
import 'package:nested_nav/learning/worked_solutions.dart';

void main() {
  test('all 1209 lessons have short bilingual numbered derivations', () {
    final scenarios = [
      ...buildScenarios(),
      ...discoveryActivities.map((activity) => activity.scenario),
    ];
    expect(scenarios, hasLength(1209));
    for (final scenario in scenarios) {
      final steps = workedSolution(scenario);
      expect(steps.length, inInclusiveRange(3, 5), reason: scenario.id);
      for (var i = 0; i < steps.length; i++) {
        final step = steps[i];
        expect(step.oromo.trim(), isNotEmpty, reason: scenario.id);
        expect(step.english.trim(), isNotEmpty, reason: scenario.id);
        expect(step.oromo.length, lessThanOrEqualTo(140), reason: scenario.id);
        expect(step.english.length, lessThanOrEqualTo(140),
            reason: scenario.id);
        expect(step.visual, startsWith('${i + 1}. '), reason: scenario.id);
        expect(
            RegExp(r'\b(tap|click|drag|slider|button)\b', caseSensitive: false)
                .hasMatch(step.english),
            isFalse,
            reason: scenario.id);
        expect(step.oromo.toLowerCase(), isNot(contains('tuqi')),
            reason: scenario.id);
      }
    }
  });

  for (final kind in GameKind.values) {
    test(
        '${kind.name} derives every changed transfer from valid intermediate mathematics',
        () {
      final scenarios = scenariosFor(kind);
      expect(scenarios, hasLength(100));
      for (final scenario in scenarios) {
        final steps = workedSolution(scenario);
        expect(steps.length, inInclusiveRange(3, 5), reason: scenario.id);
        final math = steps.map(_math).toList();
        final n = _numbers(transferMath(scenario));
        int answer;
        switch (kind) {
          case GameKind.numberLine:
            answer = n[0] + n[1];
            expect(_numbers(math.first), n);
            expect(math[1], contains(n[1] < 0 ? ' - ' : ' + '));
            _assertEquation(math.last);
            if (n[0] < 0 || n[1] < 0) {
              expect(steps, hasLength(4));
              _assertEquation(math[2]);
              expect(_numbers(math[2]).last, answer.abs());
            }
            break;
          case GameKind.equalGroups:
          case GameKind.areaGrid:
          case GameKind.similarity:
            answer = n[0] * n[1];
            expect(_numbers(math.first), n);
            final sum = math[1]
                .split('=')[0]
                .split('+')
                .map((part) => int.parse(part.trim()))
                .toList();
            final copies = kind == GameKind.equalGroups ? n[0] : n[1];
            final each = kind == GameKind.equalGroups ? n[1] : n[0];
            expect(sum, List.filled(copies, each));
            _assertEquation(math[1]);
            _assertEquation(math.last.replaceFirst(RegExp(r'^A\s*=\s*'), ''));
            if (kind == GameKind.areaGrid) expect(math.last, endsWith('u²'));
            if (kind == GameKind.similarity) expect(math.last, endsWith('u'));
            break;
          case GameKind.sharing:
            answer = n[0] ~/ n[1];
            expect(_numbers(math.first), n);
            expect(math[1], '${n[1]} × ? = ${n[0]}');
            _assertEquation(math[2]);
            expect(_numbers(math[2]), [n[1], answer, n[0]]);
            _assertEquation(math.last);
            break;
          case GameKind.fractionTiles:
            answer = n[1];
            expect(math.first, '${n[0]} / ${n[1]}');
            expect(_numbers(math[1]), [n[1]]);
            expect(math.last, 'denominator = ${n[1]}');
            break;
          case GameKind.balance:
            answer = (n[2] - n[1]) ~/ n[0];
            expect(_numbers(math.first), n);
            final undo = math[1].split('=').last.trim();
            expect(undo, '${n[2]} - (${n[1]})');
            expect(_calculate(undo), n[2] - n[1]);
            expect(math[2], '${n[0]} × x = ${n[2] - n[1]}');
            final divide =
                math.last.split('=').skip(1).map((s) => s.trim()).toList();
            expect(divide.first, '${n[2] - n[1]} ÷ ${n[0]}');
            expect(_calculate(divide.first), answer);
            break;
          case GameKind.angleBuilder:
            answer = n[2] - n[0] - n[1];
            expect(_numbers(math.first), [n[0], n[1], n[0] + n[1]]);
            _assertEquation(math.first);
            _assertEquation(math[1]);
            expect(_numbers(math[1]), [180, n[0] + n[1], answer]);
            expect(math.last, endsWith('°'));
            break;
          case GameKind.volume:
            answer = n.reduce((a, b) => a * b);
            expect(_numbers(math.first), n);
            _assertEquation(math[1]);
            _assertEquation(math[2]);
            expect(_numbers(math[1]), [n[0], n[1], n[0] * n[1]]);
            expect(_numbers(math[2]), [n[0] * n[1], n[2], answer]);
            expect(math.last, endsWith('u³'));
            break;
          case GameKind.probability:
            answer = n[0] + n[1];
            expect(math.first, 'red = ${n[0]}');
            _assertEquation(math[1]);
            expect(_numbers(math[1]), [n[0], n[1], answer]);
            expect(math[2], 'P(🔴) = ${n[0]} / $answer');
            expect(math.last, 'outcomes = $answer');
            break;
          case GameKind.sets:
            answer = n.reduce((a, b) => a + b);
            expect(math.first, 'A ∩ B = ${n[1]}');
            expect(_numbers(math[1]), [n[0], n[2]]);
            _assertEquation(math[2]);
            expect(_numbers(math[2]), [...n, answer]);
            expect(math.last, 'A ∪ B = $answer');
            break;
          case GameKind.data:
            answer = n.reduce((a, b) => a + b) ~/ n.length;
            expect(_numbers(math.first), n);
            _assertEquation(math[1]);
            expect(_numbers(math[1]), [...n, n.reduce((a, b) => a + b)]);
            final divide =
                math.last.split('=').skip(1).map((s) => s.trim()).toList();
            expect(divide.first, '${n.reduce((a, b) => a + b)} ÷ 5');
            expect(_calculate(divide.first), answer);
            break;
        }
        expect(answer, scenario.transferAnswer, reason: scenario.id);
        expect(_finalAnswer(math.last), answer, reason: scenario.id);
      }
    });
  }

  test('solutions derive results even if stored answer metadata is wrong', () {
    for (final scenario in [
      ...buildScenarios(),
      ...discoveryActivities.map((a) => a.scenario)
    ]) {
      final altered = LearningScenario(
        id: scenario.id,
        kind: scenario.kind,
        level: scenario.level,
        values: scenario.values,
        goal: scenario.goal,
        explanation: scenario.explanation,
        transferPrompt: scenario.transferPrompt,
        transferAnswer: 987654,
      );
      expect(workedSolution(altered).map((s) => s.visual).toList(),
          workedSolution(scenario).map((s) => s.visual).toList(),
          reason: scenario.id);
    }
  });

  final discovery = {
    for (final activity in discoveryActivities)
      activity.scenario.id: activity.scenario
  };
  test('all discovery conclusions agree with independently calculated answers',
      () {
    final expected = {
      'discovery-fractionDivision': (5 * 6) ~/ (6 * 1),
      'discovery-signedProducts': (-4) * (-3),
      'discovery-ratio': (20 * 3) ~/ (3 + 2),
      'discovery-pythagoras': math.sqrt(6 * 6 + 8 * 8).toInt(),
      'discovery-circleAngles': 140 ~/ 2,
      'discovery-inequality': 12 ~/ (-3),
      'discovery-squareRoot': math.sqrt(49).toInt(),
      'discovery-congruence':
          ([13, 5, 12]..sort()).join(',') == ([5, 12, 13]..sort()).join(',')
              ? 1
              : 2,
      'discovery-englishNumbers': '● ● ●'.split(' ').length,
    };
    expect(expected.keys.toSet(), discovery.keys.toSet());
    for (final entry in discovery.entries) {
      expect(_finalAnswer(_math(workedSolution(entry.value).last)),
          expected[entry.key],
          reason: entry.key);
      expect(entry.value.transferAnswer, expected[entry.key],
          reason: entry.key);
    }
  });
  test('fraction division counts equal sixth-sized units', () {
    final steps = workedSolution(discovery['discovery-fractionDivision']!);
    expect(steps.length, inInclusiveRange(3, 5));
    final math = steps.map(_math).toList();
    expect(math.first, '5/6 = 5 × (1/6)');
    expect(math[1], '5/6 ÷ 1/6 = 5 ÷ 1');
    expect(_calculate(math[1].split('=').last), 5);
    expect(math.last, '5/6 ÷ 1/6 = 5');
  });
  test(
      'negative product removes a negative total rather than reusing construction chips',
      () {
    final steps = workedSolution(discovery['discovery-signedProducts']!);
    expect(steps, hasLength(4));
    final math = steps.map(_math).toList();
    for (final equation in math) {
      _assertEquation(equation);
    }
    expect(math.first, '4 × (-3) = -12');
    expect(math[1], '0 - (-12) = 0 + 12');
    expect(math.last, '(-4) × (-3) = 12');
  });
  test('ratio uses five parts and four complete ratio groups', () {
    final math =
        workedSolution(discovery['discovery-ratio']!).map(_math).toList();
    expect(math, ['3 + 2 = 5', '20 ÷ 5 = 4', '3 × 4 = 12']);
    for (final equation in math) {
      _assertEquation(equation);
    }
  });
  test(
      'right-triangle solution derives the nonnegative length from square areas',
      () {
    final math =
        workedSolution(discovery['discovery-pythagoras']!).map(_math).toList();
    expect(math, hasLength(5));
    expect(math.first, contains('90°'));
    expect(math[1], '6² = 36; 8² = 64');
    expect(math[2], 'c² = 36 + 64 = 100');
    expect(_calculate(math[2].split('=')[1]), 100);
    _assertEquation(math[3]);
    expect(math.last, 'c = √100 = 10 u');
  });
  test('circle angle halves the changed central angle on the same arc', () {
    final steps = workedSolution(discovery['discovery-circleAngles']!);
    expect(steps, hasLength(3));
    expect(_math(steps.first), '∠AOB = 2 × ∠APB');
    expect(steps.first.english, contains('same arc'));
    _assertEquation(_math(steps[1]));
    expect(_math(steps[1]), '140° ÷ 2 = 70°');
    expect(_math(steps.last), '∠APB = 70°');
  });
  test('negative inequality reverses order and excludes its boundary', () {
    final steps = workedSolution(discovery['discovery-inequality']!);
    expect(steps, hasLength(4));
    expect(_math(steps.first), '-3x < 12');
    expect(_math(steps[1]), '÷(-3): < → >');
    _assertEquation(_math(steps[2]));
    expect(_math(steps[2]), '12 ÷ (-3) = -4');
    expect(_math(steps.last), 'x > -4');
    expect(steps.last.english, contains('excluded'));
  });
  test('principal root checks a square and nonnegative sign', () {
    final math =
        workedSolution(discovery['discovery-squareRoot']!).map(_math).toList();
    expect(math, hasLength(4));
    expect(math.first, contains('≥ 0'));
    _assertEquation(math[1]);
    expect(math[1], '7 × 7 = 49');
    expect(math[2], '7 ≥ 0');
    expect(math.last, '√49 = 7');
  });
  test('congruence compares side sets and rejects the scaled option', () {
    final steps = workedSolution(discovery['discovery-congruence']!);
    expect(steps, hasLength(4));
    expect(_numbers(_math(steps.first)), [5, 12, 13]);
    expect(_math(steps[1]), '①: 13, 5, 12 → 5, 12, 13');
    expect(_math(steps[2]), '②: 26, 10, 24 = 2 × (13, 5, 12)');
    expect(steps[2].english, contains('size'));
    expect(_finalAnswer(_math(steps.last)), 1);
  });
  test('English THREE connects printed recognition to three counted dots', () {
    final steps = workedSolution(discovery['discovery-englishNumbers']!);
    expect(steps, hasLength(3));
    expect(_math(steps.first), 'THREE ↔ ● ● ●');
    expect(_math(steps[1]), '● ● ● → 1 + 1 + 1 = 3');
    _assertEquation(_math(steps[1]).split('→').last);
    expect(_math(steps.last), 'THREE = 3');
  });
}

String _math(LessonInstruction step) =>
    step.visual.replaceFirst(RegExp(r'^\d+\.\s*'), '').replaceAll('−', '-');
List<int> _numbers(String text) => RegExp(r'-?\d+')
    .allMatches(text.replaceAll('−', '-'))
    .map((match) => int.parse(match.group(0)!))
    .toList();
int _finalAnswer(String text) => int.parse(
    RegExp(r'[=>]\s*(-?\d+)(?:\s*u[²³]?|°)?$').firstMatch(text)!.group(1)!);
void _assertEquation(String text) {
  final parts = text.split('=');
  expect(parts.length, greaterThanOrEqualTo(2));
  final values = parts.map(_calculate).toList();
  expect(values.every((value) => value == values.first), isTrue, reason: text);
}

// Independent integer expression evaluator verifies displayed intermediate
// arithmetic, including unary signs and parentheses, rather than answer echoes.
int _calculate(String text) {
  final source = text
      .replaceAll('−', '-')
      .replaceAll('°', '')
      .replaceAll(RegExp(r'\s*u[²³]?\s*$'), '')
      .replaceAll(' ', '');
  final tokens = RegExp(r'\d+|[()+\-×÷]')
      .allMatches(source)
      .map((match) => match.group(0)!)
      .toList();
  expect(tokens.join(), source,
      reason: 'Unsupported numeric expression: $text');
  var index = 0;
  late int Function() expression;
  int factor() {
    final token = tokens[index++];
    if (token == '-') return -factor();
    if (token == '+') return factor();
    if (token == '(') {
      final value = expression();
      expect(tokens[index++], ')');
      return value;
    }
    return int.parse(token);
  }

  int product() {
    var value = factor();
    while (index < tokens.length &&
        (tokens[index] == '×' || tokens[index] == '÷')) {
      final operation = tokens[index++];
      final right = factor();
      if (operation == '÷') {
        expect(value % right, 0);
        value ~/= right;
      } else {
        value *= right;
      }
    }
    return value;
  }

  expression = () {
    var value = product();
    while (index < tokens.length &&
        (tokens[index] == '+' || tokens[index] == '-')) {
      final operation = tokens[index++];
      final right = product();
      value = operation == '+' ? value + right : value - right;
    }
    return value;
  };
  final result = expression();
  expect(index, tokens.length);
  return result;
}
