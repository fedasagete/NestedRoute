# Action-first mathematics learning catalogue

This catalogue supports an Afaan Oromo learner with arithmetic gaps on the way to the supplied Grade 7 and Grade 8 mathematics books. It contains original, goal-based adaptations grounded in all 15 textbook chapters, with a prerequisite arithmetic layer. The English text is reviewer authoring material. Learner-facing Afaan Oromo text and recordings require the user’s review.

Sources: *Herrega Kitaaba Barattootaa Kutaa 7* and *Kutaa 8*, Biiroo Barnootaa Oromiyaa, 2014 E.C./2022. References use **printed page numbers**, not PDF viewer numbers. Actual passages checked include Grade 7 membership/equality and set operations (pp. 2–12), signed operations (pp. 36–46), interest (pp. 73–79), balance equations (pp. 95–106), area rearrangements (pp. 147–155), congruence criteria (pp. 168–178), and data definitions (pp. 190–206); Grade 8 fraction operations (pp. 20–35), roots (pp. 53–58), inequalities (pp. 85–89), similarity and scaling (pp. 97–111), right-triangle projections (pp. 127–133), circle angles (pp. 156–160), nets/volume (pp. 181–195), and sample spaces/probability (pp. 206–210). Reading notes also supply the chapter-level context. Text extraction loses some operators, powers and diagram labels, so final diagram authoring must check the original PDFs. No pages or extended textbook passages are reproduced here.

## What is being counted

There are **89 concept-specific interaction blueprints**: 10 foundations, 38 Grade 7 and 41 Grade 8. They span all 15 chapters. Some share a representation—such as a number line—while requiring different mathematical actions and explanations. This is not a claim of 89 unrelated game engines.

Each blueprint contains **8 distinct numeric/structural configurations and 2 challenge modes**, giving **1,424 scenario design slots**: 712 build tasks and 712 diagnose-and-repair tasks. The exact parameters and numeric answer checks are stored in [blueprints.json](blueprints.json). The slots are constrained variations within the blueprints. Renaming a character, changing colours or swapping an unrelated story does not count as a variation or a new teaching method. Build and repair are counted separately only when the incorrect starting state and required explanation differ from the build task.

These are content specifications and answer-key seeds, not 1,424 completed Android screens. A renderer must construct the required objects and plausible misconception state for each slot, preserve constraints, and expose the transfer task. Proof/correspondence validity, diagrams, translations, audio and actual learner understanding need review before release. Current national exam requirements are not established by these source editions.

## Learning loop and mathematical goals

1. Give a concrete goal with quantities or constraints: pay exactly, allocate a budget, build a matching triangle, measure a covering, fill a box, or compare event chances.
2. Let the learner predict or inspect, then make 3–5 mathematical actions. Every movement changes or tests a mathematical representation.
3. Show what changes and what is preserved: total count, a fraction’s whole, equality, area, correspondence, or a complete sample space.
4. Ask for an explanation, then state the definition or rule using the observed relationship.
5. Require a fresh written/symbolic or contextual transfer, including units and verification. Revisit later without hints.

Success is the mathematical goal, not speed, coins, random tapping, an unrelated maze or an animation before a quiz. A retry should identify a misconception and offer a mathematical response. Progress may recognise independent reasoning, transfer and recovery from an error; rewards must not hide incorrect mathematics.

For offline Android, bundle reviewed strings, diagrams, number seeds, answer rules and recordings. No live translation is required. Provide replayable audio and a tap-select/tap-place alternative to dragging. Use labels/patterns alongside colour, large simple controls, untimed reasoning and a persistent definition replay. English literacy must not block the mathematics.

## Catch-up route

Start with brief untimed probes of place value, regrouping, multiplication, division, equal parts and decimal units. Route a failed concept to its targeted foundation, then back to the chapter task. Avoid making the learner repeat every earlier chapter after one error.

Suggested arithmetic bridge: `f01 → f02/f03 → f04 → f05 → f06 → f07/f08 → g7i01 → g7i02 → g7i03 → g7i04 → g7i05 → g8q03/g8q04 → g8q05/g8q06`.

| Observed barrier | Support and return route |
|---|---|
| Adds denominators | Equal parts `f06`, equivalent parts `f07`, common-unit merge `g8q03` |
| Cannot explain two negative factors | Cancellation `g7i02`, removing debt `g7i03`, distributive bridge `g7i04` |
| Misses inequality sign reversal | Signed order `g7i01`, negative scaling `g7i04`, reflection `g8l03` |
| Confuses area, surface and volume | Units `f09`, boundary/interior `g7a02`, net `g8v02`, cube layers `g8v05` |
| Averages unequal-size group means | Sharing `f05`, fair-share mean `g7d03`, total reconstruction `g7d07` |

Prerequisite IDs in each entry identify support targets; they are not compulsory lockouts if a learner already demonstrates the concept. A proposed mastery gate is independent success on two different parameter sets, explanation of the relationship, and fresh transfer, followed by delayed checking. Those thresholds need learner testing; they do not themselves prove mastery or exam readiness. Reserve unseen parameter sets for checking, and interleave related concepts instead of exhausting all variants at once.

## Source and language review boundaries

The original conceptual extension for negative×negative uses equal-step continuation **and the distributive invariant**, not negative physical groups or a rote sign chant. Division of fractions has separate measurement and inverse-scaling models. Congruence uses rigid movement; similarity permits uniform scale. Negative inequality scaling uses reflected order. Square-root notation denotes the principal nonnegative root, while an equation may have two signed solutions. Circle angle entries track the actual intercepted arc. Probability counting explicitly requires equally likely elementary outcomes. Means use counts as weights, and the no-mode convention follows this book.

Grade 8 solid coverage includes pyramid/cone classification and surface area; its supplied chapter explicitly develops prism/cylinder volume. Pyramid/cone volume formulas are not silently presented as a source requirement. Grade 7 includes both simple and compound interest; Grade 8 includes Euclidean projection relations and the converse as well as Pythagoras. Official exam topic weights and up-to-date prescribed editions remain outside the evidence supplied.

Grade 7 p. 38 has a confirmed inconsistent below-sea-level number (116 in the narrative versus 120 in the diagram/solution). No seed here imports that ambiguous example. All numeric examples below are newly authored.

[translation-review.csv](translation-review.csv) supplies stable UI/audio IDs. Source-book glossary terms are proposed only where observed; complete Oromo sentences are deliberately blank. **Every row remains unreviewed**, including glossary terms. Confirm spelling, inflection, numerical language, strict/inclusive comparison, percentage rate versus amount, and number-set vocabulary before bundling. Do not publish English authoring text as though it were reviewed Oromo.

## Coverage index

| Layer/chapter | Printed source pages | Blueprints | Scenario design slots |
|---|---:|---:|---:|
| Foundations | prerequisite layer | 10 | 160 |
| Grade 7, chapter 1: Sets | 1–18 | 4 | 64 |
| Grade 7, chapter 2: Integers | 19–52 | 6 | 96 |
| Grade 7, chapter 3: Ratio, proportion and percentage | 53–85 | 6 | 96 |
| Grade 7, chapter 4: Linear equations | 86–123 | 5 | 80 |
| Grade 7, chapter 5: Perimeter and area of plane figures | 124–166 | 6 | 96 |
| Grade 7, chapter 6: Congruence | 167–188 | 4 | 64 |
| Grade 7, chapter 7: Data handling | 189–213 | 7 | 112 |
| Grade 8, chapter 1: Rational numbers | 1–46 | 7 | 112 |
| Grade 8, chapter 2: Squares, roots, cubes and cube roots | 47–77 | 5 | 80 |
| Grade 8, chapter 3: Linear equations and inequalities | 78–94 | 4 | 64 |
| Grade 8, chapter 4: Similarity | 95–116 | 4 | 64 |
| Grade 8, chapter 5: Triangle theorems | 117–144 | 5 | 80 |
| Grade 8, chapter 6: Lines and angles in circles | 145–168 | 5 | 80 |
| Grade 8, chapter 7: Solids and measurement | 169–199 | 6 | 96 |
| Grade 8, chapter 8: Probability | 200–221 | 5 | 80 |

## Interaction blueprints

Each entry below has eight concrete seed configurations in the JSON. The two task modes are build and diagnose/repair; cosmetic variants are excluded.

### Foundations: Arithmetic foundations

#### f01 — Place value and zero placeholders

**Reference:** Foundation. **Prerequisites:** none; entry probe.

**Learner goal:** Pack a counted harvest into hundreds, tens and single units without changing its amount.

**Mathematical actions:**

1. Count single units into groups of ten.
2. Trade ten tens for one hundred.
3. Place bundles in labelled value columns, including an empty column.
4. Read and rebuild the numeral from its columns.

**Visible consequence:** The object count stays constant while the number of bundles changes; an empty tens column becomes a written zero.

**Definition/debrief:** A digit records how many units of its position there are. In 407, the 4 means 400, the 0 means no tens, and the 7 means seven ones.

**Misconception:** “407 is the same as 47 because zero means nothing.” **Response:** Compare four hundred-bundles with four ten-bundles; rebuild both numbers before reading them.

**Transfer question:** What is the value of 6 in 602? Explain the zero.

**Worked answer:** 6 is six hundreds, or 600. There are no tens and two ones, so 602 = 600 + 0 + 2.

**Generation constraints:** Use three-digit numbers with a zero tens column; never give a bundle two different values. Allow repeated trades but preserve the count.

**Seed example:** {"hundreds": 1, "tens": 0, "ones": 2} → 102. Eight parameter sets × two modes = 16 slots.

#### f02 — Addition with regrouping

**Reference:** Foundation. **Prerequisites:** f01.

**Learner goal:** Combine two deliveries and record their exact total.

**Mathematical actions:**

1. Build each delivery in tens and ones.
2. Merge the ones and count them.
3. Trade each group of ten ones into a ten.
4. Merge the tens and record each column.

**Visible consequence:** A carry appears only when ten same-size units are exchanged; no objects appear or vanish.

**Definition/debrief:** Addition combines quantities. Regrouping changes their representation, not their value: ten ones equal one ten.

**Misconception:** “Write a two-digit ones total in the ones column.” **Response:** Trade ten ones physically, then record the remaining ones and the new ten.

**Transfer question:** Find 48 + 37 and explain the carried 1.

**Worked answer:** 8 + 7 = 15 ones: exchange ten for a ten and leave five ones. 4 + 3 + 1 = 8 tens; total 85.

**Generation constraints:** Both addends positive two-digit integers; ones sum between 10 and 18. Show carry origin; use single units throughout.

**Seed example:** {"a": 27, "b": 38} → 65. Eight parameter sets × two modes = 16 slots.

#### f03 — Subtraction by exchanging a ten

**Reference:** Foundation. **Prerequisites:** f01.

**Learner goal:** Remove the requested supplies from stock and report what remains.

**Mathematical actions:**

1. Build the stock using tens and ones.
2. Notice when the requested ones exceed the loose ones.
3. Exchange one ten into ten ones.
4. Remove the requested tens and ones, then count the remainder.

**Visible consequence:** One tens bundle opens; the stock value stays fixed until units are removed.

**Definition/debrief:** Subtraction finds what remains or the difference. Exchanging a ten provides smaller units of the same value.

**Misconception:** “Always subtract the smaller digit from the larger digit.” **Response:** The digit positions belong to quantities. Rebuild 52 and remove 28; the operation cannot be changed to 8−2.

**Transfer question:** Find 63 − 28 and verify by addition.

**Worked answer:** 63 becomes five tens and thirteen ones. Remove two tens and eight ones: three tens and five ones, or 35. Check 35 + 28 = 63.

**Generation constraints:** Stock exceeds removal; stock ones fewer than removal ones. One exchange suffices in these introductory cases.

**Seed example:** {"stock": 52, "remove": 28} → 24. Eight parameter sets × two modes = 16 slots.

#### f04 — Multiplication and distributive arrays

**Reference:** Foundation. **Prerequisites:** f02.

**Learner goal:** Arrange equal rows of seedlings and count them without counting one at a time.

**Mathematical actions:**

1. Build the requested number of equal rows.
2. Count columns and label row count × column count.
3. Split the array at a convenient column.
4. Count each smaller rectangle and combine their totals.

**Visible consequence:** Two smaller rectangles exactly cover the original array with no overlap or gaps.

**Definition/debrief:** Multiplication counts equal groups. Splitting columns gives a(b+c)=ab+ac; rotating an array shows ab=ba.

**Misconception:** “3 × 5 means 3 + 5.” **Response:** Build three rows of five and compare their 15 cells with a line of eight cells.

**Transfer question:** Use a split to find 6 × 14.

**Worked answer:** Split 14 into 10 + 4: 6×10 + 6×4 = 60 + 24 = 84.

**Generation constraints:** Use 2–9 rows and 11–18 columns; preserve equal rows. Splits are disjoint and exhaustive.

**Seed example:** {"rows": 2, "columns": 11, "split": 10} → 22. Eight parameter sets × two modes = 16 slots.

#### f05 — Division as sharing and as grouping

**Reference:** Foundation. **Prerequisites:** f04.

**Learner goal:** Decide both how much each person receives and how many equal packs can be made.

**Mathematical actions:**

1. Share all items equally among a stated number of people.
2. Count each share and rebuild the total using multiplication.
3. Reset the items and make packs of the stated size.
4. Count packs and explain what the quotient counts in each layout.

**Visible consequence:** The same division facts can count items per person or number of packs; the labels change.

**Definition/debrief:** Division finds a missing factor. Sharing fixes the number of groups; grouping fixes the size of each group. Total = number of groups × size.

**Misconception:** “Every division answer counts people.” **Response:** Label each quotient with its unit and compare the two layouts.

**Transfer question:** There are 24 pencils. Share among 6 pupils; then pack 6 pencils per pack.

**Worked answer:** Sharing gives 24÷6 = 4 pencils per pupil. Grouping gives 24÷6 = 4 packs. Both verify as 6×4 = 24, with different units.

**Generation constraints:** Use divisible positive totals and nonzero divisors; do not hide remainders. The task must state what is fixed and the quotient unit.

**Seed example:** {"total": 12, "divisor": 6} → 2. Eight parameter sets × two modes = 16 slots.

#### f06 — Equal parts and the reference whole

**Reference:** Foundation. **Prerequisites:** f05.

**Learner goal:** Give a stated fraction of one loaf while keeping shares equal.

**Mathematical actions:**

1. Choose the complete loaf as one whole.
2. Divide it into equal-size parts.
3. Select the requested number of parts.
4. Compare with an unevenly cut candidate and reject unequal parts.

**Visible consequence:** Only equal partitions support counting selected parts as numerator over denominator; changing the whole changes the quantity.

**Definition/debrief:** a/b means a parts when one whole is divided into b equal parts, with b nonzero. The denominator counts equal parts of that same whole.

**Misconception:** “Any three pieces are three quarters.” **Response:** Overlay the pieces on a whole partitioned into four equal parts; unequal pieces cannot be counted as quarters.

**Transfer question:** A ribbon is cut into 8 equal pieces. What fraction is 3 pieces?

**Worked answer:** Three selected equal pieces out of eight form 3/8 of the original ribbon.

**Generation constraints:** Keep the whole fixed and denominators 2–9. No unequal pieces may be accepted as equal fractions.

**Seed example:** {"parts": 2, "selected": 1} → 1/2. Eight parameter sets × two modes = 16 slots.

#### f07 — Equivalent fractions through subdivision

**Reference:** Foundation. **Prerequisites:** f06, f04.

**Learner goal:** Describe the same selected length using finer equal parts.

**Mathematical actions:**

1. Shade a/b of a fixed strip.
2. Split every part into k equal smaller parts.
3. Count shaded parts and all parts.
4. Overlay the old and new shading, then write a/b = ak/bk.

**Visible consequence:** The shaded length stays unchanged as numerator and denominator both scale.

**Definition/debrief:** Equivalent fractions name the same number. Multiplying numerator and denominator by the same nonzero factor preserves the value.

**Misconception:** “Adding the same number to numerator and denominator preserves the fraction.” **Response:** Compare 1/2 with 2/3 using the same whole; their shaded lengths differ.

**Transfer question:** Show why 2/3 = 8/12.

**Worked answer:** Split each third into four parts. Two selected thirds become eight twelfths, so 2/3 = (2×4)/(3×4) = 8/12.

**Generation constraints:** Positive denominator, scale integer 2–9, and a fixed whole. Record subdivision of unshaded as well as shaded parts.

**Seed example:** {"a": 2, "b": 3, "k": 2} → 4/6. Eight parameter sets × two modes = 16 slots.

#### f08 — Decimal place value in money

**Reference:** Foundation. **Prerequisites:** f01, f07.

**Learner goal:** Pay an exact amount by trading whole birr into hundredths.

**Mathematical actions:**

1. Set one birr as one whole and one cent as 1/100.
2. Build an amount with whole, tenth and hundredth tokens.
3. Exchange one whole into ten tenths or one tenth into ten hundredths.
4. Write the amount as a decimal and a fraction.

**Visible consequence:** 0.5 birr and 0.50 birr occupy the same amount; 0.05 is visibly smaller.

**Definition/debrief:** Decimal positions are powers of ten. 3.25 = 3 + 2/10 + 5/100 = 325/100.

**Misconception:** “0.5 is smaller than 0.25 because 5 is smaller than 25.” **Response:** Express both in hundredths: 50/100 is greater than 25/100.

**Transfer question:** Write 4 birr and 7 cents as a decimal.

**Worked answer:** 7 cents is 7/100 birr, so the amount is 4.07 birr; 4.70 would mean 70 cents.

**Generation constraints:** Use exact hundredths; show leading zero for cents below ten. Prices are invented mathematical examples, not current market claims.

**Seed example:** {"birr": 1, "cents": 2} → 1.02. Eight parameter sets × two modes = 16 slots.

#### f09 — Length and squared/cubed units

**Reference:** Foundation. **Prerequisites:** f04, f01.

**Learner goal:** Measure the same object using consistent units before comparing it.

**Mathematical actions:**

1. Trade one metre length for 100 centimetre lengths.
2. Tile one square metre with rows and columns of square centimetres.
3. Stack cubic-centimetre layers to form one cubic metre.
4. Label length, area and volume with cm, cm² and cm³ respectively.

**Visible consequence:** A length scale of 100 produces 100² tiles for area and 100³ cubes for volume.

**Definition/debrief:** Units describe what is measured. 1 m = 100 cm, 1 m² = 10,000 cm², and 1 m³ = 1,000,000 cm³.

**Misconception:** “Multiply every metre-based measure by 100 to convert to centimetres.” **Response:** Count the two directions of area or three directions of volume separately.

**Transfer question:** Convert 2 m² to cm².

**Worked answer:** Each square metre has 100×100 square centimetres. Therefore 2 m² = 20,000 cm².

**Generation constraints:** Use integer measures 1–8 and a fixed metric conversion. Animation may aggregate blocks but must preserve the two/three-dimensional reasoning.

**Seed example:** {"square_metres": 1} → 10000. Eight parameter sets × two modes = 16 slots.

#### f10 — Operation order and grouping

**Reference:** Foundation. **Prerequisites:** f04, f05, f02.

**Learner goal:** Calculate a packing order that contains groups within groups.

**Mathematical actions:**

1. Build three boxes containing a fixed group plus loose items.
2. Write one expression for the physical grouping.
3. Evaluate the inner groups before the outer operation.
4. Build a different ungrouped expression and compare its result.

**Visible consequence:** Parentheses alter which objects are grouped; an operation tree shows the sequence.

**Definition/debrief:** Parentheses specify grouping. Multiplication/division are evaluated before addition/subtraction unless grouping changes the order; equal-priority operations go left to right.

**Misconception:** “All expressions are calculated strictly from left to right.” **Response:** Compare 3+4×2 with (3+4)×2 using the object groups.

**Transfer question:** Find 18 − 3×4 and (18 − 3)×4.

**Worked answer:** 18−3×4 = 18−12 = 6. (18−3)×4 = 15×4 = 60. Their groupings differ.

**Generation constraints:** Use positive integer operations and parentheses that visibly match the layout. Avoid unparenthesised ambiguous division notation.

**Seed example:** {"loose": 2, "groups": 3, "group_size": 4} → 14. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 1: Sets

#### g7s01 — Well-defined sets and membership

**Reference:** Grade 7, chapter 1, printed pp. 2–4. **Prerequisites:** f01.

**Learner goal:** Send each number card through a clear membership gate.

**Mathematical actions:**

1. Choose a rule whose answer is decidable, such as even numbers below 10.
2. Test each card against the whole rule.
3. Place accepted cards in the set and rejected cards outside.
4. Write one membership and one non-membership statement.

**Visible consequence:** A card is accepted only if it satisfies the stated property; a vague rule cannot decide every card.

**Definition/debrief:** A set is a well-defined collection. x∈A means x belongs to A; x∉A means it does not.

**Misconception:** “A set can be the nicest numbers.” **Response:** Ask how two people could always agree; replace subjective nicest with a testable property.

**Transfer question:** For A={2,4,6,8}, decide whether 6 and 7 belong.

**Worked answer:** 6∈A and 7∉A, because only 6 is listed.

**Generation constraints:** Generate finite integer universes with an explicit bound. Do not count repeated displays of one member as new set members.

**Seed example:** {"bound": 10, "rule": "positive even integers below bound"} → [2, 4, 6, 8]. Eight parameter sets × two modes = 16 slots.

#### g7s02 — Empty, finite and infinite sets; subsets

**Reference:** Grade 7, chapter 1, printed pp. 4–8. **Prerequisites:** g7s01.

**Learner goal:** Find every card in a smaller collection and show it also passes the larger rule.

**Mathematical actions:**

1. Build the finite displayed universe.
2. Place a set satisfying an extra restriction inside its parent set.
3. Check every smaller-set member against the parent rule.
4. Compare with an empty restriction and an unbounded continuing number rule.

**Visible consequence:** No member escapes the parent container; empty and unbounded rules differ from a merely empty screen.

**Definition/debrief:** A⊆B means every member of A belongs to B. An empty set has no members; finite means finitely many members; an infinite rule has no final member.

**Misconception:** “A set is infinite whenever its members are not currently all visible.” **Response:** Distinguish a hidden finite list from positive even numbers, which always have a next member.

**Transfer question:** Are {2,4} and ∅ subsets of {2,4,6}?

**Worked answer:** Both are subsets. Every member of {2,4} is in the larger set, and ∅ has no member that could fail the condition.

**Generation constraints:** Infinite sets must be specified by a continuing mathematical rule. Subset tasks include empty and proper subsets; do not confuse ∈ with ⊆.

**Seed example:** {"parent": [1, 2, 3, 4], "subset": [1, 2], "empty": []} → Both are subsets. Eight parameter sets × two modes = 16 slots.

#### g7s03 — Equal sets versus equal cardinality

**Reference:** Grade 7, chapter 1, printed pp. 9–10. **Prerequisites:** g7s01, f05.

**Learner goal:** Decide whether two collections contain the same members or only the same number.

**Mathematical actions:**

1. Pair each member of A with one member of B to compare counts.
2. Check identity of members rather than only the pairing count.
3. Reorder one collection and remove duplicates from its set display.
4. State equal sets, equal cardinality only, or neither.

**Visible consequence:** A full pairing proves equal cardinality; identity matching proves equality, independent of order.

**Definition/debrief:** Equal sets have exactly the same members. Equinumerous finite sets have the same number of members and may contain different objects.

**Misconception:** “Same number of members means equal sets.” **Response:** Pair {1,2,3} with {a,b,c}, then show that 1 is absent from the second set.

**Transfer question:** Compare {1,3,3,5} and {5,1,3}.

**Worked answer:** They are equal sets: both have members 1,3,5. Repetition and order do not change membership.

**Generation constraints:** Count distinct members only. Include reordered equal sets and different equal-size sets.

**Seed example:** {"A": [1, 2, 3], "B": [3, 1, 2], "C": ["a", "b", "c"]} → A=B; A and C have equal cardinality only. Eight parameter sets × two modes = 16 slots.

#### g7s04 — Union, intersection and disjoint sets

**Reference:** Grade 7, chapter 1, printed pp. 11–16. **Prerequisites:** g7s01.

**Learner goal:** Place every eligible card in a Venn region and collect either group or only shared members.

**Mathematical actions:**

1. Test each card against both set rules.
2. Place it in A only, B only, overlap, or outside.
3. Collect union using either membership; count overlap once.
4. Collect intersection using both memberships and check a disjoint comparison.

**Visible consequence:** The overlap belongs to both sets but contributes once to their union; an empty overlap signals disjointness.

**Definition/debrief:** A∪B contains members in A or B or both. A∩B contains members in both. Disjoint sets have empty intersection.

**Misconception:** “The union count is always n(A)+n(B).” **Response:** Route the shared cards once and use n(A∪B)=n(A)+n(B)−n(A∩B).

**Transfer question:** A={1,2,3}, B={3,4}. Find union and intersection.

**Worked answer:** A∪B={1,2,3,4}; A∩B={3}. The union count is 3+2−1=4.

**Generation constraints:** Finite universe explicitly includes every card. Exercise overlap, containment and disjoint cases; no duplicate objects in a region.

**Seed example:** {"A": [1, 2, 3], "B": [3, 4]} → union=[1, 2, 3, 4]; intersection=[3]. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 2: Integers

#### g7i01 — Integer opposites, absolute distance and ordering

**Reference:** Grade 7, chapter 2, printed pp. 24–35. **Prerequisites:** f03.

**Learner goal:** Mark positions above and below a common zero and find the higher position.

**Mathematical actions:**

1. Set zero as the reference level.
2. Place positive and negative measurements on equally spaced ticks.
3. Reflect a position across zero to find its opposite.
4. Order positions from left to right and compare distance from zero.

**Visible consequence:** −7 is farther from zero than −2 but lies to its left; position and distance answer different questions.

**Definition/debrief:** Integers extend whole numbers with negatives. Opposites sum to zero. Greater integers lie farther right on the number line.

**Misconception:** “−7 is greater than −2 because 7>2.” **Response:** Move from −7 toward −2 and observe movement to the right; compare positions before magnitudes.

**Transfer question:** Order −6,2,−1,0. What is the opposite of −6?

**Worked answer:** −6<−1<0<2. The opposite of −6 is 6, because −6+6=0.

**Generation constraints:** Use one reference level and fixed equal tick spacing. Never identify absolute magnitude with signed order.

**Seed example:** {"negative": -2, "positive": 1} → -2<0<1; opposite=2. Eight parameter sets × two modes = 16 slots.

#### g7i02 — Integer addition with zero pairs

**Reference:** Grade 7, chapter 2, printed pp. 36–38. **Prerequisites:** g7i01, f02.

**Learner goal:** Combine gains and debts to find the net change.

**Mathematical actions:**

1. Build positive and negative counters with equal unit value.
2. Combine the two collections.
3. Pair one positive and one negative into zero.
4. Count the unpaired counters and write the signed sum.

**Visible consequence:** Cancelled pairs contribute zero; the remaining sign depends on which side has more units.

**Definition/debrief:** Adding opposite equal quantities gives zero. Addition of unlike signs leaves their magnitude difference with the sign of the larger magnitude.

**Misconception:** “A negative sign means always subtract the smaller printed digit.” **Response:** Preserve counter signs and compare magnitudes before counting the leftovers.

**Transfer question:** Find −8+5 and 8+(−5).

**Worked answer:** Eight negative and five positive counters leave three negative: −3. Reversing signs leaves three positive: 3.

**Generation constraints:** Use integer magnitudes 1–12 and include unlike signs. Zero-pair cancellation must preserve the sum.

**Seed example:** {"a": -5, "b": 3} → -2. Eight parameter sets × two modes = 16 slots.

#### g7i03 — Subtracting a negative by removing debt

**Reference:** Grade 7, chapter 2, printed pp. 38–40. **Prerequisites:** g7i02.

**Learner goal:** Remove a stated debt or gain while preserving the initial balance.

**Mathematical actions:**

1. Represent the starting balance with counters.
2. Identify which signed counters must be removed.
3. Insert zero pairs if those counters are missing.
4. Remove exactly the requested counters and count the final balance.

**Visible consequence:** Removing negative counters leaves extra positive counters; inserting zero pairs does not change the starting balance.

**Definition/debrief:** Subtracting b is adding its opposite: a−b=a+(−b). Removing a debt increases a balance.

**Misconception:** “Subtracting always makes a number smaller.” **Response:** Begin with 2, add three zero pairs, remove three negative counters and inspect the resulting 5.

**Transfer question:** Find −2−(−5).

**Worked answer:** Insert three zero pairs into two negative counters, giving five negative and three positive counters. Remove five negative counters: three positives remain, so the result is 3.

**Generation constraints:** Clearly distinguish inserted pairs from actual gains. Keep removed quantity fixed and include negative starting balances.

**Seed example:** {"start": -2, "remove": -5} → 3. Eight parameter sets × two modes = 16 slots.

#### g7i04 — Why a negative times a negative is positive

**Reference:** Grade 7, chapter 2, printed pp. 41–43. **Prerequisites:** g7i02, g7i03, f04.

**Learner goal:** Extend a multiplication machine below zero while keeping equal steps and distribution consistent.

**Mathematical actions:**

1. Build 3×(−4), 2×(−4), 1×(−4) and 0×(−4) as repeated groups.
2. Decrease the first factor by one each time; remove one −4 group, so the output increases by 4.
3. Continue to −1×(−4), −2×(−4) and inspect the positive outputs.
4. Check that (2+(−2))×(−4)=0 using distribution; the two products must cancel.

**Visible consequence:** Outputs −12,−8,−4,0,4,8 form equal +4 steps; the new product must be +8 to cancel 2×(−4)=−8.

**Definition/debrief:** Integer multiplication extends equal-step scaling and the distributive law. Since a+(−a)=0, a(−b)+(−a)(−b)=0, so (−a)(−b)=ab. This is the reason behind the sign rule.

**Misconception:** “Two negative signs are crossed out because that is the rule.” **Response:** Ask what output would preserve zero and distribution; reject a negative output that fails the cancellation check.

**Transfer question:** Explain (−3)×(−5) without quoting the sign rule.

**Worked answer:** 3×(−5)=−15. Since (3+(−3))×(−5)=0, distribution gives −15+(−3)(−5)=0. The missing product must be +15.

**Generation constraints:** Use positive a,b in 2–9; never describe negative groups as a physical count. Repeated addition motivates nonnegative factors only; the continuation and distributive check justify negative factors.

**Seed example:** {"a": 2, "b": 4} → 8. Eight parameter sets × two modes = 16 slots.

#### g7i05 — Signed division and undefined division by zero

**Reference:** Grade 7, chapter 2, printed pp. 45–46. **Prerequisites:** g7i04, f05.

**Learner goal:** Find the missing signed multiplier that recreates the total.

**Mathematical actions:**

1. Write divisor × unknown = dividend.
2. Test a signed candidate using multiplication.
3. Adjust sign and magnitude until the product matches.
4. Try divisor zero and explain why a nonzero dividend cannot be reached.

**Visible consequence:** The quotient works only when multiplication returns the dividend; a zero divisor cannot give a unique inverse.

**Definition/debrief:** a÷b=q means bq=a, with b≠0. 0÷b=0 for nonzero b. Division by zero is undefined: for a≠0 there is no solution, and 0q=0 has no unique q.

**Misconception:** “a÷0 is zero.” **Response:** Test 0×0 against a nonzero a; the product cannot recreate the dividend.

**Transfer question:** Find −24÷(−6). Why is 24÷0 undefined?

**Worked answer:** (−6)×4=−24, so the quotient is 4. No number q gives 0×q=24, so 24÷0 is undefined.

**Generation constraints:** Regular generated divisors are nonzero and divide the dividend exactly. Zero-divisor probes are qualitative, never assigned a numeric answer.

**Seed example:** {"dividend": -12, "divisor": -6} → 2. Eight parameter sets × two modes = 16 slots.

#### g7i06 — Even and odd integers

**Reference:** Grade 7, chapter 2, printed pp. 47–49. **Prerequisites:** f05, g7i01.

**Learner goal:** Predict whether a signed count can be grouped into pairs.

**Mathematical actions:**

1. Pair the magnitude into twos and observe a leftover.
2. Place positive and negative cases on every-other integer ticks.
3. Combine two parity patterns and test the sum.
4. Write a general even or odd form using an integer k.

**Visible consequence:** Zero and negative even integers fit 2k; adding two odd integers creates an extra pair.

**Definition/debrief:** Even integers are 2k and odd integers are 2k+1 for some integer k. Parity concerns divisibility by 2, including negative integers.

**Misconception:** “Only positive whole numbers can be even.” **Response:** Use k=−3 to form −6=2(−3), and verify the signed division.

**Transfer question:** Is −7 odd? What is odd + odd?

**Worked answer:** −7=2(−4)+1, so it is odd. (2a+1)+(2b+1)=2(a+b+1), so odd+odd is even.

**Generation constraints:** Include zero and negative k; parity remains independent of sign. Use pairing for magnitude and algebra for signed generalisation.

**Seed example:** {"k": -1, "even": -2, "odd": -1} → even and odd respectively. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 3: Ratio, proportion and percentage

#### g7r01 — Ratio as linked batches

**Reference:** Grade 7, chapter 3, printed pp. 54–57. **Prerequisites:** f04, f07.

**Learner goal:** Make a mix with two quantities kept in a fixed ratio.

**Mathematical actions:**

1. Build one batch using two scoops of A and three of B.
2. Copy the entire batch rather than only one quantity.
3. Count each ingredient in several batches.
4. Simplify the count pair and distinguish part-to-part from part-to-whole.

**Visible consequence:** Every complete batch preserves A:B=2:3; A is 2/5 of the whole, not 2/3.

**Definition/debrief:** A ratio compares quantities in a stated order. Equivalent ratios multiply or divide both terms by the same positive factor.

**Misconception:** “A:B=2:3 means A is 2/3 of the total.” **Response:** Join all five units in one batch and count the A part out of five.

**Transfer question:** A mix has A:B=3:5. What fraction is A of the mix?

**Worked answer:** The total is 3+5=8 equal units. A is 3/8 of the mix; A:B remains 3:5.

**Generation constraints:** Quantities use compatible units before ratios are formed. Use complete batches and clearly name numerator/base.

**Seed example:** {"A": 2, "B": 3} → A:B=2:3; A/whole=2/5. Eight parameter sets × two modes = 16 slots.

#### g7r02 — Proportion and unit rates

**Reference:** Grade 7, chapter 3, printed pp. 58–62. **Prerequisites:** g7r01, f05, f09.

**Learner goal:** Find the cost of a different quantity under an explicitly constant rate.

**Mathematical actions:**

1. Convert quantities into one unit.
2. Divide a known total by its quantity to find one-unit cost.
3. Scale from one unit to the desired quantity.
4. Check both columns preserve the same cost/quantity ratio.

**Visible consequence:** The table scales multiplicatively; adding the same amount to each column breaks the constant rate.

**Definition/debrief:** A proportion states equality of ratios. Directly proportional quantities have a constant ratio y/x for nonzero x.

**Misconception:** “If quantity rises by 2, price rises by 2.” **Response:** Calculate the unit rate and compare the incorrect new ratio with the original.

**Transfer question:** 4 kg costs 120 birr. At the same rate, what does 7 kg cost?

**Worked answer:** One kg costs 120÷4=30 birr; 7 kg costs 7×30=210 birr. 120/4=210/7=30.

**Generation constraints:** State that the rate is constant and fees/discounts are absent. Use positive quantities; all compared units must match.

**Seed example:** {"known_quantity": 4, "known_cost": 40, "target_quantity": 7} → 70. Eight parameter sets × two modes = 16 slots.

#### g7r03 — Percent as hundredths and percentage amount

**Reference:** Grade 7, chapter 3, printed pp. 63–69. **Prerequisites:** f07, f08.

**Learner goal:** Allocate a specified percent of a quantity and distinguish rate from amount.

**Mathematical actions:**

1. Shade p squares in a hundred-grid.
2. Write p/100 and its decimal equivalent.
3. Scale the whole grid from 100 units to the specified whole.
4. Count the selected amount and the remainder.

**Visible consequence:** The same shaded rate produces different amounts when the whole changes.

**Definition/debrief:** p% means p/100. Percentage amount = (p/100)×whole; the rate alone does not specify an amount.

**Misconception:** “20% always means 20 units.” **Response:** Compare 20 shaded hundredths of wholes 50 and 200; the amounts are 10 and 40.

**Transfer question:** Find 15% of 240.

**Worked answer:** 15/100×240=36. The rate is 15%; the amount is 36 units.

**Generation constraints:** State the reference whole and unit. Use percent rates 5–40 and wholes producing exact amounts.

**Seed example:** {"percent": 5, "whole": 200} → 10. Eight parameter sets × two modes = 16 slots.

#### g7r04 — Profit and loss percentage base

**Reference:** Grade 7, chapter 3, printed pp. 70–73. **Prerequisites:** g7r03, g7i03.

**Learner goal:** Set a selling price and report profit or loss relative to buying price.

**Mathematical actions:**

1. Record buying and selling prices in separate columns.
2. Subtract buying price from selling price.
3. Mark positive profit or negative loss.
4. Compare the magnitude with buying price and convert to percent.

**Visible consequence:** The rate uses buying price as its base, even when the displayed selling price is larger.

**Definition/debrief:** Profit = selling−buying and loss = buying−selling when positive. Profit/loss percent = amount/buying price×100%.

**Misconception:** “Divide profit by selling price.” **Response:** Place the original investment as the whole; compare both candidate denominators with that whole.

**Transfer question:** Buy for 400 birr and sell for 460 birr. Find profit percent.

**Worked answer:** Profit=460−400=60 birr. Profit rate=60/400×100%=15%.

**Generation constraints:** Buying price positive; alternate profit and loss cases. Prices are invented examples; never reverse the base silently.

**Seed example:** {"buy": 200, "sell": 210} → profit=10; rate=5%. Eight parameter sets × two modes = 16 slots.

#### g7r05 — Simple interest

**Reference:** Grade 7, chapter 3, printed pp. 73–76. **Prerequisites:** g7r03, g7r02.

**Learner goal:** Calculate interest charged on the original principal for each equal time period.

**Mathematical actions:**

1. Mark original principal P and annual rate r.
2. Compute one year of interest Pr.
3. Add the same interest amount for each year on a timeline.
4. Separate total interest from principal plus interest and check the time unit.

**Visible consequence:** The annual increment is constant because the reference principal remains P.

**Definition/debrief:** Simple interest is I=Prt, with rate and time in matching units. Accumulated amount is P+I.

**Misconception:** “After each year calculate the next interest on the growing total.” **Response:** Keep an original-principal marker fixed; growing-base interest belongs to a different model.

**Transfer question:** At simple interest, P=800 birr, r=5% per year, t=3 years. Find I and total.

**Worked answer:** I=800×0.05×3=120 birr; total=800+120=920 birr.

**Generation constraints:** Annual rate paired with years; convert months explicitly. No fees or payments; distinguish annual increment, interest total, and final amount.

**Seed example:** {"principal": 1000, "annual_percent": 5, "years": 1} → I=50; total=1050. Eight parameter sets × two modes = 16 slots.

#### g7r06 — Compound interest

**Reference:** Grade 7, chapter 3, printed pp. 77–79. **Prerequisites:** g7r05, f04.

**Learner goal:** Calculate repeated growth when each period includes previous interest.

**Mathematical actions:**

1. Start with P and mark the compounding period.
2. Calculate the period interest on the current balance.
3. Add it and move the new balance into the next period.
4. Compare the increments with a simple-interest timeline.

**Visible consequence:** The second increment is larger because the first interest is now part of the base.

**Definition/debrief:** With constant rate r per compounding period and no payments, A=P(1+r)^n. Total interest is A−P; r and n refer to the same period.

**Misconception:** “Compound interest equals Prn.” **Response:** Calculate the second increment from the updated balance and compare with the fixed original base.

**Transfer question:** 1000 birr grows at 10% compounded annually for 2 years.

**Worked answer:** Year 1: 1000+100=1100. Year 2: 1100+110=1210. Interest=210 birr; simple interest would be 200.

**Generation constraints:** Use annual compounding, two periods, no deposits/withdrawals. Keep exact arithmetic; specify final-money rounding separately if introduced.

**Seed example:** {"principal": 1000, "annual_percent": 10, "periods": 2} → 1210. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 4: Linear equations

#### g7e01 — Variables, terms and like terms

**Reference:** Grade 7, chapter 4, printed pp. 87–94. **Prerequisites:** f04, g7i02.

**Learner goal:** Combine packages while preserving what each symbol measures.

**Mathematical actions:**

1. Assign x to the unknown contents of one identical bag.
2. Represent 3x and 2x as three and two bags.
3. Combine matching bags and keep loose units separate.
4. Compare x with x² tiles to reject unlike terms.

**Visible consequence:** Bag coefficients add; a loose constant or square unit cannot be merged into a bag count.

**Definition/debrief:** A variable represents a number. Like terms share the same variable factors and powers; ax+bx=(a+b)x.

**Misconception:** “3x+2 becomes 5x.” **Response:** Build three bags plus two loose units and compare with five complete bags.

**Transfer question:** Simplify 4x+3+2x−1.

**Worked answer:** Combine x terms: 4x+2x=6x. Combine constants: 3−1=2. Result: 6x+2.

**Generation constraints:** Variables have consistent meaning throughout. Include constants and unlike powers; never combine x and x².

**Seed example:** {"a": 2, "b": 3, "constant": 2} → 5x+2. Eight parameter sets × two modes = 16 slots.

#### g7e02 — Distributing through brackets

**Reference:** Grade 7, chapter 4, printed pp. 92–94, 102–104. **Prerequisites:** f04, g7e01, g7i04.

**Learner goal:** Unpack repeated mixed bundles into an equivalent expression.

**Mathematical actions:**

1. Build a group containing x bags and b loose units.
2. Duplicate the whole group a times.
3. Collect bags and loose units separately.
4. Reverse the grouping and compare both expressions for a test value.

**Visible consequence:** Every item in the brackets gets the multiplier; partial expansion leaves missing items.

**Definition/debrief:** Distribution gives a(x+b)=ax+ab. A negative multiplier reverses every signed term, not only the first.

**Misconception:** “a(x+b)=ax+b.” **Response:** Count the b loose units in every copied group and identify the omitted copies.

**Transfer question:** Expand −2(x−3).

**Worked answer:** −2×x + (−2)×(−3)=−2x+6. At x=4 both expressions equal −2.

**Generation constraints:** Start with positive copying, then use signed scaling for negatives. Test equivalent expressions with multiple values; examples do not alone prove the law.

**Seed example:** {"a": 2, "b": 3, "test_x": 4} → 2x+6. Eight parameter sets × two modes = 16 slots.

#### g7e03 — Maintaining equality while solving

**Reference:** Grade 7, chapter 4, printed pp. 95–101. **Prerequisites:** g7e01, f05.

**Learner goal:** Find the unknown bag size while keeping two trays equal.

**Mathematical actions:**

1. Build ax+b=c as equal trays of bags and loose units.
2. Remove b from both trays.
3. Partition both trays into a equal shares.
4. Open one bag, state x and substitute into the original equation.

**Visible consequence:** The trays remain equal after the same valid operation on both sides; a one-sided change breaks the equality.

**Definition/debrief:** An equation asserts equal values. Applying the same addition/subtraction or multiplying/dividing by the same nonzero number preserves its solutions.

**Misconception:** “Move a term across and change its sign without a reason.” **Response:** Replay removing the same quantity from both sides; record that operation before simplifying.

**Transfer question:** Solve 3x+4=19 and verify.

**Worked answer:** Subtract 4 from both sides: 3x=15. Divide both by 3: x=5. Check 3×5+4=19.

**Generation constraints:** a nonzero; initial concrete bags use a positive integer. Always verify in the original equation, not only the transformed one.

**Seed example:** {"a": 3, "b": 4, "c": 10} → 2. Eight parameter sets × two modes = 16 slots.

#### g7e04 — Equations with fractional coefficients

**Reference:** Grade 7, chapter 4, printed pp. 102–106. **Prerequisites:** g7e03, f07.

**Learner goal:** Recover a whole quantity from a fractional share and a fixed addition.

**Mathematical actions:**

1. Show a/b of an unknown strip plus a constant equal to a known strip.
2. Remove the constant from both sides.
3. Split the remaining known strip into a pieces to find one b-th.
4. Combine b such pieces and substitute the resulting whole.

**Visible consequence:** One numerator-unit becomes identifiable before the denominator-units are recombined into the whole.

**Definition/debrief:** Solving (a/b)x+c=d uses equality-preserving operations: x=(d−c)b/a, with a,b nonzero.

**Misconception:** “Multiply the final remainder by a/b again.” **Response:** The remainder is already a/b of the whole; find one b-th before rebuilding all b parts.

**Transfer question:** Solve (2/3)x+5=13.

**Worked answer:** Subtract 5: (2/3)x=8. One third is 4; three thirds give x=12. Check (2/3)×12+5=13.

**Generation constraints:** a,b positive, a<b; choose d−c divisible by a for exact concrete partitions. Do not cancel terms across addition.

**Seed example:** {"a": 2, "b": 3, "c": 5, "d": 9} → 6. Eight parameter sets × two modes = 16 slots.

#### g7e05 — Ordered pairs and coordinates

**Reference:** Grade 7, chapter 4, printed pp. 107–114. **Prerequisites:** g7i01.

**Learner goal:** Locate a supply point from its two-coordinate address.

**Mathematical actions:**

1. Mark origin and positive directions on perpendicular axes.
2. Move horizontally by x, then vertically by y.
3. Place the point and read its ordered pair.
4. Swap coordinates to locate another point and explain the change.

**Visible consequence:** The swapped address usually reaches a different point; negative coordinates locate opposite directions.

**Definition/debrief:** An ordered pair (x,y) gives horizontal coordinate first and vertical second. The origin is (0,0).

**Misconception:** “(−2,3) means two up and three left.” **Response:** Trace the first movement along the x-axis and record the horizontal step first.

**Transfer question:** Locate (−3,2). Which quadrant contains it?

**Worked answer:** Move 3 units left and 2 up. x<0 and y>0, so the point is in quadrant II.

**Generation constraints:** Equal spacing and labelled axes; quadrants exclude points on axes. Generated points must distinguish x and y.

**Seed example:** {"x": -2, "y": 1} → quadrant II. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 5: Perimeter and area of plane figures

#### g7a01 — Quadrilateral properties and construction

**Reference:** Grade 7, chapter 5, printed pp. 128–146. **Prerequisites:** f09.

**Learner goal:** Build a quadrilateral that meets side and angle requirements.

**Mathematical actions:**

1. Join four sides into a closed figure.
2. Adjust vertices while preserving the required parallel or equal sides.
3. Measure angles and test a right-angle requirement.
4. Classify the resulting figure in all applicable families.

**Visible consequence:** A rhombus can tilt without becoming a square; a square meets rectangle and rhombus properties simultaneously.

**Definition/debrief:** A parallelogram has both pairs of opposite sides parallel. A rectangle adds four right angles; a rhombus adds four equal sides; a square has both extra properties.

**Misconception:** “A square cannot be a rectangle because it has its own name.” **Response:** Test all rectangle properties on the square; categories can overlap.

**Transfer question:** Is every rhombus a square? Is every square a rhombus?

**Worked answer:** Not every rhombus has right angles, so not every rhombus is a square. Every square has four equal sides, so every square is a rhombus.

**Generation constraints:** Use actual geometric constraints, not approximate visual resemblance. Keep shapes nondegenerate; measure angles when classification needs them.

**Seed example:** {"side": 2, "angle_degrees": 60, "opposite_angle": 120} → rhombus; not square. Eight parameter sets × two modes = 16 slots.

#### g7a02 — Perimeter versus area

**Reference:** Grade 7, chapter 5, printed pp. 147, 160–164. **Prerequisites:** f04, f09.

**Learner goal:** Choose how much boundary fencing and interior flooring a rectangle needs.

**Mathematical actions:**

1. Trace and sum every outside edge.
2. Tile the interior with unit squares.
3. Change dimensions while holding one measure fixed.
4. Report both values using length and square units.

**Visible consequence:** Equal perimeter rectangles can contain different tile counts; boundary and interior respond differently.

**Definition/debrief:** Perimeter is total boundary length. Area counts square units covering the interior.

**Misconception:** “Area and perimeter are interchangeable numbers.” **Response:** Compare 1×5 and 2×4 rectangles: perimeter 12 in both, areas 5 and 8.

**Transfer question:** For a 7 m × 4 m rectangle find perimeter and area.

**Worked answer:** P=2(7+4)=22 m. A=7×4=28 m².

**Generation constraints:** Use consistent units and positive dimensions. Boundary tracing must not count internal tile edges.

**Seed example:** {"length": 5, "width": 3} → P=16; A=15. Eight parameter sets × two modes = 16 slots.

#### g7a03 — Parallelogram area and perpendicular height

**Reference:** Grade 7, chapter 5, printed pp. 147–150. **Prerequisites:** g7a02.

**Learner goal:** Cover a slanted plot with tiles by rearranging it into a rectangle.

**Mathematical actions:**

1. Drop a perpendicular from the top edge to the base.
2. Cut the side triangle along that perpendicular.
3. Slide the triangle to the opposite side.
4. Count the rectangle tiles and compare with the original slanted plot.

**Visible consequence:** The rearranged rectangle has the same area and perpendicular height; the sloping side is not its height.

**Definition/debrief:** Parallelogram area is base × perpendicular height. Cutting and rearranging preserves area; perimeter need not be preserved.

**Misconception:** “Use the slanted side as h.” **Response:** Display a right-angle marker on the perpendicular and compare it with the sloping edge.

**Transfer question:** A parallelogram has base 9 cm, perpendicular height 4 cm, sloping side 5 cm. Find area.

**Worked answer:** A=9×4=36 cm². The 5 cm sloping side is not the perpendicular height.

**Generation constraints:** Base and height positive; drawn offset must fit the cut-slide construction. Never infer height from visual slant.

**Seed example:** {"base": 5, "height": 4, "sloping_side": 5} → 20. Eight parameter sets × two modes = 16 slots.

#### g7a04 — Triangle area through duplication

**Reference:** Grade 7, chapter 5, printed pp. 153–155. **Prerequisites:** g7a03, f06.

**Learner goal:** Find a triangular covering as half of a matching doubled shape.

**Mathematical actions:**

1. Copy a triangle with a marked base and perpendicular height.
2. Rotate the copy to form a parallelogram.
3. Calculate the combined area as bh.
4. Divide by two and verify both copies cover equal area.

**Visible consequence:** Two congruent triangles fill the doubled shape, so one needs half the tiles.

**Definition/debrief:** Triangle area is bh/2, where h is perpendicular to the chosen base, including an external altitude for an obtuse triangle.

**Misconception:** “All three side lengths are needed to use A=bh/2.” **Response:** Find the base-altitude pair; side lengths alone are a different representation.

**Transfer question:** A triangle has base 12 m and perpendicular height 5 m. Find area.

**Worked answer:** The doubled shape has 12×5=60 m², so the triangle has 60÷2=30 m².

**Generation constraints:** Draw true perpendicular altitudes; include an obtuse case as a later representation. Do not replace altitude with an adjacent side.

**Seed example:** {"base": 6, "height": 5} → 15. Eight parameter sets × two modes = 16 slots.

#### g7a05 — Circle circumference and area

**Reference:** Grade 7, chapter 5, printed pp. 156–159. **Prerequisites:** g7a02, f07.

**Learner goal:** Measure a circular boundary and estimate the covering inside it.

**Mathematical actions:**

1. Mark radius and diameter and compare d=2r.
2. Roll the boundary along a line to compare circumference with diameter.
3. Cut the disc into narrow sectors and alternate them into an approximate rectangle.
4. Read limiting dimensions πr and r, then distinguish C=2πr from A=πr².

**Visible consequence:** Rolling gives a length; sector rearrangement gives an area approaching a rectangle as sectors narrow.

**Definition/debrief:** π is circumference/diameter. Circumference=2πr and circle area=πr². Sector rearrangement motivates area; a finite jagged layout is an approximation.

**Misconception:** “Use πd² for circle area.” **Response:** Compare radius and diameter before squaring; substituting d=2r gives area πd²/4.

**Transfer question:** For radius 7 cm use π=22/7 to find circumference and area.

**Worked answer:** C=2×(22/7)×7=44 cm. A=(22/7)×49=154 cm².

**Generation constraints:** State whether π is exact or use the stated approximation. No acceptance based only on matching a finite sector picture.

**Seed example:** {"radius": 7, "pi": "22/7"} → C=44; A=154. Eight parameter sets × two modes = 16 slots.

#### g7a06 — Trapezoid and composite area

**Reference:** Grade 7, chapter 5, printed pp. 150–152,160–164. **Prerequisites:** g7a04, g7a02.

**Learner goal:** Cover a plot made from a rectangle and a triangle without overlap.

**Mathematical actions:**

1. Mark the two parallel bases and perpendicular separation.
2. Split the trapezoid into a rectangle plus triangle.
3. Calculate each disjoint piece and add.
4. Recombine into A=(a+b)h/2 and trace the external boundary separately.

**Visible consequence:** The pieces cover the entire plot once; internal cut lines add no perimeter.

**Definition/debrief:** A trapezoid with parallel bases a,b and perpendicular height h has area (a+b)h/2. Composite area sums disjoint pieces or subtracts a cut-out.

**Misconception:** “Add every cut-line length to the perimeter.” **Response:** Hide internal edges after recombination and trace only the exposed boundary.

**Transfer question:** Parallel bases are 6 m and 10 m; height 4 m. Find area.

**Worked answer:** Rectangle 6×4=24 m² and extra triangle (10−6)×4/2=8 m²; total 32 m².

**Generation constraints:** Parallel bases positive; h perpendicular. Only disjoint pieces may be summed; do not infer slanted edge lengths from height.

**Seed example:** {"short_base": 4, "long_base": 8, "height": 4} → 24. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 6: Congruence

#### g7c01 — Congruence and correct correspondence

**Reference:** Grade 7, chapter 6, printed pp. 168–173. **Prerequisites:** g7a01.

**Learner goal:** Match a replacement shape exactly to a template without resizing.

**Mathematical actions:**

1. Translate, rotate or reflect the candidate.
2. Overlay all vertices and edges.
3. Label which vertex meets each template vertex.
4. Write corresponding sides and the congruence statement in matching order.

**Visible consequence:** A rigid match preserves every length and angle; an enlarged similar figure fails the overlay.

**Definition/debrief:** Congruent figures have the same size and shape. Triangle order records correspondence: ABC≅DEF means A↔D, B↔E, C↔F.

**Misconception:** “Figures pointing in different directions cannot be congruent.” **Response:** Rotate or reflect one without changing its dimensions and check the overlay.

**Transfer question:** If ABC≅PQR, which side corresponds to BC?

**Worked answer:** B↔Q and C↔R, so BC corresponds to QR. AC corresponds to PR.

**Generation constraints:** Use rigid transformations only; scaling is disabled. Generated triangles are nondegenerate and vertex order is stored explicitly.

**Seed example:** {"legs": [3, 4], "rotation_degrees": 30, "map": {"A": "P", "B": "Q", "C": "R"}} → BC↔QR; AC↔PR. Eight parameter sets × two modes = 16 slots.

#### g7c02 — SSS triangle congruence

**Reference:** Grade 7, chapter 6, printed pp. 174–175. **Prerequisites:** g7c01.

**Learner goal:** Build a unique triangle template from three side lengths.

**Mathematical actions:**

1. Lay one side as a fixed base.
2. Draw radius constraints from both base endpoints for the other two sides.
3. Choose an intersection and close the triangle.
4. Reflect the alternate intersection and overlay it to justify congruence.

**Visible consequence:** Two mirror placements exist but give congruent triangles; impossible side lengths produce no intersection.

**Definition/debrief:** SSS: three pairs of corresponding equal sides establish triangle congruence. Triangle side lengths must satisfy strict triangle inequalities.

**Misconception:** “Any three positive lengths form a triangle.” **Response:** Try 2,3,6; the short sides cannot meet, because 2+3<6.

**Transfer question:** Do sides 4,5,7 form a triangle? Are two such triangles congruent?

**Worked answer:** Yes: 4+5>7 and the other inequalities hold. Two triangles with these three corresponding sides are congruent by SSS.

**Generation constraints:** All three strict triangle inequalities required. Reflected closure is a congruent solution, not a new shape size.

**Seed example:** {"sides": [3, 4, 5]} → valid; SSS determines congruence. Eight parameter sets × two modes = 16 slots.

#### g7c03 — SAS congruence and the included angle

**Reference:** Grade 7, chapter 6, printed pp. 175–177. **Prerequisites:** g7c01.

**Learner goal:** Make a rigid triangle from two lengths and their included angle.

**Mathematical actions:**

1. Attach two specified rods at the same vertex.
2. Set the angle between those rods.
3. Connect their free endpoints.
4. Compare with another assembly and test why a nonincluded angle does not give the same guarantee.

**Visible consequence:** The included hinge angle fixes the distance between rod endpoints; a free wrong hinge changes the third side.

**Definition/debrief:** SAS congruence requires two corresponding side lengths and the included angle between them to be equal. An arbitrary side-side-angle claim is insufficient.

**Misconception:** “Two sides and any angle always prove congruence.” **Response:** Highlight the angle between the known sides, then construct a different valid triangle when information is not included.

**Transfer question:** AB=DE=5, AC=DF=7, ∠A=∠D=60°. Is ABC≅DEF?

**Worked answer:** Yes by SAS, because ∠A and ∠D are included between the specified side pairs and correspondence is A↔D, B↔E, C↔F.

**Generation constraints:** Angle strictly between 0° and 180° and explicitly included. Do not silently accept SSA as a general congruence criterion.

**Seed example:** {"side1": 3, "side2": 5, "included_angle": 60} → SAS congruent. Eight parameter sets × two modes = 16 slots.

#### g7c04 — ASA congruence and short proof chains

**Reference:** Grade 7, chapter 6, printed pp. 177–185. **Prerequisites:** g7c01, g7c03.

**Learner goal:** Rebuild a triangle and justify each fact used to prove a match.

**Mathematical actions:**

1. Lay a specified base shared by two known endpoint angles.
2. Construct the two rays and find their intersection.
3. Pair the equal angle, included side and equal angle facts.
4. Arrange statements with reasons and conclude ASA congruence.

**Visible consequence:** The base length fixes scale while both rays fix the third vertex; equal angles alone would allow larger copies.

**Definition/debrief:** ASA: two corresponding equal angles and the included equal side establish congruence. A proof must connect each fact to a given, shared part or established property.

**Misconception:** “Three equal angles prove congruence.” **Response:** Keep both base angles but double the base; the new triangle is similar and larger.

**Transfer question:** Two triangles have endpoint angles 40° and 70° on equal 6 cm bases. What proves congruence?

**Worked answer:** The two equal angles and the equal side between them give ASA. The third angle is 180−40−70=70°.

**Generation constraints:** Endpoint angles positive and sum below 180°. Each proof step has a valid reason; equal angles alone cannot fix size.

**Seed example:** {"base": 3, "angle1": 40, "angle2": 60} → ASA; third angle 80°. Eight parameter sets × two modes = 16 slots.

### Grade 7, chapter 7: Data handling

#### g7d01 — Frequency tables and tallies

**Reference:** Grade 7, chapter 7, printed pp. 190–192. **Prerequisites:** f01, g7s01.

**Learner goal:** Summarise every observation without losing or duplicating data.

**Mathematical actions:**

1. Take one raw observation at a time.
2. Add a tally to its category, grouping tallies in fives.
3. Convert tallies into frequency numbers.
4. Sum frequencies and compare with the raw observation count.

**Visible consequence:** Each datum contributes once; the frequency total catches missing or duplicated observations.

**Definition/debrief:** A frequency counts how often a value/category occurs. A frequency table preserves the total number of observations.

**Misconception:** “A category label contributes one count regardless of how often it occurs.” **Response:** Return to the raw list and move one observation per tally.

**Transfer question:** For 2,3,2,1,3,2, make a frequency table.

**Worked answer:** 1 occurs once, 2 occurs three times, 3 occurs twice; total 1+3+2=6 observations.

**Generation constraints:** Use finite disjoint categories, including zero-frequency categories when relevant. No datum may enter two categories.

**Seed example:** {"frequencies": [1, 2, 3]} → total=6. Eight parameter sets × two modes = 16 slots.

#### g7d02 — Pie charts as proportional angles

**Reference:** Grade 7, chapter 7, printed pp. 193–197. **Prerequisites:** g7r03, g7d01.

**Learner goal:** Allocate a whole circle to categories in proportion to their counts.

**Mathematical actions:**

1. Count all observations as the whole.
2. Convert each frequency to a fraction of the total.
3. Multiply the fraction by 360° and turn the sector boundary.
4. Check sector angles total 360° and recover a count from one sector.

**Visible consequence:** Larger shares get larger angles; all sectors exactly fill one complete turn.

**Definition/debrief:** A pie-sector angle is frequency/total×360°. Count=angle/360°×total when the total is known.

**Misconception:** “A 40° sector always represents 40 observations.” **Response:** Compare the same angle in totals 90 and 180; its fraction is constant, its count is not.

**Transfer question:** Of 40 learners, 10 choose a category. Find its sector angle.

**Worked answer:** 10/40×360°=90°, one quarter of the circle.

**Generation constraints:** Positive total, nonnegative counts summing to total. Use counts making exact integer angles initially; define rounding for later cases.

**Seed example:** {"counts": [1, 2, 9], "total": 12} → angles=[30, 60, 270]. Eight parameter sets × two modes = 16 slots.

#### g7d03 — Mean as fair share

**Reference:** Grade 7, chapter 7, printed pp. 198–201. **Prerequisites:** f05, g7d01.

**Learner goal:** Redistribute unequal collected amounts into equal shares and name their average.

**Mathematical actions:**

1. Build one stack for each datum.
2. Move units from taller to shorter stacks without changing the total.
3. Divide the total by the number of stacks.
4. Mark the equal height and compare it with the original data.

**Visible consequence:** Total is conserved; the mean can be a fractional value absent from the original list.

**Definition/debrief:** Arithmetic mean = sum of values/number of values. It is the equal share if the total is redistributed.

**Misconception:** “The mean must be one of the original values.” **Response:** Redistribute stacks 2 and 3 into two equal 2.5 shares.

**Transfer question:** Find the mean of 4,7,10.

**Worked answer:** Total=21 and there are 3 values. Mean=21÷3=7.

**Generation constraints:** Data units identical and count positive. Half units are permitted; do not round mean silently.

**Seed example:** {"data": [2, 5, 8]} → 5. Eight parameter sets × two modes = 16 slots.

#### g7d04 — Median for odd and even data counts

**Reference:** Grade 7, chapter 7, printed pp. 203–205. **Prerequisites:** g7i01, g7d01, g7d03.

**Learner goal:** Find the centre position of an ordered collection.

**Mathematical actions:**

1. Sort every datum while retaining duplicate occurrences.
2. Remove one lowest and one highest position together.
3. For odd count select the final middle datum.
4. For even count average the final two central values.

**Visible consequence:** The median depends on ordered positions, not the original display order; an even-count median can lie between data values.

**Definition/debrief:** Median is the middle value of sorted data for odd count, or the mean of the two central values for even count.

**Misconception:** “Pick the middle entry before sorting.” **Response:** Shuffle the same data and show that unsorted middle entries change; sorted centre does not.

**Transfer question:** Find the median of 9,2,6,4.

**Worked answer:** Sort: 2,4,6,9. The central values are 4 and 6; median=(4+6)/2=5.

**Generation constraints:** Keep duplicate observations; do not convert data into a mathematical set. Include odd and even counts across build/repair tasks.

**Seed example:** {"data": [9, 2, 6, 4]} → 5. Eight parameter sets × two modes = 16 slots.

#### g7d05 — Mode and multiple/no modes

**Reference:** Grade 7, chapter 7, printed pp. 201–203. **Prerequisites:** g7d01.

**Learner goal:** Identify which recorded value occurs most often.

**Mathematical actions:**

1. Build frequencies from raw data.
2. Stack occurrences above each distinct value.
3. Select every value tied for the highest frequency.
4. Compare a clear peak, tied peaks, and all-equal frequencies.

**Visible consequence:** A mode depends on occurrence count, not numerical size; two tallest stacks can yield two modes.

**Definition/debrief:** Mode is a most frequent value. Following this book, report no mode when all displayed distinct values have equal frequency; multiple unequal-frequency peaks may give multiple modes.

**Misconception:** “The largest value is the mode.” **Response:** Use 2,2,2,9; the tallest frequency stack is at 2.

**Transfer question:** Find mode(s) of 1,1,2,3,3,4.

**Worked answer:** 1 and 3 each occur twice; 2 and 4 once. The two modes are 1 and 3.

**Generation constraints:** Use the stated textbook convention for all-equal frequencies. Do not invent one mode when maximum frequency is tied.

**Seed example:** {"data": [1, 1, 2, 3, 3]} → 1 and 3. Eight parameter sets × two modes = 16 slots.

#### g7d06 — Range and effect of outliers

**Reference:** Grade 7, chapter 7, printed pp. 206–209. **Prerequisites:** g7i03, g7d04.

**Learner goal:** Compare the spread of two data collections using their endpoint distance.

**Mathematical actions:**

1. Place observations on a number line.
2. Identify minimum and maximum.
3. Measure the span maximum−minimum.
4. Move an extreme datum and compare range and centre measures.

**Visible consequence:** Interior changes can leave range unchanged; an extreme change can alter it sharply.

**Definition/debrief:** Range is maximum minus minimum. It measures endpoint spread and can be sensitive to extreme values.

**Misconception:** “Range is the number of observations.” **Response:** Count observations and measure endpoint distance separately.

**Transfer question:** Find range of −2,4,9,4.

**Worked answer:** Maximum=9; minimum=−2. Range=9−(−2)=11.

**Generation constraints:** Positive observation count; signed data allowed with consistent units. Do not claim range describes all distribution features.

**Seed example:** {"data": [-2, 3, 7]} → 9. Eight parameter sets × two modes = 16 slots.

#### g7d07 — Missing datum and weighted combined mean

**Reference:** Grade 7, chapter 7, printed pp. 200–201,210–213. **Prerequisites:** g7d03, g7e03.

**Learner goal:** Recover an unknown total before finding a missing value or combining groups.

**Mathematical actions:**

1. Multiply a stated mean by its observation count to recover the total.
2. Subtract known values to find an unknown datum.
3. For two groups reconstruct each total separately.
4. Add totals and divide by combined counts, then check the mean.

**Visible consequence:** Groups with different counts contribute different weights; averaging two means alone can give the wrong result.

**Definition/debrief:** Total=mean×count. A combined mean is (n₁m₁+n₂m₂)/(n₁+n₂), with nonzero combined count.

**Misconception:** “The mean of two groups is always (m₁+m₂)/2.” **Response:** Show two observations at 4 and four at 10; six values have mean 8, not 7.

**Transfer question:** Two values have mean 4; four other values have mean 10. Find the mean of all six.

**Worked answer:** Totals are 2×4=8 and 4×10=40. Combined mean=(8+40)/6=8.

**Generation constraints:** Counts are positive integers and stated explicitly. Missing-value tasks include enough information and verify the reconstructed total.

**Seed example:** {"n1": 2, "mean1": 3, "n2": 4, "mean2": 9} → 7. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 1: Rational numbers

#### g8q01 — Rational numbers and nested number sets

**Reference:** Grade 8, chapter 1, printed pp. 2–6. **Prerequisites:** g7s02, g7i01, f06.

**Learner goal:** Place each number in every number family it belongs to.

**Mathematical actions:**

1. Write a rational number as p/q with integer p,q and q≠0.
2. Place counting numbers inside whole numbers, then integers, then rationals.
3. Rewrite an integer as n/1.
4. Compare 0, a negative integer, and a noninteger fraction using all relevant memberships.

**Visible consequence:** A negative integer belongs to integers and rationals, while 0 is whole but not counting in this book’s convention.

**Definition/debrief:** A rational number can be written p/q with integers p,q and q≠0. Here counting numbers start at 1; whole numbers include 0; integers include negatives.

**Misconception:** “A number written as a fraction cannot be an integer.” **Response:** Simplify 6/3=2 and place it in every applicable set.

**Transfer question:** Classify −4 and 3/2.

**Worked answer:** −4 is an integer and rational, since −4=−4/1. 3/2 is rational but not an integer, whole or counting number.

**Generation constraints:** Use the textbook convention N={1,2,…}, W={0,1,2,…}. No irrational examples are claimed to belong to Q; q never zero.

**Seed example:** {"integer": -1, "fraction_numerator": 1, "fraction_denominator": 2} → integer is rational; odd/2 rational noninteger. Eight parameter sets × two modes = 16 slots.

#### g8q02 — Signed rational position and absolute value

**Reference:** Grade 8, chapter 1, printed pp. 7–19. **Prerequisites:** f07, g7i01.

**Learner goal:** Locate signed fractions and distinguish ordering from distance to zero.

**Mathematical actions:**

1. Subdivide one unit interval into equal denominator-parts.
2. Locate positive and negative rational positions with those ticks.
3. Reflect through zero and measure distance.
4. Compare two positions using common subdivisions or a number line.

**Visible consequence:** −3/4 lies left of −1/2 yet has greater distance from zero.

**Definition/debrief:** Absolute value |x| is distance from zero and is nonnegative. Rational order follows number-line position; equivalent fractions permit comparison in equal-sized parts.

**Misconception:** “A larger denominator always makes a fraction smaller.” **Response:** Compare 3/4 and 2/3 in twelfths, and keep numerators visible.

**Transfer question:** Which is greater, −3/4 or −1/2? Find both absolute values.

**Worked answer:** −1/2=−2/4 lies to the right of −3/4, so −1/2 is greater. Absolute values are 3/4 and 1/2.

**Generation constraints:** Equal interval partitions; denominators positive after normalisation. Negative ordering comparisons must use signed positions.

**Seed example:** {"left_numerator": -2, "right_numerator": -1, "denominator": 3} → right greater; left distance=2/3. Eight parameter sets × two modes = 16 slots.

#### g8q03 — Rational addition and subtraction with common units

**Reference:** Grade 8, chapter 1, printed pp. 20–26. **Prerequisites:** f07, g7i02, g7i03.

**Learner goal:** Combine or remove fractional lengths only after making their parts equal.

**Mathematical actions:**

1. Place both quantities against the same whole.
2. Subdivide to a common denominator.
3. Merge signed shaded parts or remove the requested part.
4. Count remaining common parts, simplify and verify on a number line.

**Visible consequence:** Thirds and quarters become twelfths; denominator records part size and does not add.

**Definition/debrief:** To add/subtract fractions, express them with a common denominator and add/subtract numerators. Signs retain their integer meaning.

**Misconception:** “1/3+1/4=2/7.” **Response:** Overlay thirds and quarters; seven unequal pieces cannot name a common unit.

**Transfer question:** Find −2/3+3/4.

**Worked answer:** Use twelfths: −8/12+9/12=1/12. It is a small positive result.

**Generation constraints:** Same reference whole, nonzero denominators. Use exact rational answers; reductions preserve signs.

**Seed example:** {"a": 1, "b": 3, "c": 1, "d": 4} → 7/12. Eight parameter sets × two modes = 16 slots.

#### g8q04 — Fraction multiplication as part of a part

**Reference:** Grade 8, chapter 1, printed pp. 27–32. **Prerequisites:** f06, f07, f04.

**Learner goal:** Take a fraction of an already selected fraction of one plot.

**Mathematical actions:**

1. Partition a rectangle into b vertical equal parts and select a.
2. Partition it into d horizontal equal parts and select c of those.
3. Identify the overlap as the requested part of a part.
4. Count ac selected cells among bd equal cells and simplify.

**Visible consequence:** The overlap is smaller than either selected strip when both factors lie between zero and one.

**Definition/debrief:** For fractions, (a/b)(c/d)=ac/bd. The overlap model supports positive parts of a whole; signed factors require signed scaling rather than negative physical area.

**Misconception:** “Multiplication always increases a number.” **Response:** Select one half of three quarters and compare 3/8 with 3/4.

**Transfer question:** Find (2/3)×(3/4) and explain the rectangle.

**Worked answer:** The 3×4 grid has 12 cells; the 2×3 overlap has 6. Product=6/12=1/2.

**Generation constraints:** For the overlap model, 0<a≤b and 0<c≤d. Keep cells equal and the whole fixed; do not draw negative areas.

**Seed example:** {"a": 1, "b": 2, "c": 2, "d": 3} → 1/3. Eight parameter sets × two modes = 16 slots.

#### g8q05 — Fraction division as number of portions

**Reference:** Grade 8, chapter 1, printed pp. 33–35. **Prerequisites:** f05, f07.

**Learner goal:** Find how many equal-size portions fit into the available amount, including a partial portion.

**Mathematical actions:**

1. Show the available length a/b on a fixed unit strip.
2. Show one portion c/d and make equal-size subdivisions for both.
3. Fit full portion-lengths and measure any remainder as a fraction of one portion.
4. Record quotient × portion = available amount.

**Visible consequence:** Two thirds contains 2 and 2/3 quarter-portions; a remainder is measured relative to a portion, not the original whole.

**Definition/debrief:** a÷b asks how many b-sized portions fit into a, for b≠0. In common units, (a/b)÷(c/d)=(ad)/(bc). The reciprocal rule follows from comparing common unit counts.

**Misconception:** “Divide numerator by numerator and denominator by denominator and discard a remainder.” **Response:** Partition into common twelfths: eight units divided into groups of three units gives 8/3 portions, not two.

**Transfer question:** How many 1/4 L portions fit in 2/3 L?

**Worked answer:** 2/3=8/12 and 1/4=3/12. 8÷3=8/3=2⅔ portions. Check (8/3)×(1/4)=2/3 L.

**Generation constraints:** Available amount nonnegative, portion size positive. Fractional portion counts are allowed; state whole-container restrictions if the goal asks only full bottles.

**Seed example:** {"available_numerator": 2, "available_denominator": 3, "portion_numerator": 1, "portion_denominator": 4} → 8/3. Eight parameter sets × two modes = 16 slots.

#### g8q06 — Fraction division as inverse scaling

**Reference:** Grade 8, chapter 1, printed pp. 33–35. **Prerequisites:** g8q04, g7e04.

**Learner goal:** Recover the whole quantity when a known fraction of it is given.

**Mathematical actions:**

1. Represent c/d of an unknown whole as the known amount.
2. Divide the known amount into c equal pieces to find one d-th.
3. Copy that piece d times to reconstruct the whole.
4. Write known ÷ (c/d) and multiply back to check.

**Visible consequence:** Dividing by a proper fraction can produce a larger result because the given amount was only part of the whole.

**Definition/debrief:** If (c/d)x=a, then x=a÷(c/d)=a(d/c), with c,d nonzero. This inverse-scaling meaning differs from counting portions.

**Misconception:** “Invert the dividend instead of the divisor.” **Response:** Keep the known amount fixed and recover one denominator-part before rebuilding the whole.

**Transfer question:** Three quarters of a sack is 18 kg. What is the whole mass?

**Worked answer:** One quarter is 18÷3=6 kg; four quarters are 24 kg. Equivalently 18÷(3/4)=18×4/3=24.

**Generation constraints:** Known part positive and divisor fraction positive. Label the quotient as whole amount; do not call it number of portions in this model.

**Seed example:** {"known": 6, "fraction_numerator": 3, "fraction_denominator": 4} → 8. Eight parameter sets × two modes = 16 slots.

#### g8q07 — Rational allocation and conservation checks

**Reference:** Grade 8, chapter 1, printed pp. 37–43. **Prerequisites:** g8q03, g8q04, g7r03.

**Learner goal:** Allocate specified shares of a common budget and find the remainder.

**Mathematical actions:**

1. Mark the total as one whole.
2. Allocate the first fraction of the original total.
3. Allocate the second fraction of the explicitly stated original total.
4. Find the remaining fraction and check all amounts add to the budget.

**Visible consequence:** Every original-whole share and the remainder exactly fill the budget; changing the second base changes the problem.

**Definition/debrief:** Fractions of a budget must name their reference whole. If a and b are shares of the same whole, remainder is 1−a−b.

**Misconception:** “The second fraction always applies to the remainder.” **Response:** Highlight the stated base and calculate original-whole and remaining-whole versions side by side.

**Transfer question:** Of 600 birr, 1/3 and 1/4 of the original total are allocated. What remains?

**Worked answer:** Allocated amounts: 200 and 150 birr. Remainder=600−350=250 birr, or 5/12 of the whole. Check 200+150+250=600.

**Generation constraints:** Shares nonnegative with sum ≤1. The original or remaining base must be stated on every allocation.

**Seed example:** {"total": 120, "share1": "1/3", "share2": "1/4"} → 50. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 2: Squares, roots, cubes and cube roots

#### g8p01 — Squares as equal-length arrays

**Reference:** Grade 8, chapter 2, printed pp. 48–52. **Prerequisites:** f04, g7a02, g7i04.

**Learner goal:** Build a square nursery and connect side length to total plants.

**Mathematical actions:**

1. Choose the same count for rows and columns.
2. Fill the square array.
3. Compare n² with 2n and label side versus area.
4. Use signed multiplication separately to compare (−n)² and −n².

**Visible consequence:** Side length n produces n² cells; doubling a number is a different operation. Parentheses determine whether the sign is squared.

**Definition/debrief:** The square of x is x×x. Geometric square area uses nonnegative side length; for signed numbers (−x)²=x² while −x²=−(x²).

**Misconception:** “x² means x×2.” **Response:** Compare a 5×5 array with two rows of five.

**Transfer question:** Find (−6)² and −6².

**Worked answer:** (−6)²=(−6)(−6)=36. −6² means −(6×6)=−36.

**Generation constraints:** Nonnegative geometric lengths; signed expressions show parentheses clearly. No negative side-length square drawings.

**Seed example:** {"side": 2, "signed_input": -2} → 4. Eight parameter sets × two modes = 16 slots.

#### g8p02 — Principal square root versus two equation solutions

**Reference:** Grade 8, chapter 2, printed pp. 53–55. **Prerequisites:** g8p01, g7e03.

**Learner goal:** Recover a square’s side length from its area and distinguish root notation from equation solving.

**Mathematical actions:**

1. Fill a square with a perfect-square number of tiles.
2. Adjust equal row/column counts to fit every tile.
3. Record the nonnegative side as √A.
4. Compare with both signed numbers that solve x²=A.

**Visible consequence:** One nonnegative side length defines √A; a positive A gives two signed solutions to x²=A.

**Definition/debrief:** √A is the nonnegative number whose square is A, for A≥0 in real numbers. For A>0, x²=A has solutions x=±√A. √(x²)=|x|.

**Misconception:** “√25 is ±5.” **Response:** Separate the square-side question from the equation x²=25; notation √25 denotes only 5.

**Transfer question:** Find √49, solve x²=49, and find √((−7)²).

**Worked answer:** √49=7; x²=49 gives x=7 or −7. √((−7)²)=√49=7=|−7|.

**Generation constraints:** A nonnegative; perfect-square cases here. Negative radicands have no real square root in this curriculum model.

**Seed example:** {"area": 4} → 2. Eight parameter sets × two modes = 16 slots.

#### g8p03 — Square roots through paired prime factors

**Reference:** Grade 8, chapter 2, printed pp. 55–56. **Prerequisites:** g8p02, f04.

**Learner goal:** Find a perfect square’s root by organising its factors into two identical groups.

**Mathematical actions:**

1. Factor the integer completely into primes.
2. Pair identical prime factors.
3. Put one factor from each pair into each identical side group.
4. Multiply one group and square it to verify the result.

**Visible consequence:** Every prime factor occurs an even number of times in a perfect square; each side uses half those factors.

**Definition/debrief:** If A=p₁^(2a₁)…pₖ^(2aₖ), then √A=p₁^a₁…pₖ^aₖ. Unpaired factors mean the integer is not a perfect square.

**Misconception:** “Divide a perfect-square number by two to find its root.” **Response:** Factor 36=2×2×3×3; each side group is 2×3=6, while 18²≠36.

**Transfer question:** Use prime factors to find √144.

**Worked answer:** 144=2⁴×3². Take one factor from each pair: 2²×3=12. Check 12²=144.

**Generation constraints:** Use positive perfect-square integers and a complete prime factorisation. Do not silently discard an unpaired factor in extension cases.

**Seed example:** {"number": 16, "side": 4} → 4. Eight parameter sets × two modes = 16 slots.

#### g8p04 — Estimating and checking square-root/table values

**Reference:** Grade 8, chapter 2, printed pp. 56–58,222–224. **Prerequisites:** g8p02, f08.

**Learner goal:** Estimate a root within a justified interval and check a table lookup’s scale.

**Mathematical actions:**

1. Bracket a radicand between consecutive perfect squares.
2. Choose a candidate decimal side and square it.
3. Refine the lower/upper interval.
4. Read a supplied row/column table excerpt and verify its magnitude by squaring.

**Visible consequence:** A candidate below the target area raises the lower bound; a candidate above it lowers the upper bound. Misplaced decimal points fail the magnitude check.

**Definition/debrief:** For nonnegative numbers, a²<N<b² implies a<√N<b. A table/calculator approximation should be checked for row, column, decimal scale and rounding.

**Misconception:** “√50=25 because half of 50 is 25.” **Response:** Check 25² and bracket 50 between 7²=49 and 8²=64.

**Transfer question:** Bracket √30 to one decimal place.

**Worked answer:** 5.4²=29.16<30 and 5.5²=30.25>30, so 5.4<√30<5.5. Rounded to one decimal it is 5.5; that rounding needs checking against 5.45²=29.7025<30.

**Generation constraints:** Use newly authored exact reference-table entries, not unverified extracted columns. Distinguish an interval from a rounded approximation; do not infer rounding solely from a broad interval.

**Seed example:** {"N": 10, "lower": 3, "upper": 4} → 3<sqrt(N)<4. Eight parameter sets × two modes = 16 slots.

#### g8p05 — Cubes and cube roots

**Reference:** Grade 8, chapter 2, printed pp. 59–68. **Prerequisites:** g8p01, f09.

**Learner goal:** Build equal-sided cubes, then infer a cube’s side from its unit-cube count.

**Mathematical actions:**

1. Build an n×n base layer.
2. Stack n equal layers and count n³ cubes.
3. Given a perfect cube, find an equal count in all three directions.
4. Compare signed cube and square results using multiplication.

**Visible consequence:** Side scaling affects three directions; a signed negative cube remains negative, while geometric side lengths stay positive.

**Definition/debrief:** x³=x×x×x. Cube root ∛A is the number x with x³=A; unlike real square roots, negative numbers have real cube roots.

**Misconception:** “A cube of side 4 contains 12 unit cubes.” **Response:** Count 16 cubes per layer and four layers, giving 64.

**Transfer question:** Find ∛64 and ∛(−27).

**Worked answer:** 4³=64, so ∛64=4. (−3)³=−27, so ∛(−27)=−3.

**Generation constraints:** Physical lengths nonnegative; signed cubes use arithmetic, not negative physical volumes. Perfect-cube reversal must match all three dimensions.

**Seed example:** {"side": 2, "volume": 8} → 2. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 3: Linear equations and inequalities

#### g8l01 — Linear relationship: table to graph to equation

**Reference:** Grade 8, chapter 3, printed pp. 78–84. **Prerequisites:** g7e05, g7e01.

**Learner goal:** Plot a constant-rate relationship and recover its rule.

**Mathematical actions:**

1. Choose at least three x-values.
2. Calculate y=mx+b for each and complete a table.
3. Plot ordered pairs on labelled axes.
4. Draw the straight line and test an additional point against the rule.

**Visible consequence:** Equal x-increments produce equal y-increments; a wrongly calculated point breaks the line.

**Definition/debrief:** A linear equation y=mx+b represents a straight-line relationship. m is change in y per unit change in x; b is y when x=0.

**Misconception:** “Connect every plotted point even when one violates the equation.” **Response:** Substitute the off-line point into the rule and repair its calculation before drawing.

**Transfer question:** For y=2x+1, give points at x=−1,0,2.

**Worked answer:** The corresponding y-values are −1,1,5. Points: (−1,−1),(0,1),(2,5). Each satisfies y=2x+1.

**Generation constraints:** Use fixed labelled scales; include x=0 and a negative x. Three points support checking, but justify straightness from the constant-rate rule.

**Seed example:** {"m": 1, "b": 2, "x_values": [-1, 0, 2]} → y_values=[1, 2, 4]. Eight parameter sets × two modes = 16 slots.

#### g8l02 — Strict and inclusive inequalities

**Reference:** Grade 8, chapter 3, printed pp. 85–89. **Prerequisites:** g7i01, g7e03.

**Learner goal:** Show every allowed value, including whether the boundary itself is permitted.

**Mathematical actions:**

1. Solve the equality to locate the boundary.
2. Test a value on each side in the original inequality.
3. Choose the valid direction and draw a number-line ray.
4. Use an open or closed boundary marker and test the boundary itself.

**Visible consequence:** A strict inequality excludes its boundary; an inclusive inequality includes it. The ray covers many solutions, not one point.

**Definition/debrief:** x<a excludes a; x≤a includes a. Adding/subtracting the same value and multiplying/dividing by a positive number preserve order.

**Misconception:** “An inequality has only the equality-boundary solution.” **Response:** Test nearby values and show all passing positions on the ray.

**Transfer question:** Solve 3x+2≤11 and show the boundary.

**Worked answer:** 3x≤9, so x≤3. A closed marker at 3 and a ray left show all real/rational solutions. x=3 gives 11≤11, true.

**Generation constraints:** Solution domain is stated; book tasks commonly use Q. Do not show only integer ticks as though intermediate rational solutions were excluded.

**Seed example:** {"coefficient": 3, "constant": 2, "limit": 5, "relation": "<="} → x≤1. Eight parameter sets × two modes = 16 slots.

#### g8l03 — Why negative multiplication reverses inequality

**Reference:** Grade 8, chapter 3, printed pp. 86–89. **Prerequisites:** g7i04, g7i01, g8l02.

**Learner goal:** Transform an order statement through zero without losing which side is greater.

**Mathematical actions:**

1. Place two ordered values, such as 2<5, on a number line.
2. Multiply both positions by −1 and observe reflection across zero.
3. Compare −2 and −5 from left to right and reverse the comparison sign.
4. Solve a negative-coefficient inequality, then test a valid and invalid value in the original.

**Visible consequence:** Negative scaling reverses the left/right order; −2 is to the right of −5, so −2>−5.

**Definition/debrief:** Multiplying/dividing both sides of an inequality by a negative number reverses its direction. Reflection establishes order reversal; positive magnitude scaling preserves the reflected order.

**Misconception:** “Changing sides reverses the inequality sign.” **Response:** Separate subtraction, which translates both positions, from multiplication by a negative, which reflects them.

**Transfer question:** Solve −2x+4<10.

**Worked answer:** Subtract 4: −2x<6. Divide by −2 and reverse: x>−3. Check x=0 gives 4<10; x=−4 gives 12<10, false. x=−3 is excluded.

**Generation constraints:** Negative nonzero coefficient; compare original-statement truth on both sides of boundary. Do not reverse for addition/subtraction or division by a positive number.

**Seed example:** {"coefficient": -2, "constant": 4, "limit": 6} → x>-1. Eight parameter sets × two modes = 16 slots.

#### g8l04 — Contextual inequalities and integer feasibility

**Reference:** Grade 8, chapter 3, printed pp. 90–94. **Prerequisites:** g8l02, g7r02.

**Learner goal:** Choose the greatest feasible whole number of items within a stated budget.

**Mathematical actions:**

1. Translate fixed fee plus unit cost into an expression.
2. Write the budget as an inclusive upper bound.
3. Solve over numbers and then restrict to nonnegative whole counts.
4. Test the maximum accepted count and the next count against the budget.

**Visible consequence:** A fractional mathematical boundary may permit only the whole count below it; the next purchase visibly exceeds the budget.

**Definition/debrief:** A contextual inequality models a limit. The solution must also respect its domain: whole item counts, nonnegative quantities and stated units.

**Misconception:** “Round an upper bound to the nearest whole number.” **Response:** Buy the rounded-up count and compare actual cost with the allowed budget.

**Transfer question:** Fee 10 birr plus 7 birr per item, budget 50 birr. Maximum items?

**Worked answer:** 10+7n≤50 gives n≤40/7≈5.714. Whole nonnegative n gives maximum 5. Cost 45≤50; six items cost 52>50.

**Generation constraints:** Unit cost positive; whole count domain explicit. Use upper bounds with a fractional endpoint to expose inappropriate rounding.

**Seed example:** {"fee": 10, "unit_cost": 7, "budget": 27} → 2. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 4: Similarity

#### g8m01 — Similarity versus congruence and correspondence

**Reference:** Grade 8, chapter 4, printed pp. 96–102. **Prerequisites:** g7c01, g7r01.

**Learner goal:** Resize a template while keeping its shape and distinguish an exact replacement.

**Mathematical actions:**

1. Pair corresponding vertices in both figures.
2. Compare all corresponding angles.
3. Compute corresponding side ratios in the same direction.
4. Use a uniform scale to overlay shapes and decide similarity or congruence.

**Visible consequence:** Uniform scale makes similar figures overlay; rigid movement alone works only when scale factor is one.

**Definition/debrief:** Similar figures have equal corresponding angles and proportional corresponding sides. Congruence also requires matching size; similar scale factor 1 yields congruence.

**Misconception:** “Equal angles alone prove any quadrilaterals similar.” **Response:** Compare rectangles 2×3 and 2×5: angles match but side ratios do not.

**Transfer question:** Are rectangles 3×5 and 6×10 similar? Are they congruent?

**Worked answer:** Yes, corresponding side ratios are both 2 and all angles are right angles. They are not congruent because lengths differ; scale factor is 2.

**Generation constraints:** Use consistent ratio direction and vertex correspondence. For general polygons check both angle equality and side proportionality.

**Seed example:** {"small": [3, 5], "large": [6, 10]} → similar with k=2; not congruent. Eight parameter sets × two modes = 16 slots.

#### g8m02 — AA triangle similarity

**Reference:** Grade 8, chapter 4, printed pp. 103–105. **Prerequisites:** g8m01, g7c04.

**Learner goal:** Build different-sized triangles with the same two angles and predict matching shape.

**Mathematical actions:**

1. Set two base angles on a chosen base.
2. Construct the ray intersection.
3. Change the base length while keeping both angles.
4. Match all angles and corresponding side ratios.

**Visible consequence:** The third angle remains the same while size changes; matching angles determine triangle shape but do not fix size.

**Definition/debrief:** AA establishes triangle similarity: two equal corresponding angles force the third to match because angles sum to 180°.

**Misconception:** “AA proves triangle congruence.” **Response:** Double the base while preserving the angles; compare the longer sides with the original.

**Transfer question:** Two triangles have angles 35° and 65°. Are they similar?

**Worked answer:** Yes by AA. Both third angles are 180−35−65=80°. Congruence cannot be concluded without matching size.

**Generation constraints:** Two angles positive and sum below 180°. This AA criterion is for triangles, not arbitrary polygons.

**Seed example:** {"angle1": 30, "angle2": 60, "base_ratio": 2} → AA similar; third=90°. Eight parameter sets × two modes = 16 slots.

#### g8m03 — SSS/SAS similarity and scale-factor consistency

**Reference:** Grade 8, chapter 4, printed pp. 105–109. **Prerequisites:** g8m01, g7c03, g7r02.

**Learner goal:** Find a missing side while testing every required similarity condition.

**Mathematical actions:**

1. Pair sides using the vertex map.
2. Calculate all known scale factors in one direction.
3. For SSS check three ratios; for SAS check two ratios and their included equal angle.
4. Use the common factor to build a missing side and check the full figure.

**Visible consequence:** A single inconsistent ratio blocks the similarity claim; equal side differences do not suffice.

**Definition/debrief:** SSS similarity requires three proportional side pairs. SAS similarity requires two proportional side pairs and equal included angles.

**Misconception:** “Adding the same amount to all sides makes similar triangles.” **Response:** Compare 3,4,5 with 5,6,7: side differences are two, but ratios differ.

**Transfer question:** Triangle sides 4,6,8 correspond to 6,9,x. Find x if similar.

**Worked answer:** Scale factor=6/4=9/6=3/2. Therefore x=8×3/2=12. The third ratio also equals 3/2.

**Generation constraints:** Valid triangle inequalities and a fixed vertex map. SAS angle explicitly included; reject mismatched ratio direction.

**Seed example:** {"small": [3, 4, 5], "known_large": [6, 8], "missing_index": 2} → 10. Eight parameter sets × two modes = 16 slots.

#### g8m04 — Length/perimeter scale k versus area scale k²

**Reference:** Grade 8, chapter 4, printed pp. 110–114. **Prerequisites:** g8m01, g7a04, g8p01.

**Learner goal:** Estimate the boundary and covering needed for an enlarged design.

**Mathematical actions:**

1. Scale every length by k.
2. Trace the new boundary and compare perimeter ratios.
3. Subdivide each original unit square into the k×k enlarged tile block.
4. Compare area ratios and recover k from a known area ratio.

**Visible consequence:** A doubled boundary uses twice the length while each tile expands into four unit tiles.

**Definition/debrief:** For similar figures, lengths and perimeters scale by k; areas scale by k². Ratios must be taken in the same direction.

**Misconception:** “Doubling lengths doubles area.” **Response:** Build a 2×2 enlarged copy of one unit tile and count its four cells.

**Transfer question:** A similar triangle has scale factor 3; original perimeter 12 cm and area 8 cm². Find new values.

**Worked answer:** Perimeter=3×12=36 cm. Area=3²×8=72 cm².

**Generation constraints:** Integer k=2–9 for tiled construction; extension can use rational scales. Never compare area units as if they were lengths.

**Seed example:** {"k": 2, "original_perimeter": 12, "original_area": 6} → P=24; A=24. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 5: Triangle theorems

#### g8t01 — Triangle interior-angle sum

**Reference:** Grade 8, chapter 5, printed pp. 118–122. **Prerequisites:** g7a01.

**Learner goal:** Predict a triangle’s missing interior angle by rearranging its corners.

**Mathematical actions:**

1. Construct a nondegenerate triangle and mark all three corners.
2. Cut copies of the corner regions.
3. Place the three corners adjacent along a straight line.
4. Measure the straight angle and calculate an unknown corner.

**Visible consequence:** The corners align into 180°; a misidentified exterior corner prevents the straight-line fit.

**Definition/debrief:** Interior angles of a Euclidean triangle sum to 180°. The action illustrates the relation; parallel-line angle reasoning provides an exact justification beyond approximate measurement.

**Misconception:** “Every triangle has a 90° angle.” **Response:** Build a triangle with angles 50°,60°,70° and compare with the right-triangle case.

**Transfer question:** Two triangle angles are 48° and 67°. Find the third.

**Worked answer:** Third=180−48−67=65°.

**Generation constraints:** All angles positive and total 180°; degenerate triangles excluded. Virtual measurement error cannot redefine the theorem.

**Seed example:** {"angle1": 40, "angle2": 60} → 80. Eight parameter sets × two modes = 16 slots.

#### g8t02 — Exterior angle as remote-angle sum

**Reference:** Grade 8, chapter 5, printed pp. 123–126. **Prerequisites:** g8t01.

**Learner goal:** Find the outside turning angle without confusing it with the adjacent inside angle.

**Mathematical actions:**

1. Extend one side past a vertex.
2. Mark the interior angle and its adjacent exterior angle.
3. Use their straight-angle sum to determine the exterior angle.
4. Compare with the two remote interior angles and explain equality.

**Visible consequence:** The exterior angle and adjacent interior angle sum to 180°; the two other interiors exactly make the exterior.

**Definition/debrief:** A triangle’s exterior angle equals the sum of its two remote interior angles, when formed by extending one side.

**Misconception:** “Add all three interior angles to get the exterior.” **Response:** Mark the adjacent angle as the supplement and select only the two remote corners.

**Transfer question:** Remote interior angles are 38° and 74°. Find exterior and adjacent interior.

**Worked answer:** Exterior=38+74=112°. Adjacent interior=180−112=68°.

**Generation constraints:** Remote angles positive with sum below 180°. Clearly mark which side is extended and which angles are remote.

**Seed example:** {"remote1": 30, "remote2": 70} → exterior=100°; adjacent=80°. Eight parameter sets × two modes = 16 slots.

#### g8t03 — Euclidean projection theorem and its converse

**Reference:** Grade 8, chapter 5, printed pp. 127–133. **Prerequisites:** g8m02, g8p02.

**Learner goal:** Relate each right-triangle leg to its projection on the hypotenuse.

**Mathematical actions:**

1. Drop the right-angle altitude to the hypotenuse and label projections p,q.
2. Match each small triangle with the whole triangle using AA.
3. Write each matching leg/hypotenuse proportion and derive leg²=c×adjacent projection.
4. Check both projection identities when using the converse.

**Visible consequence:** The leg’s square equals a rectangle of hypotenuse c and its adjacent projection, not the other projection.

**Definition/debrief:** For right triangle ABC with right angle C and altitude CD to AB: AC²=AB×AD and BC²=AB×DB. With the stated perpendicular construction, the corresponding conditions support the converse; keep the book’s two checks explicit.

**Misconception:** “Pair a leg with either hypotenuse segment.” **Response:** Trace the similar triangle vertex map and highlight the segment adjacent to that leg.

**Transfer question:** AB=25, AD=9, DB=16. Find AC and BC for the right triangle.

**Worked answer:** AC²=25×9=225, so AC=15. BC²=25×16=400, so BC=20. Check 15²+20²=25².

**Generation constraints:** Altitude foot lies between hypotenuse endpoints, c=p+q. Use a labelled vertex map and verify both identities in converse tasks; no arbitrary drawings accepted.

**Seed example:** {"AB": 25, "AD": 9, "DB": 16} → AC=15; BC=20. Eight parameter sets × two modes = 16 slots.

#### g8t04 — Pythagoras from area rearrangement

**Reference:** Grade 8, chapter 5, printed pp. 134–138. **Prerequisites:** g8p02, g7a04.

**Learner goal:** Determine a missing right-triangle length by conserving area.

**Mathematical actions:**

1. Build four congruent right triangles with legs a,b in a square of side a+b.
2. Arrange them to leave a central square of side c.
3. Rearrange the same triangles to leave squares of sides a and b.
4. Equate uncovered areas, then solve and verify the missing length.

**Visible consequence:** The unchanged outer area and unchanged triangle area force c²=a²+b².

**Definition/debrief:** In a right triangle, hypotenuse c opposite the right angle satisfies c²=a²+b². This area relationship applies only with a right angle.

**Misconception:** “Add the legs directly to get the hypotenuse.” **Response:** Compare total leg path a+b with the diagonal; use their squared areas to find c.

**Transfer question:** A ladder reaches 12 m high with its foot 5 m from the wall. Find its length.

**Worked answer:** The wall-ground angle is right. Ladder c=√(12²+5²)=√169=13 m.

**Generation constraints:** Right angle explicitly stated; hypotenuse is opposite it. Rearrangements use identical triangles and no gaps/overlap except the intended uncovered squares.

**Seed example:** {"a": 3, "b": 4} → 5. Eight parameter sets × two modes = 16 slots.

#### g8t05 — Pythagorean converse

**Reference:** Grade 8, chapter 5, printed pp. 139–144. **Prerequisites:** g8t04, g7c02.

**Learner goal:** Check whether three measured lengths can form a right triangle.

**Mathematical actions:**

1. Check strict triangle inequalities.
2. Identify the longest side as the candidate hypotenuse.
3. Compare its square with the sum of the other two squares.
4. Conclude right triangle only when equality holds, then mark its opposite angle.

**Visible consequence:** Lengths can form a valid triangle while failing the right-angle test; longest side identification prevents a wrong comparison.

**Definition/debrief:** Converse: if positive triangle sides satisfy c²=a²+b² with c longest, the opposite angle is 90°.

**Misconception:** “Any triangle with three given lengths is right.” **Response:** Use 4,5,6 and compare 16+25=41 with 36.

**Transfer question:** Do 6,8,10 form a right triangle?

**Worked answer:** They form a triangle since 6+8>10. The largest side is 10; 6²+8²=36+64=100=10², so the opposite angle is right.

**Generation constraints:** All sides positive and form a nondegenerate triangle. Repair tasks include near-miss longest sides; no equality inferred from approximate drawing.

**Seed example:** {"sides": [5, 12, 13]} → right triangle; largest side is hypotenuse. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 6: Lines and angles in circles

#### g8o01 — Radius, diameter, chord, arc and sector

**Reference:** Grade 8, chapter 6, printed pp. 146–151. **Prerequisites:** g7a05.

**Learner goal:** Construct and label the circle parts used in later theorems.

**Mathematical actions:**

1. Set a centre O and a fixed radius.
2. Join centre to rim for a radius, then two rim points for a chord.
3. Move a chord through O to make a diameter.
4. Select the curved arc and bounded sector, distinguishing them from line segments.

**Visible consequence:** Every diameter is a chord through the centre; an arbitrary chord is usually shorter and not twice the radius.

**Definition/debrief:** A radius joins centre to circle. A chord joins two circle points; a diameter is a centre-crossing chord with length 2r. An arc is part of the circumference; a sector is a region bounded by two radii and an arc.

**Misconception:** “Every line segment inside a circle is a radius.” **Response:** Test endpoint constraints: radius has one endpoint at centre, chord has both endpoints on the circle.

**Transfer question:** Radius is 4.5 cm. Find diameter; must every chord equal it?

**Worked answer:** Diameter=2×4.5=9 cm. Other chords need not equal 9 cm; only centre-crossing chords are diameters.

**Generation constraints:** True circle with fixed centre; endpoint locations explicit. Do not confuse arc length, arc angle and sector area.

**Seed example:** {"radius": "3/2"} → 3. Eight parameter sets × two modes = 16 slots.

#### g8o02 — Perpendicular from centre bisects chord

**Reference:** Grade 8, chapter 6, printed pp. 152–154. **Prerequisites:** g8t04, g7c03.

**Learner goal:** Find a chord length using the centre-to-chord perpendicular.

**Mathematical actions:**

1. Draw a radius to each chord endpoint.
2. Drop a perpendicular from centre to the chord.
3. Compare the two right triangles to show equal half-chords.
4. Use Pythagoras on one half and double it.

**Visible consequence:** The perpendicular foot is the midpoint; each half-chord and distance to centre form a right triangle with radius as hypotenuse.

**Definition/debrief:** A perpendicular from a circle’s centre to a chord bisects the chord. If radius r and perpendicular distance d are known, half-chord=√(r²−d²).

**Misconception:** “Subtract the distance from the radius to get half the chord.” **Response:** Use the right-triangle square relation, not a linear subtraction of perpendicular lengths.

**Transfer question:** Radius 13 cm, centre-to-chord distance 5 cm. Find chord length.

**Worked answer:** Half-chord=√(13²−5²)=√144=12 cm. Full chord=24 cm.

**Generation constraints:** 0≤d<r and perpendicular marked; choose exact right-triangle cases. Use full chord only after doubling the half-chord.

**Seed example:** {"radius": 5, "distance": 3} → 8. Eight parameter sets × two modes = 16 slots.

#### g8o03 — Central and inscribed angles on the same arc

**Reference:** Grade 8, chapter 6, printed pp. 155–158. **Prerequisites:** g8t01, f06.

**Learner goal:** Find a viewing angle at the rim from its intercepted central angle.

**Mathematical actions:**

1. Choose arc endpoints A,B and display its intercepted arc.
2. Draw central angle AOB corresponding to that same arc.
3. Place C on the other arc and draw inscribed angle ACB.
4. Measure/derive the relationship and calculate either missing angle.

**Visible consequence:** The inscribed angle is half the central angle intercepting the same arc; changing which arc is intercepted changes the comparison.

**Definition/debrief:** An inscribed angle equals half the measure of its intercepted arc. A central angle equals the measure of its corresponding arc, so the inscribed angle is half that central angle.

**Misconception:** “Any rim angle is half any central angle in the circle.” **Response:** Highlight both intercepted arcs; apply the relation only when the arcs match and C is not on the intercepted arc.

**Transfer question:** The intercepted arc is 130°. Find its central and inscribed angles.

**Worked answer:** The corresponding central angle is 130°. The inscribed angle is 130/2=65°.

**Generation constraints:** Store arc endpoints, chosen arc and inscribed vertex explicitly. Arc measure lies in (0°,360°); do not automatically choose the minor central angle for a major arc.

**Seed example:** {"arc_degrees": 60} → central=60°; inscribed=30°. Eight parameter sets × two modes = 16 slots.

#### g8o04 — Angles on the same arc and in a semicircle

**Reference:** Grade 8, chapter 6, printed pp. 159. **Prerequisites:** g8o03.

**Learner goal:** Move a rim viewpoint while keeping the intercepted arc fixed.

**Mathematical actions:**

1. Fix chord endpoints and the selected intercepted arc.
2. Move the viewing vertex only along the opposite arc.
3. Measure the inscribed angle at multiple allowed positions.
4. Set the chord as a diameter and predict the right angle.

**Visible consequence:** All allowed viewpoints give the same angle; a diameter intercepts a 180° arc and gives 90°.

**Definition/debrief:** Inscribed angles intercepting the same arc are equal. An angle subtending a diameter is a right angle. Crossing to the other side generally selects the other arc and changes the relation.

**Misconception:** “Every angle with endpoints on a diameter is 180°.” **Response:** The arc is 180°, while its inscribed angle is half of that.

**Transfer question:** AB is a diameter and C lies on the circle away from A,B. Find ∠ACB.

**Worked answer:** The intercepted semicircle measures 180°, so ∠ACB=180/2=90°.

**Generation constraints:** Viewing vertex never coincides with chord endpoints and stays on the stated opposite arc. Do not claim opposite-side inscribed angles necessarily equal; distinguish intercepted arcs.

**Seed example:** {"arc_degrees": 80, "viewpoint_fraction": "1/10"} → 40. Eight parameter sets × two modes = 16 slots.

#### g8o05 — Angles of chords intersecting inside a circle

**Reference:** Grade 8, chapter 6, printed pp. 160–162. **Prerequisites:** g8o03, g8t02.

**Learner goal:** Calculate an angle formed by crossing chords using the correct pair of opposite arcs.

**Mathematical actions:**

1. Construct two chords crossing at an interior point M.
2. Mark the angle and its vertical opposite.
3. Highlight the two arcs intercepted by those opposite angles.
4. Take half their sum and check the adjacent angle is supplementary.

**Visible consequence:** Both opposite intercepted arcs contribute; taking only one arc undercounts the interior angle.

**Definition/debrief:** For chords intersecting inside a circle, the angle measure equals half the sum of the two intercepted arc measures belonging to it and its vertical opposite.

**Misconception:** “Use half the difference of arcs for an interior intersection.” **Response:** Contrast the interior triangle/exterior-angle derivation with the given inside intersection; both intercepted arcs add.

**Transfer question:** Opposite intercepted arcs measure 80° and 120°. Find angle and adjacent angle.

**Worked answer:** Angle=(80+120)/2=100°. Its adjacent angle=180−100=80°.

**Generation constraints:** Intersection strictly inside circle; correct opposite arcs explicitly highlighted. Arc measures positive with sum below 360°; adjacent angles use the remaining arc pair.

**Seed example:** {"arc1": 60, "arc2": 100} → 80. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 7: Solids and measurement

#### g8v01 — Solid families, faces, edges, vertices and nets

**Reference:** Grade 8, chapter 7, printed pp. 170–180. **Prerequisites:** g7a01.

**Learner goal:** Choose a net that folds into the required solid and identify its parts.

**Mathematical actions:**

1. Inspect polygonal faces or curved surfaces and base shapes.
2. Fold a net while matching edges.
3. Count faces, edges and vertices of a prism or pyramid once each.
4. Compare with cylinder/cone curved surfaces and classify the solid.

**Visible consequence:** Shared net edges merge when folded; overlap or a missing face prevents a closed solid.

**Definition/debrief:** A prism has two congruent parallel polygon bases joined by parallelogram faces; a pyramid has one polygon base and triangular faces meeting at an apex. Cylinders/cones have curved surfaces, so polygon-edge counting conventions must be stated.

**Misconception:** “Count every edge in the flat net as a different solid edge.” **Response:** Track paired seam edges as they become one edge in the solid.

**Transfer question:** How many faces, edges and vertices does a triangular prism have?

**Worked answer:** It has 2 triangular bases and 3 rectangular side faces: 5 faces, 9 edges and 6 vertices.

**Generation constraints:** Use non-overlapping valid nets; prism/pyramid bases have n≥3. Reserve Euler-count verification for convex polyhedra, not informal curved-surface conventions.

**Seed example:** {"base_sides": 3, "solid": "prism"} → F=5; E=9; V=6. Eight parameter sets × two modes = 16 slots.

#### g8v02 — Prism lateral and total surface area

**Reference:** Grade 8, chapter 7, printed pp. 180–182. **Prerequisites:** g7a02, g7a04, g8v01.

**Learner goal:** Buy covering for selected outer faces of a prism.

**Mathematical actions:**

1. Unfold side faces into a strip of width equal to base perimeter.
2. Calculate lateral area as perimeter × prism height.
3. Add the two base areas for a closed solid.
4. Remove an excluded base only when the task specifies an open container.

**Visible consequence:** The side strip uses base perimeter, while each end uses base area; open/closed descriptions change the included faces.

**Definition/debrief:** For a right prism, lateral area=Ph and total closed surface area=Ph+2B, where P is base perimeter and B its area.

**Misconception:** “Surface area is base area times height.” **Response:** Compare a net’s square units with interior cube layers; B×h measures volume.

**Transfer question:** A closed right rectangular prism is 4×3×5 cm. Find surface area.

**Worked answer:** Base P=2(4+3)=14 cm, B=12 cm². Surface=14×5+2×12=94 cm².

**Generation constraints:** Right prisms only for lateral area=Ph. Include only exposed faces; state whether the container is open or closed.

**Seed example:** {"length": 3, "width": 2, "height": 4, "closed": true} → 52. Eight parameter sets × two modes = 16 slots.

#### g8v03 — Cylinder net and surface area

**Reference:** Grade 8, chapter 7, printed pp. 183–185. **Prerequisites:** g7a05, g8v01.

**Learner goal:** Measure a label around a cylinder and compare it with all closed surfaces.

**Mathematical actions:**

1. Remove the two circular bases.
2. Cut the curved side vertically and unwrap it into a rectangle.
3. Match rectangle width to circumference 2πr and height to h.
4. Find lateral area and add two discs only for total closed surface.

**Visible consequence:** The label width is circumference, not diameter; the two base discs add area without adding height.

**Definition/debrief:** Right cylinder lateral area=2πrh. Closed total surface=2πrh+2πr².

**Misconception:** “A cylinder label width is 2r.” **Response:** Roll its circumference along the rectangle edge and show that 2r is only its diameter.

**Transfer question:** Radius 3 cm, height 8 cm. Give label area and closed surface exactly.

**Worked answer:** Label=2π×3×8=48π cm². Two bases=18π cm². Total=66π cm².

**Generation constraints:** Right cylinder with positive r,h; distinguish labels, open top and closed container. Use exact π unless a stated approximation is requested.

**Seed example:** {"radius": 2, "height": 5} → lateral=20π; total=28π. Eight parameter sets × two modes = 16 slots.

#### g8v04 — Pyramid and cone surfaces: slant versus vertical height

**Reference:** Grade 8, chapter 7, printed pp. 186–189,193–194. **Prerequisites:** g7a04, g7a05, g8t04.

**Learner goal:** Measure material for a sloping roof using its actual face height.

**Mathematical actions:**

1. Identify vertical height inside the solid and slant height on a face.
2. For a regular pyramid unfold triangular sides and sum their areas.
3. For a right cone unwrap the curved side into a sector whose arc is 2πr.
4. Compute lateral area using slant height and add a base only if covered.

**Visible consequence:** Face covering depends on slant height; vertical height measures interior rise and must first be converted using a right triangle when needed.

**Definition/debrief:** Regular right pyramid lateral area=Pl/2, with common face slant height l. Right cone lateral area=πrl. For a cone l²=h²+r²; for a square pyramid l²=h²+(s/2)².

**Misconception:** “Use the vertical height in every surface formula.” **Response:** Highlight the triangle altitude lying on the face and derive it from the interior right triangle.

**Transfer question:** A right cone has radius 3 cm and vertical height 4 cm. Find slant height and lateral area.

**Worked answer:** l=√(3²+4²)=5 cm. Lateral area=π×3×5=15π cm²; closed total would add 9π to give 24π cm².

**Generation constraints:** Regular right pyramid or right cone; no arbitrary oblique solids. Specify common slant height and distinguish roof-only from closed total.

**Seed example:** {"solid": "cone", "radius": 3, "vertical_height": 4} → l=5; lateral=15π. Eight parameter sets × two modes = 16 slots.

#### g8v05 — Prism volume as unit-cube layers

**Reference:** Grade 8, chapter 7, printed pp. 190–192. **Prerequisites:** f09, g8v01, f04.

**Learner goal:** Find how much space a box contains by filling it without gaps.

**Mathematical actions:**

1. Fill one base layer with unit cubes.
2. Count the base layer as its area in square units.
3. Stack the stated number of equal layers through perpendicular height.
4. Count all cubes and compare with B×h.

**Visible consequence:** Each new layer adds the same base count; the result uses cubic units and differs from exterior surface area.

**Definition/debrief:** Volume counts unit cubes occupying the interior. For a prism V=B×h, where h is perpendicular separation of parallel bases. Rectangular prism volume=lwh.

**Misconception:** “Add length, width and height to find volume.” **Response:** Build 4×3 cubes in each layer, then stack two layers: 24 cubes, not 9.

**Transfer question:** A rectangular box is 6×4×3 cm. Find volume.

**Worked answer:** Base layer has 6×4=24 unit cubes. Three layers contain 24×3=72 cm³.

**Generation constraints:** Positive dimensions in one unit; aggregate rendering may show layers rather than every cube. Volume uses perpendicular height, not a slanted edge.

**Seed example:** {"length": 3, "width": 4, "height": 3} → 36. Eight parameter sets × two modes = 16 slots.

#### g8v06 — Cylinder capacity and volume-unit conversion

**Reference:** Grade 8, chapter 7, printed pp. 191–195. **Prerequisites:** g8v05, g7a05, f09.

**Learner goal:** Find a cylindrical container’s capacity and express it in litres when dimensions use centimetres.

**Mathematical actions:**

1. Identify radius from a diameter if necessary.
2. Calculate circular base area.
3. Stack equal circular layers through perpendicular height.
4. Convert cm³ to litres using 1000 cm³=1 L and verify the unit.

**Visible consequence:** Doubling radius quadruples each layer’s area; diameter substituted as radius gives four times too much volume.

**Definition/debrief:** Right-cylinder volume=πr²h. One litre is 1000 cm³. Capacity and volume conversion require consistent length units before multiplication.

**Misconception:** “Use the diameter in πr²h.” **Response:** Split the diameter into two radii and compare the two proposed base areas.

**Transfer question:** Diameter 14 cm, height 20 cm. Use π=22/7; find capacity in litres.

**Worked answer:** r=7 cm. V=(22/7)×7²×20=3080 cm³=3.08 L.

**Generation constraints:** Right cylinder, consistent cm units for litre conversion. State π approximation and keep full precision until the final unit conversion.

**Seed example:** {"diameter": 14, "height": 10, "pi": "22/7"} → V=1540 cm³; litres=77/50. Eight parameter sets × two modes = 16 slots.

### Grade 8, chapter 8: Probability

#### g8b01 — Certain, impossible and possible events

**Reference:** Grade 8, chapter 8, printed pp. 200–203. **Prerequisites:** g7s01, f06.

**Learner goal:** Decide whether a proposed result can occur from a known collection.

**Mathematical actions:**

1. Inspect every token type in the bag.
2. Mark outcomes satisfying the event.
3. Try to construct a counterexample to certainty.
4. Classify all, none or some satisfying outcomes and place the probability on 0–1.

**Visible consequence:** A missing token type cannot be drawn; an event covering every possible token is certain even when the exact token is unknown.

**Definition/debrief:** An impossible event has probability 0, a certain event 1, and other possible events lie between when outcomes have positive chance.

**Misconception:** “Possible means probability 1/2.” **Response:** Compare one red token among nine blue tokens with five red among five blue; both are possible with different probabilities.

**Transfer question:** A bag contains only red and blue tokens, at least one of each. Classify drawing green and drawing red or blue.

**Worked answer:** Green is impossible, probability 0. Red or blue is certain, probability 1.

**Generation constraints:** Collection fully known, nonempty, and each token drawable. Classifying possibility alone does not determine a nontrivial numerical probability.

**Seed example:** {"red": 1, "blue": 2, "green": 0} → green impossible; red or blue certain. Eight parameter sets × two modes = 16 slots.

#### g8b02 — Sample spaces and ordered combined outcomes

**Reference:** Grade 8, chapter 8, printed pp. 204–209. **Prerequisites:** g7s01, g7s04.

**Learner goal:** List every possible outcome of an experiment without omission or double counting.

**Mathematical actions:**

1. List first-stage outcomes.
2. Attach every second-stage outcome to each first-stage branch.
3. Label each full path as one ordered outcome.
4. Count complete paths and collect the event subset.

**Visible consequence:** HT and TH are distinct ordered results for two labelled coin tosses, even though both contain one head.

**Definition/debrief:** A sample space contains all possible outcomes. An event is a subset. Ordered stage outcomes distinguish which stage produced each result.

**Misconception:** “Two fair coins have three equally likely outcomes: zero, one or two heads.” **Response:** Build HH,HT,TH,TT; one-head count corresponds to two elementary outcomes.

**Transfer question:** List two labelled fair-coin outcomes and P(exactly one head).

**Worked answer:** S={HH,HT,TH,TT}. Exactly one head gives {HT,TH}, so probability=2/4=1/2.

**Generation constraints:** Stages clearly labelled; independence and equal chances stated for probability calculations. Tree count may vary by stage; all full paths included.

**Seed example:** {"first_outcomes": 2, "second_outcomes": 2} → 4. Eight parameter sets × two modes = 16 slots.

#### g8b03 — Two-dice grid and unequal sum frequencies

**Reference:** Grade 8, chapter 8, printed pp. 208–210,218–221. **Prerequisites:** g8b02, g7d01.

**Learner goal:** Find a sum event by counting fair dice pairs rather than treating sums as equal.

**Mathematical actions:**

1. Place first die outcomes along rows and second die outcomes along columns.
2. Fill all 36 ordered cells.
3. Highlight every cell whose sum meets the event.
4. Count favourable cells and divide by 36.

**Visible consequence:** Different sums occupy different numbers of cells; sum 7 has six outcomes but sum 2 has one.

**Definition/debrief:** For two independent fair six-sided dice, the 36 ordered pairs are equally likely. Their sums are not equally likely, so probability must count the underlying pairs.

**Misconception:** “There are 11 possible sums, so every sum has probability 1/11.” **Response:** Count cells on each diagonal; compare the one cell for sum 2 with six for sum 7.

**Transfer question:** Find P(sum=8) with two fair dice.

**Worked answer:** Favourable pairs: (2,6),(3,5),(4,4),(5,3),(6,2). Probability=5/36.

**Generation constraints:** Independent fair dice, ordered pair space of size 36. Eight distinct sum targets here; later event types may combine sums.

**Seed example:** {"sum_target": 2} → 1/36. Eight parameter sets × two modes = 16 slots.

#### g8b04 — Simple probability requires equally likely outcomes

**Reference:** Grade 8, chapter 8, printed pp. 210–213. **Prerequisites:** g8b01, f07.

**Learner goal:** Compute the chance of a colour using individual tokens as equally likely outcomes.

**Mathematical actions:**

1. Count individual tokens rather than distinct colours.
2. Identify all tokens satisfying the event.
3. Form favourable/total and simplify.
4. Compare with a spinner having unequal sector sizes to decide when simple label-counting fails.

**Visible consequence:** Two colours do not automatically mean equal chances; three red and one blue token give red chance 3/4.

**Definition/debrief:** For a finite equally likely sample space, P(E)=n(E)/n(S). The counting formula needs equal likelihood of elementary outcomes; colour labels or unequal spinner sectors may not be equally likely.

**Misconception:** “One of two colours means probability 1/2.” **Response:** Give every individual token an equal selection chance and count how many belong to each colour.

**Transfer question:** A bag has 3 red and 5 blue tokens. Randomly select one, each token equally likely. Find P(red).

**Worked answer:** Eight tokens total; three favourable. P(red)=3/8. P(blue)=5/8 and they sum to 1.

**Generation constraints:** Nonempty bag, draw one token with all tokens equally likely. For a spinner probability follows sector measure, not unweighted label count.

**Seed example:** {"red": 1, "blue": 3} → 1/4. Eight parameter sets × two modes = 16 slots.

#### g8b05 — Experimental frequency versus theoretical probability

**Reference:** Grade 8, chapter 8, printed pp. 204–207,214–217. **Prerequisites:** g7d01, g8b04.

**Learner goal:** Use recorded trials to estimate a chance while keeping the theoretical model distinct.

**Mathematical actions:**

1. Predict chance from a stated fair model.
2. Run or inspect repeated trials and tally event occurrences.
3. Compute observed frequency/number of trials.
4. Compare batches and explain why short-run counts need not match the prediction exactly.

**Visible consequence:** Trial proportions vary; an observed run of heads does not force the next fair independent toss to be tails.

**Definition/debrief:** Theoretical probability follows the model; experimental relative frequency is observed event count/trials. More trials can improve estimation but do not guarantee exact equality or monotonic improvement.

**Misconception:** “Five heads in a row makes tails certain next.” **Response:** Keep the next-trial model unchanged and compare several independent continuations.

**Transfer question:** A fair coin shows heads 13 times in 20 trials. Give experimental and theoretical probabilities.

**Worked answer:** Observed frequency=13/20=0.65. The fair-coin model gives P(head)=1/2. The difference can occur by chance; next independent toss remains 1/2.

**Generation constraints:** Trial count positive and event count between 0 and trials. Store deterministic trial data/seeds for offline replay; do not reject a valid random run for failing to equal theory.

**Seed example:** {"trials": 20, "heads": 6, "fair_model": true} → observed=3/10; theoretical=1/2. Eight parameter sets × two modes = 16 slots.

## Verification and remaining work

Run `python3 docs/learning/catalogue-validation.py` from the repository root. It checks JSON syntax and schema fields, unique IDs and models, all 15 chapter groups, prerequisite references and cycles, eight distinct parameter sets per blueprint, stable scenario IDs, numeric/specified invariants, selected transfer calculations, and CSV uniqueness/review status. Numeric equality checks use a restricted arithmetic evaluator; they are not a proof checker or a diagram engine.

Manual sample review covers the mathematical reasoning of negative multiplication, fraction division in both meanings, inequality reflection, principal square roots, congruence versus similarity, Euclidean projections, intercepted circle arcs, surface versus volume, equally likely probability outcomes and weighted mean. These checks validate the authored examples and structural constraints, not every possible future generated expression. A future generator must enforce the written constraints for every accepted sample and test diagram/correspondence validity before adding cases.

The current output does not include learner trials, official exam validation, renderer collision/accessibility testing, reviewed Oromo translation, native speaker recordings or validation of every original textbook exercise. The evidence supports a substantial, source-referenced content design and a deterministic route past 1,000 variations. It does not support a claim of a completed, validated 1,000-level app.
