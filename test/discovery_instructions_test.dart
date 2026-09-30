import 'package:flutter_test/flutter_test.dart';
import 'package:nested_nav/learning/discovery_instructions.dart';

void main() {
  const discoveries = [
    'fractionDivision',
    'signedProducts',
    'ratio',
    'pythagoras',
    'circleAngles',
    'inequality',
    'squareRoot',
    'congruence',
    'englishNumbers',
  ];

  test('every discovery has short bilingual steps with visual cues', () {
    for (final discovery in discoveries) {
      final steps = discoveryInstructions('discovery-$discovery');
      expect(steps.length, inInclusiveRange(3, 5), reason: discovery);
      for (final step in steps) {
        expect(step.oromo.trim(), isNotEmpty, reason: discovery);
        expect(step.english.trim(), isNotEmpty, reason: discovery);
        expect(step.visual.trim(), isNotEmpty, reason: discovery);
        expect(step.english.length, lessThanOrEqualTo(160), reason: discovery);
        expect(step.oromo.length, lessThanOrEqualTo(160), reason: discovery);
      }
    }
  });

  test('ordinary and unknown scenarios receive no discovery instructions', () {
    expect(discoveryInstructions('unknown'), isEmpty);
    expect(discoveryInstructions('area-001'), isEmpty);
  });
}
