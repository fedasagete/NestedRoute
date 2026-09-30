import 'lesson_instruction.dart';
import 'scenarios.dart';

/// Short control instructions followed by the meaning of the construction.
/// Oromo is learner copy; matching English supports translation review.
/// These steps use construction parameters, never the separate transfer task.
List<LessonInstruction> boardInstructions(LearningScenario scenario) {
  final v = scenario.values;
  switch (scenario.kind) {
    case GameKind.numberLine:
      final start = v['start']!;
      final delta = v['delta']!;
      final adds = delta > 0;
      return List.unmodifiable([
        _step(
            'Lakkoofsa $start irraa jalqabi.', 'Start at $start.', '$start →'),
        _step(
            adds ? 'Gara mirgaatti +1 tuqi.' : 'Gara bitaatti −1 tuqi.',
            adds
                ? 'Tap +1 to move right one place.'
                : 'Tap −1 to move left one place.',
            adds ? '$start → +1 → ${start + 1}' : '${start - 1} ← −1 ← $start'),
        _step(
            'Tarkaanfii ${delta.abs()} deemi; dogoggorte gara faallaatti deebi’i.',
            'Move ${delta.abs()} places; use the opposite arrow to correct a move.',
            '${delta.abs()} × ${adds ? '+1 →' : '← −1'}'),
        _step(
            'Gara mirgaatti deemu ida’uu dha; gara bitaatti deemu hir’isuu dha.',
            'Moving right adds; moving left subtracts.',
            '$start ${adds ? '+' : '−'} ${delta.abs()} = ${start + delta}'),
      ]);
    case GameKind.equalGroups:
      final groups = v['groups']!;
      final each = v['each']!;
      return List.unmodifiable([
        _step('Gareewwan $groups ilaali.', 'Look at the $groups baskets.',
            '▱ × $groups'),
        _step('Garee tokko jalatti + tuqi; tokko itti dabali.',
            'Tap + under a basket to add one counter.', '+ → ●'),
        _step(
            'Garee hunda keessa $each kaa’i; baay’ate − tuqi.',
            'Put $each in every basket; tap − to remove an extra counter.',
            '▱ : $each ●'),
        _step(
            'Baay’isuu jechuun hamma walqixa irra deddeebi’anii ida’uu dha.',
            'Multiplication adds the same amount in each equal group.',
            '$groups × $each = ${groups * each}'),
      ]);
    case GameKind.sharing:
      final total = v['total']!;
      final people = v['people']!;
      return List.unmodifiable([
        _step(
            'Wantoota $total namoota $people’f qoodi.',
            'Share the $total counters among $people people.',
            '$total □ → $people ☺'),
        _step(
            'Nama tokko jalatti + tuqi; wanti tokko isaaf darba.',
            'Tap + under a person to move one counter from the supply.',
            '□ → + → ☺'),
        _step(
            'Hundaaf walqixa kenni; wanta hafe hin dhiisin. Dogoggorte − tuqi.',
            'Give everyone equal amounts, use the whole supply, and tap − to return a counter.',
            '☺ = ☺   □ → 0'),
        _step(
            'Hiruun wantoota gareewwan walqixa ta’aniif qooduu dha.',
            'Division shares a quantity into equal groups.',
            '$total ÷ $people = ${total ~/ people}'),
      ]);
    case GameKind.fractionTiles:
      final parts = v['parts']!;
      final selected = v['selected']!;
      return List.unmodifiable([
        _step('Kutaa walqixa $parts keessaa $selected halluu dibi.',
            'Shade $selected of the $parts equal parts.', '$selected / $parts'),
        _step('Kutaa tokko tuqi; halluun ni jijjiirama.',
            'Tap a tile to shade it.', '□ → ☝ → ■'),
        _step(
            'Kutaa $selected filadhu; haquuf irra deebi’ii tuqi.',
            'Select $selected tiles; tap a shaded tile again to clear it.',
            '■ → ☝ → □'),
        _step(
            'Lakkoofsi gubbaa kutaa dibame; jalaa kutaa hunda lakkaa’a.',
            'The numerator counts shaded parts; the denominator counts all equal parts.',
            '$selected ■ / $parts □'),
      ]);
    case GameKind.balance:
      final factor = v['factor']!;
      final offset = v['offset']!;
      final target = factor * v['solution']! + offset;
      final term = offset < 0 ? '− ${offset.abs()}' : '+ $offset';
      return List.unmodifiable([
        _step(
            'Gara mirgaatti $target jiru; gama bitaa ilaali.',
            'Look at the two pans; the right side has value $target.',
            '$factor × ? $term = $target'),
        _step(
            '+ tuqi; saanduqa hunda keessatti tokko dabali.',
            'Tap + to increase the amount in every bag by one.',
            '$factor ▱ : x → x + 1'),
        _step(
            'Gama lamaan walqixa taasisi; hir’isuuf − tuqi.',
            'Make the pan values equal; tap − to decrease the amount in each bag.',
            '⚖   ← − / + →'),
        _step(
            'Hima walqixaa keessatti gama lamaan gatii walqixa qabu.',
            'An equation means both sides have the same value.',
            '⚖   $factor × x $term = $target'),
      ]);
    case GameKind.areaGrid:
      final width = v['width']!;
      final height = v['height']!;
      return List.unmodifiable([
        _step('Rogoota $width fi $height ilaali.',
            'Look at the $width by $height rectangle.', '$width ↔   $height ↕'),
        _step('Iskuweerii adii tokko tuqi; halluu itti dibi.',
            'Tap a white unit square to cover it.', '□ → ☝ → ■'),
        _step('Iskuweerota hunda tuqi; tokkoon tokkoon isaanii 1 dha.',
            'Cover every square; each square counts as one.', '1 □ + 1 □ + …'),
        _step(
            'Bal’inni iskuweerota xixiqqoo keessaa jiran lakkaa’a.',
            'Area counts the unit squares covering the inside.',
            '$width × $height = ${width * height} □'),
      ]);
    case GameKind.angleBuilder:
      final a = v['a']!;
      final b = v['b']!;
      return List.unmodifiable([
        _step('Kofoota $a° fi $b° ilaali.',
            'Look at the two given angles, $a° and $b°.', '$a° + $b° + ?°'),
        _step('Sarara jalaa irratti harkisi; kofa jijjiiri.',
            'Drag the bottom slider to change the third angle.', '☝ ───●───'),
        _step(
            '+ fi − fayyadami; waliigala 180° taasisi.',
            'Use + or − for small changes; make the total 180°.',
            '$a° + $b° + ?° = 180°'),
        _step(
            'Kofoon rogsadee sadan walitti ida’amanii 180° ta’u.',
            'The three angles of a triangle add to 180°, a straight angle.',
            '△ → ─   180°'),
      ]);
    case GameKind.similarity:
      final width = v['width']!;
      final height = v['height']!;
      final scale = v['scale']!;
      return List.unmodifiable([
        _step(
            'Rogoota $width fi $height, mallattoo ×$scale ilaali.',
            'Look at both original sides and the ×$scale scale factor.',
            '$width × $height   →   ×$scale'),
        _step(
            '↔ jalatti + fi − tuqi; roga dalgaa jijjiiri.',
            'Use + and − beside ↔ to change the horizontal side.',
            '$width → $width × $scale'),
        _step(
            '↕ jalatti + fi − tuqi; roga olee illee ×$scale taasisi.',
            'Use + and − beside ↕ to scale the vertical side by $scale too.',
            '$height → $height × $scale'),
        _step(
            'Danaa guddisuuf rogoota hunda lakkoofsa tokkoon baay’isi.',
            'Similar shapes use the same scale factor on every side.',
            '↔ ×$scale   ↕ ×$scale'),
      ]);
    case GameKind.volume:
      final width = v['width']!;
      final depth = v['depth']!;
      final height = v['height']!;
      return List.unmodifiable([
        _step(
            '↔ fi ↕ jalatti + fi − tuqi; hundee $width × $depth ijaari.',
            'Use the first two +/− controls to build a $width by $depth base.',
            '$width ↔ × $depth ↕'),
        _step(
            'Mallattoo tuulamaa jalatti + tuqi; kiyuubota walirra kaa’i.',
            'Tap + beside the layers icon to add a whole layer of cubes.',
            '▱ → ▱▱'),
        _step(
            'Tuulama $height ijaari; kiyuubota dabalaman ilaali.',
            'Build $height layers; watch the cube count change.',
            '${width * depth} □ × $height'),
        _step(
            'Qabeen kiyuubota xixiqqoo keessaa jiran lakkaa’a.',
            'Volume counts the unit cubes filling the inside.',
            '$width × $depth × $height = ${width * depth * height}'),
      ]);
    case GameKind.probability:
      final red = v['red']!;
      final blue = v['blue']!;
      return List.unmodifiable([
        _step(
            'Diimaa $red fi cuquliisa $blue lakkaa’i.',
            'Count the $red red and $blue blue tokens already in the bag.',
            '🔴 $red   🔵 $blue'),
        _step('“Yaali” tuqi; halluu argamu ilaali.',
            'Tap Yaali once; look at the colour drawn.', 'Yaali → 🔴 / 🔵'),
        _step(
            '+ fi − fayyadami; gubbaa diimaa, jalaa hunda kaa’i.',
            'Use +/− to set red tokens on top and all tokens on the bottom.',
            '$red / ${red + blue}'),
        _step(
            'Carraan diimaa baay’ina diimaa kan hundaatiin qooduu dha.',
            'Chance of red is red outcomes divided by all possible outcomes, not the trial count.',
            '🔴 / (🔴 + 🔵)'),
      ]);
    case GameKind.sets:
      final aOnly = v['aOnly']!;
      final shared = v['shared']!;
      final bOnly = v['bOnly']!;
      return List.unmodifiable([
        _step('Danaa tokko tuqi; ni filatama.', 'Tap one token to select it.',
            '☝ → ● / ★   (${aOnly + shared + bOnly})'),
        _step(
            'Geengoo 🟠 filadhu; A ∖ B tuqi.',
            'For an amber circle, tap the A ∖ B button.',
            '●🟠 → A ∖ B   ($aOnly)'),
        _step(
            'Geengoo 🔵: A ∩ B tuqi. Urjii 🔵: B ∖ A tuqi.',
            'For a blue circle tap A ∩ B; for a blue star tap B ∖ A.',
            '●🔵 → A ∩ B ($shared)   ★🔵 → B ∖ A ($bOnly)'),
        _step(
            'A ∩ B miseensota tuuta lamaan keessa jiran qaba.',
            'The intersection A ∩ B contains members belonging to both sets.',
            'A ∩ B : $shared'),
      ]);
    case GameKind.data:
      final numbers = ['a', 'b', 'c', 'd', 'e'].map((key) => v[key]!).toList();
      final total = numbers.fold<int>(0, (sum, value) => sum + value);
      return List.unmodifiable([
        _step('Tuulaa baay’ee qabu tokko tuqi.',
            'Tap a pile with more counters to select it.', numbers.join(' | ')),
        _step('Tuulaa xiqqoo qabu tuqi; tokko itti dabarsi.',
            'Then tap a pile with less; one counter moves there.', '▥ → 1 → ▥'),
        _step(
            'Irra deebi’i; tuulawwan shanan walqixa taasisi.',
            'Repeat the two taps until all five piles are equal.',
            '▥ = ▥ = ▥ = ▥ = ▥'),
        _step(
            'Gatiin giddugaleessaa hunda walqixa qooduun argama.',
            'The mean is the equal share when the total is divided among all piles.',
            '$total ÷ 5 = ${total ~/ 5}'),
      ]);
  }
}

LessonInstruction _step(String oromo, String english, String visual) =>
    LessonInstruction(oromo: oromo, english: english, visual: visual);
