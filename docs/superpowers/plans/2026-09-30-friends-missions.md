# Sequenced concrete missions, with optional friends

User goal: enjoyable catch-up learning from arithmetic to Grade 7/8 ideas,
without a burdensome lesson sequence. Two friends can share the same Android
phone offline. No timers, rankings, or mandatory reading before manipulating
objects. Existing textbook coverage limitations remain.

Later steering: friends were an example, not the central feature. Primary work
is intuitive solo learning with explicit demonstrations and sequenced practice.

## Decisions and contracts

- Same-phone cooperation is the first friends mode. Every real object move
  passes the turn between two avatars. There is no account or networking.
- Completing a cooperative construction records supported practice, never
  an individual independent star. The next shared mission uses completed
  constructions to advance. Solo play retains the new-number transfer check.
- Start with three tangible missions: customer banana order, identical fruit
  baskets, equal picnic plates. Existing IDs and saved progress stay stable.
- Show the goal and objects first; show the equation after success. Instructions
  are optional. Demonstrations move the same pieces, then restore learner state
  and cannot complete the mission for the learner.
- First-time beginner missions teach with an automatic demonstration. The first
  three rounds in each of four opening representations change one parameter
  at a time. Solo and friends both continue after a construction goal; a written
  new-number check is optional, preserving honest independent-star accounting.
- Every topic and fixed discovery lab gets a short optional worked solution
  for its transfer question, with Oromo explanation and numerical steps.
- More difficult existing labs remain accessible for friends. This preview
  does not claim complete intermediate teaching or exam coverage.

## Tasks

1. Shared offline vector art and mission interfaces. Root owns mission_art.dart.
2. Banana order board and behavior tests. Arithmetic agent owns those two files.
3. Packing/sharing boards and behavior tests, independent files from order board.
4. Worked-solution data and mathematical validation, independent from boards.
5. Root: friends mode, turn ribbon, practice recommendations, optional guides,
   and solution pager. Test progress honesty and non-destructive demonstrations.
6. Review all changes; run tests/analyze, browser phone checks, build Android
   APK, update download/checksum, and push authorized preview branch.

Parallel work is limited to independent owned files with the signatures agreed
in task messages. Root integrates after their tests pass. No main merge or force
push. User already authorized pushing the preview for testing.
