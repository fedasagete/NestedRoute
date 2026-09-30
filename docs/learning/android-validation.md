# Android progress and build validation

Date: 30 September 2026.

`MainActivity` registers `herrega/progress` with the existing Flutter engine.
`read` returns the JSON string or null. `write` accepts a string and returns null
only after `SharedPreferences.Editor.commit()` succeeds. Invalid argument types
return `INVALID_RECORD`; a failed commit returns `WRITE_FAILED`. Unknown methods
are not implemented. The record uses app-private `herrega_progress` preferences;
progress requires no external storage permission or network request.

## Verified platform boundary

Run from the repository root:

```sh
PUB_CACHE=/workspace/toolchains/pub-cache \
XDG_CONFIG_HOME=/workspace/toolchains/config \
ANALYZER_STATE_LOCATION_OVERRIDE=/workspace/toolchains/analyzer-state \
CI=true /workspace/toolchains/flutter-3.10.6/bin/flutter \
  test --no-pub test/native_progress_test.dart --reporter expanded
```

Four tests passed: absent-record read, learner progress round-trip, waiting for
the native acknowledgement, and propagation of `WRITE_FAILED`. The tests use
the real `NativeProgressBackend` and `ProgressStore` with a mocked MethodChannel
boundary. They verify the Dart caller contract; they do not execute Android
SharedPreferences or establish persistence across an Android process restart.
The tests passed against the existing Dart backend before adding the Kotlin
bridge. Native implementation validation therefore depends on the Android
build and eventual device test below.

`dart analyze test/native_progress_test.dart` completed with no issues using
the same cache/configuration variables.

## Prepared toolchain

- Flutter 3.10.6 / Dart 3.0.6.
- OpenJDK 17.0.19, compatible with the repository's Gradle 7.5 and AGP 7.3.0.
- Android API 33 base platform, revision 3; Build Tools 30.0.3.
- Android Platform Tools 37.0.1 and command-line tools 12.0.
- Existing Kotlin Gradle plugin 1.7.10. Repository Gradle versions were retained.

The JDK/JRE Debian packages were extracted under `/workspace/toolchains/java17`.
Debian's installed archive keyring and `sqv` verified the Bookworm InRelease;
the signed SHA256 verified the package index, and that index's SHA256 values
verified both packages before extraction. SHA256 values:

```text
openjdk-17-jre-headless: 587784e0d7efa5256b2224c2f177850a2408485b19ab7e5cb206ceba6a6e9bd4
openjdk-17-jdk-headless: 390eff9273f019e2839a0faaef7a7326d11c32c7db8320316dc6feac48ed2598
```

SDK ZIPs were checked against the SHA1 values in Google's HTTPS repository XML.
Gradle 7.5 `all` was checked against its official published SHA256:
`97a52d145762adc241bad7fd18289bf7f6801e08ece6badf80402fe2b9f250b1`.
TLS and package verification remained enabled.

The newest 2026 Android CLI attempted to create a binary directory outside the
writable workspace. The official command-line tools 12.0 package avoids that
problem. `/workspace/toolchains/android-sdk/cmdline-tools/latest` points to
`12.0`. All tool files and caches remain under `/workspace/toolchains`.

## Build command and status

The prepared helper runs the actual Flutter debug build with process-local
`JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT`, `ANDROID_USER_HOME`,
`GRADLE_USER_HOME`, and the Flutter cache/configuration variables:

```sh
python3 /workspace/toolchains/run-android-build.py
```

The helper derives JVM proxy host/port properties in `GRADLE_OPTS` from the
existing `HTTPS_PROXY` binding without changing global environment variables
or exposing credentials. Java does not automatically honour `HTTPS_PROXY`:
the first build reached Gradle but failed with
`UnknownHostException: services.gradle.org`. A checksum-verified Gradle archive
was then put in its wrapper cache, and JVM proxy properties were supplied.

The Android debug build **passed**, exit 0; `assembleDebug` completed in 81.1
seconds. It compiled the Kotlin bridge and produced:

```text
/workspace/NestedRoute/build/app/outputs/flutter-apk/app-debug.apk
69,581,571 bytes
SHA256: 7a7bd585de8cd284d2332983417f5268d97c8e4ac8ab9567bdc9c709a7b3a9f6
```

The build log is `/workspace/toolchains/android-debug-build.log`. ZIP integrity
passed, and the compiled DEX contains the progress channel, preference name,
and both error codes. `apksigner verify --verbose` returned exit 0 with v1 and
v2 verification passing. It reported warnings for standard META-INF entries
under v1; v2 verifies the complete APK. This is a debug-signed prototype APK.

Maven Central initially returned HTTP 429 from both official endpoints. Google's
mirror domain returned proxy 403 even after its domain was saved in the cloud
configuration draft; a draft save did not update active network access. The
same official mirror works through the already accessible bucket URL:

```text
https://storage.googleapis.com/maven-central/maven2/
```

Its `fastutil:8.4.0` POM had the expected coordinates and matched its published
SHA1, `7ec92f6e71ce4abebde5cebd574a6f27528959d7`. No unofficial repository or
TLS bypass was used.

## Reproduce the mirror configuration

The prepared Gradle user home contains `init.d/central-mirror.gradle`:

```groovy
import org.gradle.api.artifacts.repositories.MavenArtifactRepository

gradle.beforeProject { project ->
    [project.buildscript.repositories, project.repositories].each { repositories ->
        repositories.all { repository ->
            if (repository instanceof MavenArtifactRepository) {
                def source = repository.url.toString().replaceAll('/+$', '')
                if (source in ['https://repo.maven.apache.org/maven2',
                               'https://repo1.maven.org/maven2']) {
                    repository.setUrl('https://storage.googleapis.com/maven-central/maven2/')
                }
            }
        }
    }
}
```

Flutter 3.10.6's applied `flutter.gradle` uses a separate script repository
handler, so the project init hook alone cannot override its dependency source.
The sole `mavenCentral()` call in the installed SDK file
`packages/flutter_tools/gradle/flutter.gradle` is locally changed to:

```groovy
maven { url 'https://storage.googleapis.com/maven-central/maven2/' }
```

The unchanged original is retained at
`/workspace/toolchains/flutter-gradle-original-3.10.6.gradle`. On a fresh pinned
SDK, apply the same exact replacement once, asserting that the original has
exactly one `mavenCentral()` call. Repository Android Gradle files and build
versions remain unchanged.

The verified SDK installer and selected checksum metadata are retained at
`/workspace/toolchains/install-android-sdk.py` and
`/workspace/toolchains/android-packages-selected.json`; rerunning the installer
successfully rechecked and reinstalled the selected official packages. The
verified JDK extraction helper and signed metadata are retained alongside them
as `install-java17.py`, `bookworm-InRelease`, `bookworm-Release.verified`,
`bookworm-Packages.xz`, and `java17-packages.json`.

For future builds, the helper uses these exact paths:

```text
JAVA_HOME=/workspace/toolchains/java17/usr/lib/jvm/java-17-openjdk-amd64
ANDROID_HOME=/workspace/toolchains/android-sdk
ANDROID_SDK_ROOT=/workspace/toolchains/android-sdk
ANDROID_USER_HOME=/workspace/toolchains/android-user
GRADLE_USER_HOME=/workspace/toolchains/gradle-home
```

Rebuild after application source changes; the checksum above identifies this
validation run, rather than every future APK.

No Android device or emulator has been tested. On a device, save independent
progress, force-stop and reopen the app, and verify the saved progress returns.
The prototype does not yet expose a progress-reset flow. Device checks remain
separate from a successful APK build.
