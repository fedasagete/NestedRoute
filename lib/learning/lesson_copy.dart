import 'package:flutter/material.dart';
import 'scenarios.dart';
import 'discoveries.dart';

class TopicCopy {
  const TopicCopy(this.oromo, this.english, this.icon, this.color);
  final String oromo, english;
  final IconData icon;
  final Color color;
}

const topics = {
  GameKind.numberLine: TopicCopy('Ida’uu • Hir’isuu', 'Add & subtract',
      Icons.route_rounded, Color(0xff377e6c)),
  GameKind.equalGroups: TopicCopy(
      'Baay’isuu', 'Equal groups', Icons.grid_view_rounded, Color(0xffba713e)),
  GameKind.sharing: TopicCopy(
      'Hiruu', 'Share equally', Icons.people_alt_rounded, Color(0xff728854)),
  GameKind.fractionTiles: TopicCopy(
      'Firaakshinii', 'Fractions', Icons.view_quilt_rounded, Color(0xff8671aa)),
  GameKind.balance: TopicCopy('Hima walqixaa', 'Balance equations',
      Icons.balance_rounded, Color(0xff4b83a0)),
  GameKind.areaGrid:
      TopicCopy('Bal’ina', 'Area', Icons.texture_rounded, Color(0xffdc8b3f)),
  GameKind.angleBuilder: TopicCopy('Kofa', 'Triangle angles',
      Icons.change_history_rounded, Color(0xffb1778b)),
  GameKind.similarity: TopicCopy('Walfakkaatina', 'Similar shapes',
      Icons.aspect_ratio_rounded, Color(0xff6b88b5)),
  GameKind.volume:
      TopicCopy('Qabee', 'Volume', Icons.layers_rounded, Color(0xff4c8e93)),
  GameKind.probability: TopicCopy('Carraa ta’uumsaa', 'Probability',
      Icons.casino_rounded, Color(0xffb77750)),
  GameKind.sets:
      TopicCopy('Tuutota', 'Sets', Icons.hub_rounded, Color(0xff85825b)),
  GameKind.data: TopicCopy(
      'Gatii giddu galaa', 'Mean', Icons.bar_chart_rounded, Color(0xff8283a7)),
};

TopicCopy topicFor(LearningScenario scenario) {
  final discovery = discoveryFor(scenario.id);
  return discovery == null
      ? topics[scenario.kind]!
      : TopicCopy(
          discovery.oromo, discovery.english, discovery.icon, discovery.color);
}

// Numerical representation keeps English literacy out of the mathematical task.
String goalMath(LearningScenario s) {
  final discovery = discoveryFor(s.id);
  if (discovery != null) return discovery.goalMath;
  final v = s.values;
  switch (s.kind) {
    case GameKind.numberLine:
      return '${v['start']} ${v['delta']! < 0 ? '−' : '+'} ${v['delta']!.abs()} = ?';
    case GameKind.equalGroups:
      return '${v['groups']} × ${v['each']}';
    case GameKind.sharing:
      return '${v['total']} ÷ ${v['people']}';
    case GameKind.fractionTiles:
      return '${v['selected']} / ${v['parts']}';
    case GameKind.balance:
      return '${v['factor']} × ? + (${v['offset']}) = ${v['factor']! * v['solution']! + v['offset']!}';
    case GameKind.areaGrid:
      return '${v['width']} × ${v['height']}   □';
    case GameKind.angleBuilder:
      return '${v['a']}° + ${v['b']}° + ?° = 180°';
    case GameKind.similarity:
      return '${v['width']} × ${v['height']}   →   × ${v['scale']}';
    case GameKind.volume:
      return '${v['width']} × ${v['depth']} × ${v['height']}   ▧';
    case GameKind.probability:
      return 'P(🔴) = ? / ?';
    case GameKind.sets:
      return 'A ∩ B    •    A ∪ B';
    case GameKind.data:
      return '(${v.values.join(' + ')}) ÷ 5';
  }
}

String definitionMath(LearningScenario s) {
  final discovery = discoveryFor(s.id);
  if (discovery != null) return discovery.definitionMath;
  final v = s.values;
  switch (s.kind) {
    case GameKind.numberLine:
      return goalMath(s).replaceAll('?', '${v['start']! + v['delta']!}');
    case GameKind.equalGroups:
      return '${goalMath(s)} = ${v['groups']! * v['each']!}';
    case GameKind.sharing:
      return '${goalMath(s)} = ${v['total']! ~/ v['people']!}';
    case GameKind.fractionTiles:
      return '${v['selected']} / ${v['parts']}\nWaamamaa: ${v['selected']}\nWaamsisaa: ${v['parts']}';
    case GameKind.balance:
      return '${goalMath(s).replaceAll('?', '${v['solution']}')}\nx = ${v['solution']}';
    case GameKind.areaGrid:
      return 'A = ${v['width']} × ${v['height']} = ${v['width']! * v['height']!}';
    case GameKind.angleBuilder:
      return '${v['a']}° + ${v['b']}° + ${180 - v['a']! - v['b']!}° = 180°';
    case GameKind.similarity:
      return '${v['width']} × ${v['height']} → ${v['width']! * v['scale']!} × ${v['height']! * v['scale']!}';
    case GameKind.volume:
      return 'V = ${v['width']} × ${v['depth']} × ${v['height']} = ${v['width']! * v['depth']! * v['height']!}';
    case GameKind.probability:
      return 'P(🔴) = ${v['red']} / ${v['red']! + v['blue']!}';
    case GameKind.sets:
      return 'A ∩ B: ${v['shared']}\nA ∪ B: ${v['aOnly']! + v['shared']! + v['bOnly']!}';
    case GameKind.data:
      return '(${v.values.join(' + ')}) ÷ 5 = ${v.values.reduce((a, b) => a + b) ~/ 5}';
  }
}

String transferMath(LearningScenario s) {
  final discovery = discoveryFor(s.id);
  if (discovery != null) return discovery.transferMath;
  final v = s.values;
  switch (s.kind) {
    case GameKind.numberLine:
      return '${v['start']! + 1} + (${v['delta']}) = ?';
    case GameKind.equalGroups:
      return '${v['groups']! + 1} × ${v['each']} = ?';
    case GameKind.sharing:
      return '${v['total']! + v['people']!} ÷ ${v['people']} = ?';
    case GameKind.fractionTiles:
      return '${v['selected']! + 1} / ${v['parts']! + 1}\nWaamsisaa = ?';
    case GameKind.balance:
      final off = v['offset']! + (v['offset']! < 0 ? -1 : 1);
      return '${v['factor']} × ? + ($off) = ${v['factor']! * (v['solution']! + 1) + off}';
    case GameKind.areaGrid:
      return '${v['width']! + 1} × ${v['height']} = ?';
    case GameKind.angleBuilder:
      return '${v['a']! + 1}° + ${v['b']}° + ?° = 180°';
    case GameKind.similarity:
      return '${v['width']! + 1} × ${v['scale']} = ?';
    case GameKind.volume:
      return '${v['width']! + 1} × ${v['depth']} × ${v['height']} = ?';
    case GameKind.probability:
      return '🔴 ${v['red']! + 1} + 🔵 ${v['blue']! + 1} = ?';
    case GameKind.sets:
      return 'A∖B: ${v['aOnly']! + 1}   A∩B: ${v['shared']}   B∖A: ${v['bOnly']! + 1}\nA∪B = ?';
    case GameKind.data:
      return '${v.values.toList().reversed.map((n) => n + 1).join(', ')}\nGatii giddu galaa = ?';
  }
}
