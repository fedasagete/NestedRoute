# Sequenced mission preview

The change addresses learner feedback that counters, formulas and instruction
pages did not make the games intuitive. Three tangible games now replace 74
existing numerical rounds: 34 small positive additions, 20 basket-packing cases
and 20 equal-sharing cases. The catalogue still contains 1,200 rounds and nine
fixed labs; these are not 1,209 different game mechanics.

## Opening practice sequence

| Familiar task | First goal | Next goal | Third goal |
| --- | --- | --- | --- |
| Banana order | 3 already there, add 2 | 3 already there, add 3 | 4 already there, add 3 |
| Matching baskets | 2 baskets, 2 in each | 2 baskets, 3 in each | 3 baskets, 3 in each |
| Equal picnic sharing | 9 among 3 | 12 among 3 | 12 among 4 |
| Parts of a whole | Select 1 of 4 | Select 2 of 4 | Select 2 of 6 |

Each set changes one parameter between rounds. The first three tasks have
automatic first-entry demonstrations with the actual fruit. The existing
fraction task retains its tile board and instruction guide. Completing a
construction advances suggested practice; a separate new-number question is
optional. Demonstrations and worked solutions do not award independent stars.
Friends can take turns on one phone, but solo learning remains the main route.

Instructions for the new games name their actual object controls. The number
line's left/right explanation is no longer shown for the banana basket.
After success, the basket example explicitly explains combining the original
bananas with the new ones. All 1,200 numerical transfers and nine fixed labs
have three to five short solution steps; the computation uses the transformed
values rather than copying stored answer metadata.

## Source verification

- Full automated regression suite: 251 passing tests; analyzer clean.
- All twelve representations and nine labs fit the real 320×640 shell at
  text scale 1.6, with six extra story/solo/friends cases.
- Six actual-shell teaching regressions watch the first real moved fruit and
  assert it is fully inside the visible viewport, with learner Continue still
  disabled. Automatic and manual examples bring receiving objects into view.
- Reviewed fixes cover stationary trays/buttons, new-scenario correctness
  reset, duplicate/rapid input, pending scroll cancellation and fast-save
  Continue taps. Board suites cover conserved fruit and undo/reset behavior.
- Worked solutions validate every numerical family and fixed lab, including
  inequality reversal, principal square roots and required fraction wording.
- Scope review has no remaining Critical or Important findings.
- Chromium checks at 320×844 and 390×844 complete the banana order,
  reject an incorrect transfer, accept the corrected answer, preserve the
  exact progress record after an offline reload, and complete basket packing
  and picnic sharing offline. No external requests or browser exceptions
  occur. The script uses real wheel scrolling and pointer taps for offscreen
  controls; scrolling Flutter's separate accessibility DOM alone does not
  move its painted board.

The optimized Android APK built successfully. ZIP integrity and its development
signature were checked. SHA-256:
`133f79dff8acaf1a9332882789bdd105177aa7dac9cb2abd9ac9d080e27b426a`.
The checked APK and checksum are stored together under `previews/`.

Source-level and browser checks do not establish native
installation, native process restart or learner understanding.

## Remaining teaching work

The opening sequence is a concrete improvement; the complete advanced path
still needs intermediate teaching and learner trials. Afaan Oromo wording is
an educator-review draft. Full current ministry-exam coverage, broader English
literacy, science content and audio remain unverified or unimplemented. The
textbook coverage document records the remaining curriculum gaps.
