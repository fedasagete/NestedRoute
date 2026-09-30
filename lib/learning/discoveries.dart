import 'package:flutter/material.dart';
import 'scenarios.dart';

/// Fixed discovery constructions are separate from the 1,200 generated rounds.
class DiscoveryActivity {
  const DiscoveryActivity(
      {required this.scenario,
      required this.oromo,
      required this.english,
      required this.icon,
      required this.color,
      required this.goalMath,
      required this.definitionMath,
      required this.transferMath,
      this.transferDirection});
  final LearningScenario scenario;
  final String oromo, english, goalMath, definitionMath, transferMath;
  final IconData icon;
  final Color color;
  final String? transferDirection;
}

const discoveryActivities = <DiscoveryActivity>[
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-fractionDivision',
          kind: GameKind.fractionTiles,
          level: 3,
          values: {},
          goal:
              'Split quarters into eighths. Fit eighth-sized pieces inside three quarters.',
          explanation:
              'Six eighths fit into three quarters. Dividing asks how many of the smaller pieces fit.',
          transferPrompt: 'How many sixths fit into five sixths?',
          transferAnswer: 5,
          sourceGrade: 8,
          sourcePage: 35),
      oromo: 'Firaakshinii • Hiruu',
      english: 'Divide fractions',
      icon: Icons.view_quilt_rounded,
      color: Color(0xff8671aa),
      goalMath: '3/4 ÷ 1/8 = ?',
      definitionMath: '3/4 = 6/8\n6 × 1/8 = 3/4\n3/4 ÷ 1/8 = 6',
      transferMath: '5/6 ÷ 1/6 = ?'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-signedProducts',
          kind: GameKind.equalGroups,
          level: 3,
          values: {},
          goal:
              'Make six zero pairs. Remove three groups of two negative chips.',
          explanation:
              'Each positive and negative pair has value zero. Removing a negative group raises the value. Three removals of minus two leave plus six.',
          transferPrompt:
              'Remove four groups of minus three. What is the value?',
          transferAnswer: 12,
          sourceGrade: 7,
          sourcePage: 42),
      oromo: 'Baay’isuu • −',
      english: 'Multiply negatives',
      icon: Icons.exposure_rounded,
      color: Color(0xffba713e),
      goalMath: '−3 × (−2) = ?',
      definitionMath: '0 − (−2) = +2\n0 − 3 × (−2) = +6\n(−3) × (−2) = +6',
      transferMath: '(−4) × (−3) = ?'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-ratio',
          kind: GameKind.similarity,
          level: 2,
          values: {},
          goal:
              'Make ten items in a two-to-three mixture. Each group needs two amber and three blue items.',
          explanation:
              'One group has five items. Ten items make two groups: four amber and six blue. Both parts scale by the same factor.',
          transferPrompt:
              'A three-to-two mixture has twenty items. How many are in the first part?',
          transferAnswer: 12,
          sourceGrade: 7,
          sourcePage: 55),
      oromo: 'Reeshoo',
      english: 'Ratio mixtures',
      icon: Icons.bubble_chart_rounded,
      color: Color(0xff4c8e93),
      goalMath: '🟡 : 🔵 = 2 : 3\n🟡 + 🔵 = 10',
      definitionMath: '2 + 3 = 5\n10 ÷ 5 = 2\n2 × (2 : 3) = 4 : 6',
      transferMath: '🟡 : 🔵 = 3 : 2\n🟡 + 🔵 = 20\n🟡 = ?'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-pythagoras',
          kind: GameKind.areaGrid,
          level: 3,
          values: {},
          goal:
              'Move the nine and sixteen square units into the square on the longest side.',
          explanation:
              'For a right triangle, the squares on the two shorter sides together have the same area as the square on the hypotenuse.',
          transferPrompt:
              'A right triangle has shorter sides six and eight. Find the hypotenuse.',
          transferAnswer: 10,
          sourceGrade: 8,
          sourcePage: 135),
      oromo: 'Paayitaagoras',
      english: 'Pythagoras',
      icon: Icons.square_foot_rounded,
      color: Color(0xffdc8b3f),
      goalMath: '3² + 4² = ?²',
      definitionMath: '9 + 16 = 25\n3² + 4² = 5²\n∠C = 90°\na² + b² = c²',
      transferMath: '∠C = 90°\n6² + 8² = ?²'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-circleAngles',
          kind: GameKind.angleBuilder,
          level: 3,
          values: {},
          goal:
              'Move the point along the same arc. Match the angle on the circle to the central angle.',
          explanation:
              'An angle at the circumference is half the central angle standing on the same arc. Moving the point along the same arc preserves that angle.',
          transferPrompt:
              'The central angle is one hundred and forty degrees. Find the angle on the circle standing on the same arc.',
          transferAnswer: 70,
          sourceGrade: 8,
          sourcePage: 157),
      oromo: 'Kofa • Geengoo',
      english: 'Circle angles',
      icon: Icons.circle_outlined,
      color: Color(0xffb1778b),
      goalMath: '100° → ?°',
      definitionMath: '100° ÷ 2 = 50°\n∠AOB = 2 × ∠APB',
      transferMath: '∠AOB = 140°\n∠APB = ?°'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-inequality',
          kind: GameKind.numberLine,
          level: 3,
          values: {},
          goal:
              'Reflect the number line by a negative scale. Choose the boundary, side and open endpoint, then test two values.',
          explanation:
              'Dividing by a negative number reverses order. Minus two x less than six becomes x greater than minus three. The endpoint is open because equality is excluded.',
          transferPrompt:
              'Solve minus three x less than twelve. Choose the sign and boundary.',
          transferAnswer: -4,
          sourceGrade: 8,
          sourcePage: 87),
      oromo: 'Hima walcaalmaa',
      english: 'Inequalities',
      icon: Icons.compare_arrows_rounded,
      color: Color(0xff377e6c),
      goalMath: '−2x < 6\nx : ?',
      definitionMath: '−2x < 6\nx > −3\n0 ✓   −4 ✗',
      transferMath: '−3x < 12\nx  ⋯  ?',
      transferDirection: '>'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-squareRoot',
          kind: GameKind.areaGrid,
          level: 2,
          values: {},
          goal:
              'Arrange twenty-five unit tiles into a square. Keep every tile and compare the two equal sides.',
          explanation:
              'Five rows of five make twenty-five. The square root is the nonnegative side length: five. Solving x squared equals twenty-five is a different question with two answers, plus or minus five.',
          transferPrompt: 'What is the principal square root of forty-nine?',
          transferAnswer: 7,
          sourceGrade: 8,
          sourcePage: 54),
      oromo: 'Hundee iskuweerii',
      english: 'Square roots',
      icon: Icons.grid_on_rounded,
      color: Color(0xff8671aa),
      goalMath: '25 □ → ? × ?',
      definitionMath: '5 × 5 = 25\n√25 = 5 ≥ 0\nx² = 25 ⇒ x = ±5',
      transferMath: '√49 = ?'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-congruence',
          kind: GameKind.similarity,
          level: 2,
          values: {},
          goal:
              'Move and rotate the triangle to cover its partner exactly. Check whether changing scale still covers it.',
          explanation:
              'Moving and rotating preserve side lengths. Congruent triangles have the same size and shape. Equal corresponding sides give the SSS test; scaling changes size even when the angles stay the same.',
          transferPrompt:
              'Which triangle is congruent to a triangle with sides five, twelve and thirteen: option one has thirteen, five, twelve; option two has twenty-six, ten, twenty-four?',
          transferAnswer: 1,
          sourceGrade: 7,
          sourcePage: 174),
      oromo: 'Walqixxaatina',
      english: 'Congruent triangles',
      icon: Icons.change_history_rounded,
      color: Color(0xff6b88b5),
      goalMath: '△ 3, 4, 5   ≅   △ ?',
      definitionMath: '3 = 3   4 = 4   5 = 5\nRRR / SSS\n△ ≅ △',
      transferMath: '△ : 5, 12, 13\n① : 13, 5, 12\n② : 26, 10, 24\n≅ : ?'),
  DiscoveryActivity(
      scenario: LearningScenario(
          id: 'discovery-englishNumbers',
          kind: GameKind.numberLine,
          level: 1,
          values: {},
          goal:
              'Look at each printed English word, its number and dots. Then match the words after their order changes.',
          explanation:
              'These four printed words name the numbers one through four. Recognising a word is a first step; pronunciation and broader reading need further teaching and reviewed recordings.',
          transferPrompt: 'What number does THREE name?',
          transferAnswer: 3),
      oromo: 'English • Lakkoofsa',
      english: 'English number words',
      icon: Icons.abc_rounded,
      color: Color(0xff728854),
      goalMath: '1   2   3   4\nABC ↔ 123',
      definitionMath: 'ONE = 1\nTWO = 2\nTHREE = 3\nFOUR = 4',
      transferMath: 'THREE = ?'),
];

DiscoveryActivity? discoveryFor(String id) {
  for (final activity in discoveryActivities) {
    if (activity.scenario.id == id) return activity;
  }
  return null;
}
