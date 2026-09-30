# Herrega

Offline Afaan Oromo maths catch-up through direct interaction, adapted from the supplied Oromia Grade 7 and 8 maths textbooks. Start with counting steps, equal groups and sharing; discover harder ideas by moving tiles, balancing, reflecting and overlaying shapes. Every lesson ends with a separate question. Help and independently solved questions are tracked separately.

## Try the Android preview

[Download Herrega.apk](previews/Herrega.apk). Android 5.0 or later. This is an optimized development preview, signed with the development key, for testing outside the Play Store.

Tap **Jalqabi** for recommended arithmetic practice. The home screen also offers topic exploration, English number-word recognition, and eight maths discovery labs. Try airplane mode and reopening the app after completing a question. Translations remain provisional; recordings and broader English reading lessons are not included yet.

## What is implemented

- 1,200 deterministic rounds across twelve mathematical representations.
- Eight additional discovery labs: fraction division, signed multiplication, ratio mixtures, Pythagoras, circle angles, inequalities, square roots and congruence.
- ONE–FOUR printed English word recognition, with changed matching order.
- Goal → construction → short explanation → separate transfer → completion.
- Local progress in Android app-private preferences and browser localStorage; bundled fonts; no game or progress network request.
- A foundation-first recommendation route, with unrestricted topic exploration.

[Curriculum catalogue](docs/learning/catalogue.md) contains 89 teaching blueprints and 1,424 checked design slots. Those design slots are not additional implemented screens. [Coverage and learning route](docs/learning/coverage-and-route.md) records exactly which textbook concepts are represented and what still needs implementation. Complete chapter coverage, current ministry-exam alignment, science lessons, learner trials and reviewed translations/audio remain future work.

## Develop in the cloud workspace

The checkout is already isolated. Use it directly; no worktree is needed.

```sh
bash tools/setup-flutter.sh
bash tools/setup-android.sh
export PUB_CACHE=/workspace/toolchains/pub-cache
export XDG_CONFIG_HOME=/workspace/toolchains/config
export ANALYZER_STATE_LOCATION_OVERRIDE=/workspace/toolchains/analyzer-state
export CI=true
/workspace/toolchains/flutter-3.10.6/bin/flutter test --no-pub
/workspace/toolchains/flutter-3.10.6/bin/flutter analyze --no-pub
python3 docs/learning/catalogue-validation.py
python3 tools/build-android.py --release
```

Flutter 3.10.6 / Dart 3.0.6 matches the existing project; Dart dependencies and the lockfile were preserved. The compatible Android tooling uses JDK 17, API 33 and the existing Gradle 7.5 / AGP 7.3.0 versions. [Android development notes](docs/development-android.md) explains verified archives, the official Maven mirror, current-workspace repeatability and fresh-bootstrap limits.

For internal browser validation:

```sh
/workspace/toolchains/flutter-3.10.6/bin/flutter build web --web-renderer html --no-pub
python3 -m http.server 8765 --bind 127.0.0.1 --directory build/web
```

The cloud onboarding interface does not expose that loopback server as a user preview. Use the Android download for phone testing.

[Translation review CSV](docs/learning/translation-review.csv) has stable IDs and unreviewed draft glossary terms. Translation services are optional content-authoring tools; learner play remains offline. Full PDFs and personal learner data are not bundled.
