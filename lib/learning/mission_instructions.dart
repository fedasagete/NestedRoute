import 'board_instructions.dart';
import 'lesson_instruction.dart';
import 'scenarios.dart';

/// Optional instructions describe the actual objects rather than a number line.
List<LessonInstruction> missionInstructions(LearningScenario s) {
  final v = s.values;
  switch (s.kind) {
    case GameKind.numberLine:
      final start = v['start']!, target = start + v['delta']!;
      return [
        LessonInstruction(
            oromo: 'Muuzii $start qabna. Namni muuzii $target barbaada.',
            english: 'We have $start bananas. The customer wants $target.',
            visual: '$start → $target'),
        LessonInstruction(
            oromo: 'Muuzii tokko tuqi; qodaa keessa seena.',
            english: 'Tap a loose banana. It moves into the basket.',
            visual: '$start → ${start + 1}'),
        const LessonInstruction(
            oromo: 'Bakka duwwaa guuti. Deebisuuf −1 tuqi.',
            english: 'Fill the empty places. Tap −1 to undo a move.',
            visual: '□ → ●'),
        LessonInstruction(
            oromo: 'Muuzii walitti qabuu jechuun ida’uu dha.',
            english:
                'Adding combines the bananas already there with the new ones.',
            visual: '$start + ${v['delta']} = $target'),
      ];
    case GameKind.equalGroups:
      return [
        LessonInstruction(
            oromo:
                'Gareewwan ${v['groups']} guuti. Tokkoon tokkoon isaanii muuzii ${v['each']} qabaatu.',
            english:
                'Fill ${v['groups']} baskets with ${v['each']} bananas in each.',
            visual: '${v['groups']} × [${v['each']}]'),
        const LessonInstruction(
            oromo: 'Muuzii tuqii garee keessa kaa’i.',
            english: 'Tap a banana, then tap a basket to put it there.',
            visual: '● → ▱'),
        const LessonInstruction(
            oromo: 'Garee hunda walqixa guuti. Muuzii tuquun deebisi.',
            english:
                'Make the baskets match. Tap a placed banana to return it.',
            visual: '▱ = ▱'),
        boardInstructions(s).last,
      ];
    case GameKind.sharing:
      return [
        LessonInstruction(
            oromo:
                'Muuzii ${v['total']} namoota ${v['people']} gidduutti walqixa hirii.',
            english:
                'Share ${v['total']} bananas equally among ${v['people']} people.',
            visual: '${v['total']} → ${v['people']}'),
        const LessonInstruction(
            oromo: 'Saanii tokko tuqi; muuzii tokko itti dabali.',
            english: 'Tap a plate to add one banana.',
            visual: '● → ◯'),
        const LessonInstruction(
            oromo: 'Hunda walqixa godhi. Baay’ate muuzii tuqii deebisi.',
            english:
                'Give everyone the same amount. Tap extra fruit to return it.',
            visual: '◯ = ◯'),
        boardInstructions(s).last,
      ];
    default:
      return boardInstructions(s);
  }
}
