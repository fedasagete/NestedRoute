import 'lesson_instruction.dart';
import 'scenarios.dart';

/// Derives the changed-number transfer question without reading its answer.
/// Afaan Oromo explanations are drafts awaiting a fluent educator's review.
List<LessonInstruction> workedSolution(LearningScenario scenario) {
  final discovery = _discoverySteps(scenario.id);
  if (discovery != null) return _numbered(discovery);
  final v = scenario.values;
  switch (scenario.kind) {
    case GameKind.numberLine:
      final start = v['start']! + 1;
      final delta = v['delta']!;
      final answer = start + delta;
      final steps = [
        _step(
            'Lakkoofsa jalqabaa fi jijjiirama isaa ilaali.',
            'Use the new starting number and the signed change.',
            '${_n(start)} + (${_n(delta)}) = ?'),
        _step(
            delta < 0
                ? 'Negaatiivii ida’uun hamma isaa hir’isuu dha.'
                : 'Poozatiivii ida’uun hamma isaa dabala.',
            delta < 0
                ? 'Adding a negative number subtracts its magnitude.'
                : 'Adding a positive number increases the value.',
            delta < 0
                ? '${_n(start)} + (${_n(delta)}) = ${_n(start)} − ${delta.abs()}'
                : '${_n(start)} + (+$delta) = ${_n(start)} + $delta'),
      ];
      if (start < 0 || delta < 0) {
        final bothNegative = start < 0 && delta < 0;
        final larger = start.abs() > delta.abs() ? start.abs() : delta.abs();
        final smaller = start.abs() < delta.abs() ? start.abs() : delta.abs();
        steps.add(_step(
            bothNegative
                ? 'Hamma isaanii ida’i; mallattoon negaatiivii ta’a.'
                : answer == 0
                    ? 'Hamma walqixa mallattoo faallaa qaban ida’uun zeeroo kenna.'
                    : 'Hamma xinnaa guddaa irraa hir’isi; mallattoo isa guddaa fudhadhu.',
            bothNegative
                ? 'Add the magnitudes; two negative addends give a negative sum.'
                : answer == 0
                    ? 'Equal opposite magnitudes cancel to zero.'
                    : 'Subtract the magnitudes; keep the sign of the larger magnitude.',
            bothNegative
                ? '${start.abs()} + ${delta.abs()} = ${answer.abs()}'
                : '$larger − $smaller = ${answer.abs()}'));
      }
      steps.add(_step(
          'Ida’ama mallattoo isaa wajjin barreessi.',
          'Write the sum with its resulting sign.',
          '${_n(start)} + (${_n(delta)}) = ${_n(answer)}'));
      return _numbered(steps);
    case GameKind.equalGroups:
      final groups = v['groups']! + 1;
      final each = v['each']!;
      final total = groups * each;
      return _numbered([
        _step(
            'Baay’ina garee fi hamma garee tokkoo adda baasi.',
            'Identify the number of groups and the amount in each group.',
            'groups = $groups; each = $each'),
        _step(
            'Hamma walqixa garee hundaaf ida’i.',
            'Add the same amount once for every group.',
            '${_sum(List.filled(groups, each))} = $total'),
        _step(
            'Baay’isuun ida’ama irra deddeebi’ame gabaabsa.',
            'Multiplication records the repeated addition.',
            '$groups × $each = $total'),
      ]);
    case GameKind.sharing:
      final people = v['people']!;
      final total = v['total']! + people;
      final each = total ~/ people;
      return _numbered([
        _step(
            'Waliigala haaraa namootaaf walqixa qoodi.',
            'Share the new total equally among all the people.',
            '$total ÷ $people'),
        _step(
            'Baay’ina namootaa hamma nama tokkoon baay’isi.',
            'The number of people times each share must equal the total.',
            '$people × ? = $total'),
        _step(
            'Hamma nama tokkoo baay’isuun waliigala mirkaneessi.',
            'Check that these equal shares account for the whole total.',
            '$people × $each = $total'),
        _step(
            'Kun hamma nama tokkoo ti.',
            'Division gives the amount each person receives.',
            '$total ÷ $people = $each'),
      ]);
    case GameKind.fractionTiles:
      final selected = v['selected']! + 1;
      final parts = v['parts']! + 1;
      return _numbered([
        _step(
            'Kutaan dibame gubbaa; kutaan hundi jalaa jira.',
            'The top counts selected parts; the bottom counts all equal parts.',
            '$selected / $parts'),
        _step('Kutaa walqixa hunda lakkaa’i.',
            'Count all equal parts of this whole.', 'all equal parts = $parts'),
        _step(
            'Waamsisaan lakkoofsa jalaa ti; firaakshinii kana hin salphisin.',
            'The denominator is the bottom number in the given fraction; keep it unsimplified.',
            'denominator = $parts'),
      ]);
    case GameKind.balance:
      final factor = v['factor']!;
      final offset = v['offset']! + (v['offset']! < 0 ? -1 : 1);
      final right = factor * (v['solution']! + 1) + offset;
      final residual = right - offset;
      final answer = residual ~/ factor;
      return _numbered([
        _step(
            'Hima walqixaa haaraa irraa jalqabi.',
            'Start with the new equation and its unknown value.',
            '$factor × x + (${_n(offset)}) = $right'),
        _step(
            'Lakkoofsa ida’ame gama lamaan irraa hir’isi.',
            offset < 0
                ? 'Subtract the negative offset from both sides; this adds its magnitude.'
                : 'Subtract the offset from both sides to preserve equality.',
            '$factor × x = $right − (${_n(offset)})'),
        _step(
            'Gama mirgaa shallagi.',
            'Calculate the right side after undoing the offset.',
            '$factor × x = $residual'),
        _step(
            'Gama lamaan baay’isaa kanaan qoodi.',
            'Divide both sides by the coefficient to find the unknown.',
            'x = $residual ÷ $factor = $answer'),
      ]);
    case GameKind.areaGrid:
      final width = v['width']! + 1;
      final height = v['height']!;
      final area = width * height;
      return _numbered([
        _step(
            'Bal’ina dalgee fi dheerina haaraa ilaali.',
            'Use the changed width and the given height.',
            'w = $width; h = $height'),
        _step(
            'Tokkoon tokkoon tarree yuunitii iskuweerii walqixa qaba.',
            'Each row contains the same number of unit squares.',
            '${_sum(List.filled(height, width))} = $area'),
        _step(
            'Bal’inni dalgee yeroo dheerina; yuunitii iskuweerii fayyadami.',
            'Area equals width times height, measured in square units.',
            'A = $width × $height = $area u²'),
      ]);
    case GameKind.angleBuilder:
      final a = v['a']! + 1;
      final b = v['b']!;
      final known = a + b;
      final missing = 180 - known;
      return _numbered([
        _step('Kofa lama beekaman ida’i.', 'Add the two known angles.',
            '$a° + $b° = $known°'),
        _step(
            'Ida’amni kofa rog-sadee 180° dha; isa beekamu hir’isi.',
            'A triangle has an angle sum of 180°; subtract the known sum.',
            '180° − $known° = $missing°'),
        _step('Kofni hafe digriin kun ta’a.',
            'The remaining angle is this many degrees.', 'x = $missing°'),
      ]);
    case GameKind.similarity:
      final side = v['width']! + 1;
      final scale = v['scale']!;
      final answer = side * scale;
      return _numbered([
        _step(
            'Cinaacha haaraa fi reeshiyoo guddinaa ilaali.',
            'Identify the original side and the scale factor.',
            'side = $side; k = $scale'),
        _step(
            'Cinaacha sana hamma guddinaa kanaaf irra deddeebi’i.',
            'The scaled length contains this many copies of the original length.',
            '${_sum(List.filled(scale, side))} = $answer'),
        _step(
            'Cinaacha reeshiyoo guddinaan baay’isi.',
            'Multiply the corresponding side by the scale factor; use length units.',
            '$side × $scale = $answer u'),
      ]);
    case GameKind.volume:
      final width = v['width']! + 1;
      final depth = v['depth']!;
      final height = v['height']!;
      final layer = width * depth;
      final volume = layer * height;
      return _numbered([
        _step(
            'Safartuu sadan qaama kanaa ilaali.',
            'Use the new width, the depth, and the height.',
            '$width × $depth × $height'),
        _step(
            'Bal’ina jalaa yuunitii iskuweeriin shallagi.',
            'Find the base area: one layer of unit cubes.',
            '$width × $depth = $layer u²'),
        _step(
            'Laayarii kana dheerina qaamaatiin baay’isi.',
            'Multiply the cubes in one layer by the number of layers.',
            '$layer × $height = $volume u³'),
        _step('Qabee yuunitii kiyuubii keessatti barreessi.',
            'Write the volume in cubic units.', 'V = $volume u³'),
      ]);
    case GameKind.probability:
      final red = v['red']! + 1;
      final blue = v['blue']! + 1;
      final total = red + blue;
      return _numbered([
        _step('Bu’aan barbaadamu baay’ina diimaa ti.',
            'For a red outcome, count the favorable red items.', 'red = $red'),
        _step(
            'Diimaa fi cuquliisa ida’uun bu’aa hunda lakkaa’i.',
            'Add both colors to count all equally likely outcomes.',
            '$red + $blue = $total'),
        _step(
            'Carraan diimaa bu’aa barbaadamu qoodaa bu’aa hunda ti.',
            'Probability is favorable outcomes divided by all outcomes.',
            'P(🔴) = $red / $total'),
        _step(
            'Gaaffiin kun baay’ina bu’aa hunda gaafata.',
            'This question asks for all outcomes, the denominator of the probability.',
            'outcomes = $total'),
      ]);
    case GameKind.sets:
      final aOnly = v['aOnly']! + 1;
      final shared = v['shared']!;
      final bOnly = v['bOnly']! + 1;
      final union = aOnly + shared + bOnly;
      return _numbered([
        _step(
            'Kiphni miseensota tuuta lamaan keessa jiran qaba.',
            'The intersection contains the members shared by both sets.',
            'A ∩ B = $shared'),
        _step(
            'Miseensota tuuta tokko qofa keessa jiran adda baasi.',
            'Identify the members that belong only to A and only to B.',
            'A ∖ B = $aOnly; B ∖ A = $bOnly'),
        _step(
            'Kutaa sadan ida’i; miseensa waliinii al tokko qofa lakkaa’i.',
            'Add the three disjoint regions; count each shared member just once.',
            '$aOnly + $shared + $bOnly = $union'),
        _step(
            'Makoonsi miseensota tuuta keessaa tokko keessa jiran hunda qaba.',
            'The union contains every member in either set.',
            'A ∪ B = $union'),
      ]);
    case GameKind.data:
      final values = v.values.toList().reversed.map((n) => n + 1).toList();
      final total = values.fold<int>(0, (sum, n) => sum + n);
      final mean = total ~/ values.length;
      return _numbered([
        _step(
            'Gatiiwwan haaraa shanan fayyadami.',
            'Use all five changed values; their order does not change the mean.',
            values.join(', ')),
        _step(
            'Gatiiwwan hunda ida’i.',
            'Add all five values to find their total.',
            '${_sum(values)} = $total'),
        _step(
            'Waliigala baay’ina gatiiwwaniin qoodi.',
            'Divide the total by five, the number of values, to find the mean.',
            'mean = $total ÷ ${values.length} = $mean'),
      ]);
  }
}

LessonInstruction _step(String oromo, String english, String visual) =>
    LessonInstruction(oromo: oromo, english: english, visual: visual);

List<LessonInstruction> _numbered(List<LessonInstruction> steps) =>
    List.unmodifiable([
      for (var i = 0; i < steps.length; i++)
        LessonInstruction(
            oromo: steps[i].oromo,
            english: steps[i].english,
            visual: '${i + 1}. ${steps[i].visual}'),
    ]);

String _n(int value) => value < 0 ? '−${value.abs()}' : '$value';
String _sum(List<int> values) => values.join(' + ');

List<LessonInstruction>? _discoverySteps(String id) {
  switch (id) {
    case 'discovery-fractionDivision':
      return [
        _step('Shan ja’affaan kutaa tokko ja’affaa shan qaba.',
            'Five sixths contains five units of one sixth.', '5/6 = 5 × (1/6)'),
        _step(
            'Kutaa ja’affaa walqixa qooduun baay’ina isaanii gaafata.',
            'Dividing by one sixth asks how many sixth-sized units fit.',
            '5/6 ÷ 1/6 = 5 ÷ 1'),
        _step('Kutaan tokko ja’affaa shan keessa seena.',
            'Five units of one sixth fit into five sixths.', '5/6 ÷ 1/6 = 5'),
      ];
    case 'discovery-signedProducts':
      return [
        _step(
            'Gareen afur, tokkoon tokkoon isaanii negaatiivii sadii qaba.',
            'Four groups of negative three have a total of negative twelve.',
            '4 × (−3) = −12'),
        _step(
            'Garee negaatiivii kana zeeroo irraa hir’isi.',
            'A negative group count removes these groups: subtract negative twelve from zero.',
            '0 − (−12) = 0 + 12'),
        _step(
            'Negaatiivii hir’isuun poozatiivii ida’uu dha.',
            'Subtracting a negative adds its positive magnitude.',
            '0 + 12 = 12'),
        _step(
            'Negaatiivii lama baay’isuun poozatiivii kenna.',
            'The product of two negatives is positive twelve.',
            '(−4) × (−3) = 12'),
      ];
    case 'discovery-ratio':
      return [
        _step(
            'Reeshiyoon 3:2 kutaa shan walqixa qaba.',
            'The ratio 3:2 divides the whole into five equal parts.',
            '3 + 2 = 5'),
        _step(
            'Waliigala digdama kutaa shanitti qoodi.',
            'Divide the total twenty by five to find the value of one part.',
            '20 ÷ 5 = 4'),
        _step('Gareen jalqabaa kutaa sadii qaba.',
            'The first group has three parts, each worth four.', '3 × 4 = 12'),
      ];
    case 'discovery-pythagoras':
      return [
        _step(
            'Kofni sirrii 90° dha; seera Paayitagoras fayyadami.',
            'The angle is 90°; Pythagoras relates the squares of the three sides.',
            '∠C = 90°; c² = 6² + 8²'),
        _step('Cinaacha gabaabaa lamaan iskuweerii godhi.',
            'Square each of the two perpendicular legs.', '6² = 36; 8² = 64'),
        _step(
            'Iskuweerii lamaan ida’i.',
            'Add the squares to find the square of the hypotenuse.',
            'c² = 36 + 64 = 100'),
        _step(
            'Kudhan ofuma isaatiin baay’isuun dhibba kenna.',
            'Check which nonnegative length has a square of one hundred.',
            '10 × 10 = 100'),
        _step(
            'Dheerinni negaatiivii miti; hundee iskuweerii fudhadhu.',
            'Take the nonnegative square root; a length cannot be negative.',
            'c = √100 = 10 u'),
      ];
    case 'discovery-circleAngles':
      return [
        _step(
            'Arkii tokko irratti kofni giddugaleessaa kofa irra jiru dachaa lama.',
            'On the same arc, the central angle is twice the inscribed angle.',
            '∠AOB = 2 × ∠APB'),
        _step('Kofa giddugaleessaa digrii 140 lamaaf qoodi.',
            'Halve the new central angle of 140 degrees.', '140° ÷ 2 = 70°'),
        _step(
            'Kofni geengoo irra jiru digrii torbaatama.',
            'The inscribed angle on this arc is seventy degrees.',
            '∠APB = 70°'),
      ];
    case 'discovery-inequality':
      return [
        _step(
            'Hima walcaalmaa haaraa ilaali.',
            'Begin with the inequality and its negative coefficient.',
            '−3x < 12'),
        _step(
            'Negaatiivii sadiin qooduun mallattoo walcaalmaa garagalcha.',
            'Divide both sides by negative three; division by a negative reverses the inequality.',
            '÷(−3): < → >'),
        _step('Gama mirgaa negaatiivii sadiin qoodi.',
            'Calculate twelve divided by negative three.', '12 ÷ (−3) = −4'),
        _step(
            'x negaatiivii afur caala; daangaan negaatiivii afur hin dabalamu.',
            'The answer is greater than negative four; the boundary is excluded because the inequality is strict.',
            'x > −4'),
      ];
    case 'discovery-squareRoot':
      return [
        _step(
            'Hundeen iskuweerii filatamaan negaatiivii miti.',
            'The principal square root is the nonnegative number whose square is forty-nine.',
            'x = √49; x ≥ 0'),
        _step(
            'Torba ofuma isaatiin baay’isuun afurtamii sagal kenna.',
            'Check that seven multiplied by itself is forty-nine.',
            '7 × 7 = 49'),
        _step('Torbi zeeroo yookaan isa caalu dha.',
            'Seven satisfies the required nonnegative sign.', '7 ≥ 0'),
        _step(
            'Hundeen filatamaan torba; mallattoo ± hin qabu.',
            'Choose positive seven as the principal root, rather than both signed roots.',
            '√49 = 7'),
      ];
    case 'discovery-congruence':
      return [
        _step(
            'Rog-sadeen jalqabaa dheerina cinaachaa kana qaba.',
            'Record the reference triangle’s three side lengths.',
            'reference: 5, 12, 13'),
        _step(
            'Filannoo tokko keessatti tartiiba jijjiiri; dheerinni sadan walqixa.',
            'Reorder option one’s sides; all three match the reference lengths.',
            '①: 13, 5, 12 → 5, 12, 13'),
        _step(
            'Filannoon lama dheerina hunda dachaa lama godha; hammi isaa adda.',
            'Option two doubles every length, so its size differs even though its shape is similar.',
            '②: 26, 10, 24 = 2 × (13, 5, 12)'),
        _step(
            'Seerri cinaacha-sadii filannoo tokko walitti gita jedha.',
            'By side-side-side congruence, option one matches both shape and size.',
            '≅: ① ⇒ answer = 1'),
      ];
    case 'discovery-englishNumbers':
      return [
        _step(
            'THREE jechuun Ingiliffaan sadii dha.',
            'Recognize THREE as the English word for this group of dots.',
            'THREE ↔ ● ● ●'),
        _step(
            'Tuqaa tokkoon tokkoon isaa al tokko lakkaa’i.',
            'Count each dot once to connect the word to the quantity.',
            '● ● ● → 1 + 1 + 1 = 3'),
        _step('Jecha THREE lakkoofsa sadiin bakka buusi.',
            'The numeral for THREE is three.', 'THREE = 3'),
      ];
    default:
      return null;
  }
}
