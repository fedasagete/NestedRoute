# Herrega: action-first maths catch-up

## Authorisation and goal

The user explicitly requested autonomous implementation without questions while away, prioritising intuitive gamification. This overrides the normal conversational design/plan approval pauses. Build a reviewable offline Flutter Android prototype and a catalogue of at least 1,000 scenarios. Do not publish, upload, or claim an exam-ready product.

The learner reads Afaan Oromo, struggles with arithmetic, and needs a route into Grade 7–8 concepts. English is taught through supporting words, never required to understand an interaction. The user will review translations and provide audio later. Do not invent recordings, imply translations are approved, or rely on online translation at runtime.

## Learning experience

Goal → direct mathematical manipulation → visible consequence → short definition → unassisted transfer question. Games use manipulatives that embody the mathematical relationship. Feedback is patient and unlimited. No speed penalties or public rankings. Animation supports state changes, and reduced motion is respected. A hint may demonstrate a step but does not award independent mastery. Track supported practice separately from independently solved transfer questions.

Home provides a recommended next activity and a map grouped into foundations, numbers/fractions, algebra, geometry and data/chance. All activities remain accessible for exploration; recommendations choose foundations first, then move to harder variants using demonstrated progress. Each activity exposes a source reference or explicitly marks foundation content as an added prerequisite.

## Scenario contract

`enum GameKind { numberLine, equalGroups, sharing, fractionTiles, balance, areaGrid, angleBuilder, similarity, volume, probability, sets, data }`.

`LearningScenario` has `String id`, `GameKind kind`, `int level` (1–3), `Map<String,int> values`, `String goal`, `String explanation`, `String transferPrompt`, `int transferAnswer`, `int? sourceGrade`, `int? sourcePage`. English strings are review copy; the interface uses short Afaan Oromo labels and numerical/visual prompts. `List<LearningScenario> buildScenarios()` generates exactly 1,200 deterministic scenarios: 100 per mechanic. Every value must be mathematically valid and there must be no duplicate ids. `scenariosFor(GameKind)` returns its 100 scenarios.

Parameters: numberLine `{start, delta}`; equalGroups `{groups, each}`; sharing `{total, people}` (divisible); fractionTiles `{parts, selected}`; balance `{factor, offset, solution}`; areaGrid `{width, height}`; angleBuilder `{a, b}` (positive missing third angle); similarity `{width, height, scale}`; volume `{width, depth, height}`; probability `{red, blue}` (both positive, transfer answer is total outcomes); sets `{aOnly, shared, bOnly}` (positive); data `{a,b,c,d,e}` (integer mean).

Each board constructor is `(LearningScenario scenario, ValueChanged<bool> onResult, bool showHint = false)`. The callback describes current correct construction, not permanent mastery. Boards disable duplicate award by leaving awarding to the shell. Every new scenario resets board state. Transfer questions are numerical to avoid relying on English literacy.

## Offline progress

`ProgressStore` loads/saves a versioned JSON state. Native Android uses a MethodChannel backed by app-private SharedPreferences. Web uses localStorage; unsupported native platforms may retain in memory and must not be advertised as persistent. Corrupt records recover safely. Serialise writes so an older record cannot overwrite newer progress. No network call is required by game or progress code.

Record completed construction, independent transfer, attempts and assisted status by scenario id. Replaying a completion does not farm stars. Local reset requires a clear confirmation because it deletes learner progress. Translation review exports are files in the repo; the learner interface does not expose implementation details.

## Textbook alignment and limitations

Sources: uploaded Grade 7/8 maths textbooks, Oromia Education Bureau, 2014 E.C./2022. Reading notes: `/workspace/textbook-study/reading-notes.md`. Mechanics cover representative foundational and hard concepts; the prototype is not complete chapter/exam coverage. Source references must be checked against printed pages. A catalogue must distinguish reusable teaching mechanisms from parameter variations. No assertion that 1,200 examples are 1,200 distinct methods.

## Validation

Validate all generated scenarios and numerical answers; test board interactions including incorrect state, correction, help and reset; test progress round-trip/corruption/idempotence; test representative home→construction→definition→transfer flow at Android-sized viewports. Run Flutter analysis, complete tests, and web build. Attempt an Android debug build if the SDK/toolchain is available; report any blocker specifically. Use a browser for an offline functional smoke test. Save tested toolchain/dependency/startup instructions for future cloud tasks.
