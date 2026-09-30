# Work log — plan: docs/superpowers/plans/2026-09-30-herrega.md

Ruling: Proceed without design/plan approval pauses because the user explicitly requested autonomous work and no questions. Cost if assumptions need revision: prototype features and content can be revised before release.

Ruling: Build a representative maths prototype and a broad catalogue; science content and complete English literacy courses need separate source material. Cost: this iteration does not yet supply the full eventual app.

Pre-flight: scenario contract in the design is shared by engine, boards and shell. All consume the same enum, integer values map and board callbacks. Local progress is owned by the shell, not boards, to prevent duplicate rewards.

Toolchain: Flutter 3.10.6 and Dart 3.0.6 are installed, matching the existing dependency lockfile. Android builds use JDK 17, API 33, Gradle 7.5 and AGP 7.3.0. Verified archive downloads and the official Maven Central mirror are captured in reusable setup helpers. Both setup helpers were exercised in this workspace; bootstrap branches for a completely empty machine have not all been exercised.

Implemented preview: twelve game families with 100 deterministic rounds each, eight separate maths discovery labs and one English number-word lab. The recommendation route starts with arithmetic foundations and progressively revisits harder representations. Goal, construction, short explanation and separate transfer are connected in the actual app shell. Native progress uses app-private preferences; browser progress uses localStorage. Helped practice and independently solved questions receive separate accounting.

Textbook work: the supplied Grade 7 and Grade 8 books were extracted and studied. The checked catalogue contains 89 blueprints and 1,424 design slots. These are planning variants, not additional app screens. The coverage document maps all fifteen textbook chapters and records the remaining curriculum gaps. Current-year ministry exam coverage has not been verified.

Verification before the GitHub preview: 150 Flutter tests passed, including actual-shell narrow-phone layouts, local save failures, rapid taps, reward idempotence and separate transfer checks. The analyzer reports no issues. The optimized Android APK built successfully; archive integrity and its development signature were verified. No native device is attached, so installation, process restart and airplane mode still need phone testing.

Delivery: the user explicitly requested a GitHub push after the workspace download was inaccessible. Publish the source and approximately 20 MB APK together on the new `herrega-preview-2026-09-30` branch, preserving `main`. The GitHub API is blocked by the current environment network policy, so the artifact is included in the preview branch rather than an API-created release.
