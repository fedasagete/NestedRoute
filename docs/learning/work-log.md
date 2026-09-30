# Work log — plan: docs/superpowers/plans/2026-09-30-herrega.md

Ruling: Proceed without design/plan approval pauses because the user explicitly requested autonomous work and no questions. Cost if assumptions need revision: prototype features and content can be revised before release.

Ruling: Build a representative maths prototype and a broad catalogue; science content and complete English literacy courses need separate source material. Cost: this iteration does not yet supply the full eventual app.

Pre-flight: scenario contract in the design is shared by engine, boards and shell. All consume the same enum, integer values map and board callbacks. Local progress is owned by the shell, not boards, to prevent duplicate rewards.

Toolchain: Flutter 3.10.6 and Dart 3.0.6 are installed, matching the existing dependency lockfile. Android builds use JDK 17, API 33, Gradle 7.5 and AGP 7.3.0. Verified archive downloads and the official Maven Central mirror are captured in reusable setup helpers. Both setup helpers were exercised in this workspace; bootstrap branches for a completely empty machine have not all been exercised.

Implemented preview: twelve game families with 100 deterministic rounds each, eight separate maths discovery labs and one English number-word lab. The recommendation route starts with arithmetic foundations and progressively revisits harder representations. Goal, construction, short explanation and separate transfer are connected in the actual app shell. Native progress uses app-private preferences; browser progress uses localStorage. Helped practice and independently solved questions receive separate accounting.

Textbook work: the supplied Grade 7 and Grade 8 books were extracted and studied. The checked catalogue contains 89 blueprints and 1,424 design slots. These are planning variants, not additional app screens. The coverage document maps all fifteen textbook chapters and records the remaining curriculum gaps. Current-year ministry exam coverage has not been verified.

Verification before the GitHub preview: 150 Flutter tests passed, including actual-shell narrow-phone layouts, local save failures, rapid taps, reward idempotence and separate transfer checks. The analyzer reports no issues. The optimized Android APK built successfully; archive integrity and its development signature were verified. No native device is attached, so installation, process restart and airplane mode still need phone testing.

Delivery: the user explicitly requested a GitHub push after the workspace download was inaccessible. Publish the source and approximately 20 MB APK together on the new `herrega-preview-2026-09-30` branch, preserving `main`. The GitHub API is blocked by the current environment network policy, so the artifact is included in the preview branch rather than an API-created release.

Actual preview feedback: the user liked the app but found some activities difficult to understand and needed instructions. The update adds short bilingual control steps for all twelve boards and nine labs, a visible instruction pager, a button to reach the actual board and a book button to return. The final explanation is reserved for after construction and includes plain Afaan Oromo words. Optional related level-1 practice opens over the original game; returning retains its construction and selected instruction. A single scroll view retains the board and guide while scrolling. Complete regression suite: 161 passed, including control navigation, state preservation, independent rewards, English reference hiding and all narrow-phone cases. Translations still need human review.

Reusable cloud configuration: the complete install script and startup instructions were saved successfully in the environment draft. The exact install script passed a repeat run in this workspace; its outside-repository native build helper reproduced the published initial APK checksum. Existing allowed domains were preserved, with dl.google.com, deb.debian.org, downloads.gradle.org and services.gradle.org added for verified toolchain sources. Draft persistence does not mean the environment has been published or the live network policy has changed.

Internal browser check before the guidance update: a complete arithmetic lesson rejected a wrong transfer, persisted a correct transfer, reloaded offline with the exact same progress record and opened an interactive next lesson. Both 320px and 390px views passed with no external request or JavaScript exception. Browser loader assets were warmed under service-worker control before offline reload; native Android bundles its assets and needs no such browser warm-up. Updated-guidance browser checks are recorded separately when run.

Guided preview delivery verified: source/APK commit `a5c4c22bd9e6935d2ecee1f8bb2dd845347eaf56` is on GitHub. Its browser build and the updated smoke helper passed at both phone widths, including visible instructions, Taphadhu navigation, wrong/correct transfer and offline restoration. The complete suite passed 161 tests, the analyzer is clean, and the APK checksum is recorded in guided-preview-validation.md. The working tree is ready for the next learner feedback iteration.

Sequenced mission feedback: the user disliked the abstract counters/formulas and
wanted enjoyable learning without unexplained jumps. Friends were clarified as
an example rather than the main feature. Three tangible banana/order/basket/
picnic games replace 74 existing numeric rounds. First-entry teacher moves use
the actual objects, restore learner work, and never complete the goal on the
learner's behalf. The first 12 practice rounds change one parameter at a time
within each representation; new-number checks are optional. Friends remain an
optional same-phone mode, counted as supported practice. Goal completion and
solved-alone counts are labeled separately, avoiding a numerical claim about
the learner's total understanding.

New solution support: all 1,209 transfer questions have short numbered bilingual
derivations. Mathematical steps derive changed values independently rather
than reading the answer field. Viewing them marks the transfer as assisted.
Oromo phrasing still needs educator review; full advanced prerequisites are
not claimed.

Review-driven corrections: preserved source tray slots and control positions;
reset shell correctness after changing scenarios; fixed rapid +1 taps to read
the current supply; guarded Continue callbacks against skipping the meaning
after an immediate save; and forced cooperative answers to remain assisted.
Actual-shell probes then caught first teaching moves running below the visible
viewport. Automatic and manual examples now reveal receiving objects before
moving them, lock input during preparation and cancel stale pending starts.
Six real-shell regressions verify the first moved fruit is visible at 320×640
with 1.6 text, both solo and friends. Scope review has no remaining Critical or
Important findings. Final release verification and artifact details are in
sequenced-preview-validation.md.

Release verification completed: 251 tests pass, analysis is clean, and the
optimized Android APK's ZIP integrity and signature are valid. Real browser
scrolling/taps at 320 and 390 pixels complete the opening order, matching
baskets and equal-sharing picnic offline, with saved progress restored and
no external requests or browser exceptions. The source and its matching APK
are delivered together on the existing authorized preview branch. APK SHA-256:
133f79dff8acaf1a9332882789bdd105177aa7dac9cb2abd9ac9d080e27b426a.
