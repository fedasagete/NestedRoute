# Android development

The repository scripts reproduce the Android toolchain configuration validated
in this cloud workspace. Prepare Flutter first, then prepare Android and build:

```sh
tools/setup-flutter.sh
tools/setup-android.sh
python3 tools/build-android.py
```

Run these commands from the repository root. `HERREGA_TOOLCHAINS` selects the
toolchain directory; its default is `/workspace/toolchains`. Only the default
directory has been exercised here. The existing cloud checkout is isolated;
setup needs no Git worktree.

## Prerequisites and pins

The setup supports Linux x86_64 with Python 3.9 or newer. Flutter 3.10.6 and its
project dependencies must already be prepared by the Flutter setup. Extracting
a missing JDK requires `dpkg-deb`, compatible Debian system libraries, and a
working Java certificate store. This workspace already supplied those system
prerequisites. Network access is needed when archives or Gradle dependencies
are not cached:

- `deb.debian.org` for the pinned OpenJDK packages.
- `dl.google.com` for the Android SDK and Google Maven artifacts.
- `downloads.gradle.org` for Gradle 7.5.
- `storage.googleapis.com` for Flutter artifacts and Google's Maven Central mirror.

The scripts verify downloaded and cached archives before use:

| Component | Pinned version | Verification |
| --- | --- | --- |
| OpenJDK JDK/JRE | 17.0.19+10-1~deb12u2 | SHA256 from an authenticated Debian package index |
| Android platform | API 33 base, revision 3 | Published Google SHA1 |
| Android Build Tools | 30.0.3 | Published Google SHA1 |
| Android Platform Tools | 37.0.1 | Published Google SHA1 |
| Android command-line tools | 12.0 | Published Google SHA1 |
| Gradle `all` distribution | 7.5 | Published SHA256 |

The Debian hashes were originally authenticated by verifying the Bookworm
InRelease with Debian's archive keyring and `sqv`, then verifying the package
index and packages. Those package hashes are pinned in the script; setup checks
the pinned SHA256 rather than selecting a newer package from a moving index.
The SDK hashes came from Google's HTTPS repository XML. Python uses normal TLS
certificate verification for downloads. A cached checksum mismatch stops setup.

The repository retains Gradle 7.5, Android Gradle Plugin 7.3.0 and Kotlin 1.7.10.
Setup checks the wrapper's pinned distribution and uses workspace-local JDK 17.

| Location | Purpose |
| --- | --- |
| `flutter-3.10.6` | Flutter SDK |
| `java17/usr/lib/jvm/java-17-openjdk-amd64` | `JAVA_HOME` |
| `android-sdk` | `ANDROID_HOME` / `ANDROID_SDK_ROOT` |
| `android-user` | Android SDK user state |
| `gradle-home` | `GRADLE_USER_HOME`, wrapper cache and mirror init script |
| `pub-cache`, `config`, `analyzer-state` | Flutter/Dart caches and configuration |

These paths are relative to `HERREGA_TOOLCHAINS`. Setup replaces SDK files
atomically, allowing repeat setup while ADB is running. The `latest` command-line
tools symlink targets `12.0`; conflicting existing directories or links are
preserved and reported. If the SDK licence record is missing, the script invokes
`sdkmanager --licenses` with acceptance input and records its output in
`android-licenses.log`.

## Network and mirror configuration

Java does not automatically use the injected `HTTPS_PROXY` binding. The build
wrapper derives validated HTTP/HTTPS JVM proxy host and port properties in
`GRADLE_OPTS`, without printing the binding or credentials. It supports this
workspace's unauthenticated proxy route. Authenticated proxy URLs are rejected
without exposing their values.

Both Maven Central endpoints returned HTTP 429 here. Google's official mirror
is reachable at:

```text
https://storage.googleapis.com/maven-central/maven2/
```

Setup installs `gradle-home/init.d/central-mirror.gradle` to use this mirror for
project repositories. Flutter 3.10.6's applied Gradle script has a separate
repository handler. Setup therefore changes its sole `mavenCentral()` call to:

```groovy
maven { url 'https://storage.googleapis.com/maven-central/maven2/' }
```

This is a local Flutter SDK configuration change. The original is retained as
`flutter-gradle-original-3.10.6.gradle` alongside the toolchains. Already applied
configuration is recognised on later setup runs. An unexpected SDK script or
conflicting backup stops setup rather than overwriting it.

## Validation and limits

On 30 September 2026, `tools/setup-android.sh` passed twice consecutively against
the prepared toolchain, including archive verification, SDK reinstallation,
Gradle cache preparation and recognition of the existing SDK mirror patch.
The repository build wrapper then passed with exit 0; `assembleDebug` completed
in 5.4 seconds using the prepared caches. An authenticated-proxy rejection check
also confirmed that neither supplied username nor password appeared in output.

`python3 tools/build-android.py` builds the actual debug APK with `--no-pub`,
preserves the Flutter command's failure status, checks ZIP integrity, and checks
the debug signature. It prints the APK path and SHA256 after verification.
Signature details, including standard v1 META-INF warnings, are retained in
`apk-signature-check.log`; the validated APK also passes v2 signature checking.
The APK is at `build/app/outputs/flutter-apk/app-debug.apk`. Rebuild after source
changes before sharing the artifact.

The repository scripts have not been exercised with an empty toolchain
directory or a fresh operating-system image. The missing-archive download,
missing-JDK extraction and missing-license branches remain untested as part of
these repository scripts. Initial provisioning used the same official archives
and verification values through workspace helpers. Pinned Debian package URLs
can eventually expire; setup reports a download failure rather than substituting
an unverified archive. This is a prepared-workspace validation, not a claim of
universal fresh-machine support.

`/dev/kvm` is absent, no emulator/image is installed, and the actual ADB device
query returned an empty attached-device list. No large emulator image was
downloaded. Android process-restart progress and offline device interaction
checks remain outstanding; see [Android validation](learning/android-validation.md).
