import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/board_instructions.dart';
import 'package:nested_nav/learning/scenarios.dart';

LearningScenario fixture(GameKind kind, Map<String, int> values) =>
    LearningScenario(
      id: 'copy-check',
      kind: kind,
      level: 1,
      values: values,
      goal: '',
      explanation: '',
      transferPrompt: 'TRANSFER_ONLY_MARKER',
      transferAnswer: 987654321,
    );

void main() {
  test(
      'all catalogue boards have short bilingual actions and a final meaning step',
      () {
    for (final scenario in buildScenarios()) {
      final steps = boardInstructions(scenario);
      expect(steps.length, 4, reason: scenario.kind.name);
      for (final step in steps) {
        expect(step.oromo.trim(), isNotEmpty);
        expect(step.english.trim(), isNotEmpty);
        expect(step.visual.trim(), isNotEmpty);
        expect(step.oromo.split(RegExp(r'\s+')).length, lessThanOrEqualTo(25));
        expect(
            step.english.split(RegExp(r'\s+')).length, lessThanOrEqualTo(25));
      }
      expect(steps.last.english, isNot(steps.first.english));
    }
  });

  test(
      'number line instructions name the actual direction and one-unit control',
      () {
    final add = boardInstructions(
        fixture(GameKind.numberLine, {'start': 4, 'delta': 3}));
    final subtract = boardInstructions(
        fixture(GameKind.numberLine, {'start': 8, 'delta': -2}));
    expect(add[1].english, contains('right'));
    expect(add[1].visual, contains('+1'));
    expect(subtract[1].english, contains('left'));
    expect(subtract[1].visual, contains('−1'));
    expect(add[0].oromo, contains('4'));
    expect(subtract[2].oromo, contains('2'));
    expect(subtract.last.english.toLowerCase(), contains('subtract'));
  });

  test(
      'probability teaches a fixed bag and possible outcomes rather than filling or trial frequency',
      () {
    final steps =
        boardInstructions(fixture(GameKind.probability, {'red': 3, 'blue': 5}));
    final copy = steps.map((s) => s.english).join(' ').toLowerCase();
    expect(copy, isNot(contains('fill')));
    expect(steps[1].english, contains('Yaali'));
    expect(steps[2].english, contains('top'));
    expect(steps[2].english, contains('bottom'));
    expect(steps[2].visual, contains('3 / 8'));
    expect(steps.last.english, contains('possible outcomes'));
  });

  test('mean instructions explain the ordered two-tap move and equal share',
      () {
    final steps = boardInstructions(
        fixture(GameKind.data, {'a': 2, 'b': 6, 'c': 3, 'd': 5, 'e': 4}));
    expect(steps[0].english, contains('more'));
    expect(steps[1].english, contains('less'));
    expect(steps[1].english, contains('one'));
    expect(steps[2].english, contains('five'));
    expect(steps.last.english.toLowerCase(), contains('mean'));
  });

  test('set controls use the actual shape and colour membership rules', () {
    final steps = boardInstructions(
        fixture(GameKind.sets, {'aOnly': 2, 'shared': 3, 'bOnly': 4}));
    expect(steps[0].english.toLowerCase(), contains('tap'));
    expect(steps[1].visual, contains('●🟠 → A ∖ B'));
    expect(steps[2].visual, contains('●🔵 → A ∩ B'));
    expect(steps[2].visual, contains('★🔵 → B ∖ A'));
    expect(steps.last.english, contains('both'));
  });

  test(
      'construction copy interpolates parameters and never reads separate transfer answers',
      () {
    for (final original
        in buildScenarios().where((s) => s.id.endsWith('001'))) {
      final scenario = fixture(original.kind, original.values);
      final copy = boardInstructions(scenario)
          .map((step) => '${step.oromo} ${step.english} ${step.visual}')
          .join(' ');
      expect(copy, isNot(contains('TRANSFER_ONLY_MARKER')));
      expect(copy, isNot(contains('987654321')));
    }
    final groups = boardInstructions(
        fixture(GameKind.equalGroups, {'groups': 4, 'each': 3}));
    expect(groups[0].oromo, contains('4'));
    expect(groups[2].oromo, contains('3'));
    final balance = boardInstructions(
        fixture(GameKind.balance, {'factor': 2, 'offset': -3, 'solution': 4}));
    expect(balance[0].visual, contains('2 × ? − 3 = 5'));
  });

  test('final steps explain mathematics in words, not a fourth button command',
      () {
    const concepts = {
      GameKind.numberLine: 'adds',
      GameKind.equalGroups: 'Multiplication',
      GameKind.sharing: 'Division',
      GameKind.fractionTiles: 'numerator',
      GameKind.balance: 'equation',
      GameKind.areaGrid: 'Area',
      GameKind.angleBuilder: '180',
      GameKind.similarity: 'scale',
      GameKind.volume: 'Volume',
      GameKind.probability: 'possible outcomes',
      GameKind.sets: 'both',
      GameKind.data: 'mean',
    };
    for (final kind in GameKind.values) {
      final definition = boardInstructions(scenariosFor(kind).first).last;
      expect(definition.english.toLowerCase(),
          contains(concepts[kind]!.toLowerCase()));
      expect(definition.oromo.split(RegExp(r'\s+')).length, greaterThan(3));
    }
  });
}
