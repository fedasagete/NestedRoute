import 'lesson_instruction.dart';

/// The last step describes the discovery for the definition phase.
/// Earlier steps describe actions without giving the transfer answer.
List<LessonInstruction> discoveryInstructions(String scenarioId) =>
    _instructions[scenarioId] ?? const [];

const _instructions = <String, List<LessonInstruction>>{
  'discovery-fractionDivision': [
    LessonInstruction(
      oromo: 'Kutaalee halluu qaban ilaali. Isaan 3/4 dha.',
      english: 'Look at the shaded parts. They cover 3/4 of the strip.',
      visual: '■ ■ ■ □ · 3/4',
    ),
    LessonInstruction(
      oromo: '“4 → 8” tuqi. Tokkoon tokkoon 1/4 bakka lama qoodama.',
      english: 'Tap 4 → 8. Each quarter splits into two eighths.',
      visual: '1/4 → 1/8 + 1/8',
    ),
    LessonInstruction(
      oromo: 'Kutaalee 1/8 halluu qaban tuqi. Halluu hin qabne dhiisi.',
      english:
          'Tap each shaded eighth to fit it into 3/4. Leave the unshaded parts.',
      visual: '1/8 → ■ · □',
    ),
    LessonInstruction(
      oromo: 'Kutaalee filatte lakkoofsi. 3/4 guutuu uwwisi.',
      english: 'Count the selected eighths. Cover all of the shaded 3/4.',
      visual: '? × 1/8 = 3/4',
    ),
    LessonInstruction(
      oromo:
          '3/4 keessa kutaaleen 1/8 jaha jiru. Hiruun kutaalee kana lakkaa’a.',
      english: 'Division counts how many eighths fit into 3/4: six.',
      visual: '3/4 ÷ 1/8 = 6',
    ),
  ],
  'discovery-signedProducts': [
    LessonInstruction(
      oromo: '“(+1) + (−1)” tuqi. Lamaan wal haqanii 0 ta’u.',
      english:
          'Tap (+1) + (−1). The two counters cancel, so the total stays zero.',
      visual: '(+1) + (−1) = 0',
    ),
    LessonInstruction(
      oromo: 'Cimdiilee akkanaa jaha tolchi. Ammas ida’amni 0 dha.',
      english:
          'Make six zero pairs. You now have six positives and six negatives.',
      visual: '6 × [(+1) + (−1)] = 0',
    ),
    LessonInstruction(
      oromo: '“− (−2)” yeroo sadii tuqi. Yeroo hunda negaatiivii lama hir’isi.',
      english:
          'Tap − (−2) three times. Each tap removes two negative counters.',
      visual: '− (−2) · − (−2) · − (−2)',
    ),
    LessonInstruction(
      oromo: 'Pozaatiivota hafan lakkoofsi. Ida’amni dabalaa deema.',
      english:
          'Count the positives left behind. Removing negatives raises the total.',
      visual: '0 → +2 → +4 → +6',
    ),
    LessonInstruction(
      oromo: 'Negaatiivii hir’isuun ida’amuu ta’a. −3 × (−2) pozaatiivii dha.',
      english:
          'Removing a negative adds a positive. This negative product is positive.',
      visual: '−3 × (−2) = +6',
    ),
  ],
  'discovery-ratio': [
    LessonInstruction(
      oromo: '2 : 3 ilaali. Kaayyoon tuqaalee 10 dha.',
      english:
          'The pattern is two yellow dots for three blue dots. Make ten dots total.',
      visual: '🟨 🟨 : 🟦 🟦 🟦 · ?/10',
    ),
    LessonInstruction(
      oromo: 'Mallattoo + halluu lamaanii tuqi. Tuqaaleen dabalu.',
      english: 'Tap + below each colour to add dots. Watch both counters grow.',
      visual: '🟨 + · 🟦 +',
    ),
    LessonInstruction(
      oromo: 'Garee 2 : 3 guuti. Tuqaalee dabalataa − tuquun hir’isi.',
      english: 'Fill whole 2 : 3 groups. Use − to remove any leftover dots.',
      visual: '[2 : 3] [2 : 3] · −',
    ),
    LessonInstruction(
      oromo: 'Ida’amni 10 ta’uu isaa ilaali. Gareen hundi 2 : 3 haa ta’u.',
      english:
          'Check that the total reaches 10 and every group still has the 2 : 3 pattern.',
      visual: '2 + 3 · 2 + 3 → 10/10',
    ),
    LessonInstruction(
      oromo:
          'Lakkoofsa halluu lamaanii dachaa tokkoon baay’isuun reeshoo eega.',
      english:
          'Multiplying both colour counts by the same factor keeps the ratio.',
      visual: '2 : 3 → ×2 → 4 : 6',
    ),
  ],
  'discovery-pythagoras': [
    LessonInstruction(
      oromo:
          'Iskuweerota roga sadii irratti jiran ilaali. Tokkoon tokkoon □ bal’ina 1 dha.',
      english:
          'Look at the squares attached to the triangle. Each little tile has area one.',
      visual: '3 × 3 · 4 × 4 · 5 × 5',
    ),
    LessonInstruction(
      oromo: '“3 □” tuqi. Tarree tokko iskuweerii guddaatti dabarsi.',
      english: 'Tap a 3 □ row button. Three tiles move into the large square.',
      visual: '3 □ → □□□',
    ),
    LessonInstruction(
      oromo: '“4 □” tuqi. Tarreewwan hafan hundas dabarsi.',
      english:
          'Tap the 4 □ row buttons too. Move all rows from both smaller squares.',
      visual: '4 □ → □□□□',
    ),
    LessonInstruction(
      oromo:
          'Iskuweerii guddaan guutamuu isaa ilaali. Kutaalee hundaa lakkoofsi.',
      english:
          'Watch the large square fill. Count the tiles from the two smaller squares.',
      visual: '9 □ + 16 □ → 25 □',
    ),
    LessonInstruction(
      oromo:
          'Rog-sadee kofa sirrii keessatti bal’inni iskuweerota xixiqqoo lamaa isa guddaa guuta.',
      english:
          'In a right triangle, the two leg squares together equal the square on the longest side.',
      visual: '3² + 4² = 5²',
    ),
  ],
  'discovery-circleAngles': [
    LessonInstruction(
      oromo:
          'Kofa 100° giddugaleessaa ilaali. Sararoonni tuqaalee geengoo lama wal qunnamsiisu.',
      english:
          'Find the central 100° angle. Its lines reach the two marked circle endpoints.',
      visual: '● ← 100° → ●',
    ),
    LessonInstruction(
      oromo:
          '← ykn → tuqi. Tuqaan geengoo irra socho’a; fiixeen lamaan hin jijjiiraman.',
      english:
          'Tap ← or → to move the lower point. The two endpoints stay fixed.',
      visual: '● ↔ ●',
    ),
    LessonInstruction(
      oromo: '+ fi − tuqi. Sarara safartuu kofaatiin wal qixxeessi.',
      english:
          'Use + and − beside the angle to line up the measuring needle with the second ray.',
      visual: '− · ?° · +',
    ),
    LessonInstruction(
      oromo:
          'Tuqaa ammas sochoosi. Safartuun kofa sanaa akkuma jiru hafuusaa ilaali.',
      english:
          'Move the point again along the same arc. Notice that this angle stays the same.',
      visual: '● ↔ ● · ?° = ?°',
    ),
    LessonInstruction(
      oromo:
          'Arkii tokko irratti kofa geengoo irra jiru walakkaa kofa giddugaleessaa dha.',
      english:
          'For the same arc, the angle on the circle is half the central angle.',
      visual: '100° = 2 × 50°',
    ),
  ],
  'discovery-inequality': [
    LessonInstruction(
      oromo: '“× (−2)” tuqi. Lakkoofsotni kallattii faallaa irratti mul’atu.',
      english:
          'Tap × (−2). Watch the numbers switch order on the reflected number line.',
      visual: '−4 < 0 → ×(−2) → 8 > 0',
    ),
    LessonInstruction(
      oromo: '+ fi − tuqi. Daangaan × (−2) booda 6 haa ta’u.',
      english:
          'Use + and − to choose the boundary whose value becomes 6 after multiplying by −2.',
      visual: '−2 × (?) = 6',
    ),
    LessonInstruction(
      oromo: 'Gama sirrii filadhu. Daangaan < keessa hin jiru; ○ filadhu.',
      english:
          'Choose the working side of the line. Choose the open circle ○ because < excludes equality.',
      visual: 'x < ? · x > ? · ○ / ●',
    ),
    LessonInstruction(
      oromo: '“x = 0” fi “x = −4” tuqi. Kamtu −2x < 6 guuta?',
      english:
          'Tap x = 0 and x = −4 to test both. Check which one makes −2x < 6 true.',
      visual: 'x = 0 · x = −4 → ✓ / ✗',
    ),
    LessonInstruction(
      oromo:
          'Negaatiivii baay’isuu ykn hiruun mallattoo walcaalmaa garagalcha.',
      english:
          'Multiplying or dividing by a negative reverses the inequality sign.',
      visual: '−2x < 6 ⇒ x > −3',
    ),
  ],
  'discovery-squareRoot': [
    LessonInstruction(
      oromo: 'Kutaalee 25 ilaali. Iskuweerii roga wal qixxee qabu tolchi.',
      english:
          'You have 25 tiles in a strip. Arrange them into a square with equal sides.',
      visual: '25 □ → □²',
    ),
    LessonInstruction(
      oromo: '+ tuqi. Tarreewwanii fi tarjaawwan wal qixxee dabalu.',
      english:
          'Tap + to change the side length. The row and column counts change together.',
      visual: 'a × a → (a + 1) × (a + 1)',
    ),
    LessonInstruction(
      oromo:
          'Kutaalee hafan ilaali. Bakki duwwaan yoo jiraate kutaaleen hin ga’an.',
      english:
          'Watch the spare tiles. Empty cells mean the square needs more than 25 tiles.',
      visual: '■ = 1 tile · □ = empty cell',
    ),
    LessonInstruction(
      oromo:
          '+ ykn − tuqi. Haftee fi bakka duwwaa malee 25 guuti; roga lakkoofsi.',
      english:
          'Use + or − until all 25 fit with no spare tiles or empty cells. Read the side length.',
      visual: '25 tiles · 0 spare · 0 empty',
    ),
    LessonInstruction(
      oromo:
          'Iskuweer-ruuttiin 25 dheerina roga iskuweerii bal’ina 25 qabuuti.',
      english:
          'The square root of 25 is the side length of a square with area 25.',
      visual: '5 × 5 = 25 · √25 = 5',
    ),
  ],
  'discovery-congruence': [
    LessonInstruction(
      oromo: '“× 1.5” tuqi. Kofni hin jijjiiramu; dheerinni rogawwanii dabala.',
      english:
          'Try × 1.5. The angles stay the same, but the side lengths grow.',
      visual: '3 · 4 · 5 → ×1.5 → 4.5 · 6 · 7.5',
    ),
    LessonInstruction(
      oromo: '“× 1” filadhu. Rogawwan 3, 4, 5 deebisu.',
      english:
          'Select × 1 to return to the same side lengths as the outlined triangle.',
      visual: '×1 · 3 · 4 · 5',
    ),
    LessonInstruction(
      oromo:
          '← → ↑ ↓ tuqi. Rog-sadee halluu qabu gara isa sararameetti sochoosi.',
      english:
          'Use ← → ↑ ↓ to move the coloured triangle onto the outlined triangle.',
      visual: '← → ↑ ↓ · △ → △',
    ),
    LessonInstruction(
      oromo: 'Xiyya naanna’aa tuqi. Fiixeewwan sadan wal irra haa bu’an.',
      english:
          'Use the curved arrows to turn it. Match all three corners of the two triangles.',
      visual: '↶ △ ↷ · 3 matching corners',
    ),
    LessonInstruction(
      oromo:
          'Rog-sadeewwan walittigalan bocaa fi guddina tokko qabu; rogawwan isaanii wal qixxee dha.',
      english:
          'Congruent triangles have the same shape and size; all three matching sides are equal.',
      visual: 'RRR · SSS · 3 = 3 · 4 = 4 · 5 = 5',
    ),
  ],
  'discovery-englishNumbers': [
    LessonInstruction(
      oromo:
          'Jalqaba lakkoofsa, tuqaalee fi jecha isaa ilaali. Jechoota dubbisi.',
      english:
          'First study each number, its dots and its English word. Read the four words.',
      visual: '1 · 2 · 3 · 4 → ABC',
    ),
    LessonInstruction(
      oromo: 'Xiyya → kaardiiwwan jalaa tuqi. Amma walitti firoomsuu jalqabi.',
      english: 'Tap the → button below the study cards to start matching.',
      visual: 'Study → Match',
    ),
    LessonInstruction(
      oromo: 'Jalqaba kaardii jecha tokkoo tuqi. Kaardichi filatama.',
      english:
          'Tap a word card first. Its highlighted border shows your selection.',
      visual: 'ABC → ☝',
    ),
    LessonInstruction(
      oromo:
          'Lakkoofsa jecha sanaa tuqi. Jechoota afran hunda walitti firoomsi.',
      english:
          'Then tap its number card. Repeat for all four words; you can repair a wrong match.',
      visual: 'word → number · ?/4 → 4/4',
    ),
    LessonInstruction(
      oromo: 'ONE, TWO, THREE fi FOUR jechoota lakkoofsota 1, 2, 3 fi 4 ti.',
      english:
          'ONE, TWO, THREE and FOUR are the English words for the numbers 1, 2, 3 and 4.',
      visual: 'ONE = 1 · TWO = 2 · THREE = 3 · FOUR = 4',
    ),
  ],
};
