#!/usr/bin/env python3
"""Build an Android APK with the workspace-local pinned toolchain."""

import argparse
import hashlib
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import urllib.parse
import zipfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--release', action='store_true', help='Build a small optimized preview with the repository development signing key.')
    args = parser.parse_args()
    repo = Path(os.environ.get("HERREGA_REPO_ROOT", str(Path(__file__).resolve().parents[1]))).resolve()
    base = Path(os.environ.get("HERREGA_TOOLCHAINS", "/workspace/toolchains")).resolve()
    flutter = base / "flutter-3.10.6/bin/flutter"
    jdk = base / "java17/usr/lib/jvm/java-17-openjdk-amd64"
    sdk = base / "android-sdk"
    if not flutter.is_file() or not (jdk / "bin/java").is_file():
        raise SystemExit("Run tools/setup-flutter.sh and tools/setup-android.sh first.")
    if not (sdk / "platforms/android-33/android.jar").is_file():
        raise SystemExit("Pinned Android API 33 is missing; run tools/setup-android.sh.")

    settings = os.environ.copy()
    settings.update(
        JAVA_HOME=str(jdk), ANDROID_HOME=str(sdk), ANDROID_SDK_ROOT=str(sdk),
        ANDROID_USER_HOME=str(base / "android-user"),
        GRADLE_USER_HOME=str(base / "gradle-home"), PUB_CACHE=str(base / "pub-cache"),
        XDG_CONFIG_HOME=str(base / "config"),
        ANALYZER_STATE_LOCATION_OVERRIDE=str(base / "analyzer-state"), CI="true",
    )
    # Java does not automatically honour HTTPS_PROXY. Pass only validated
    # host/port properties to the wrapper; never echo the binding or credentials.
    try:
        proxy = urllib.parse.urlparse(settings.get("HTTPS_PROXY", ""))
        host, port = proxy.hostname, proxy.port or 80
        if proxy.username is not None or proxy.password is not None:
            raise ValueError("authenticated JVM proxy")
        if host and not re.fullmatch(r"[A-Za-z0-9_.:-]+", host):
            raise ValueError("invalid proxy host")
    except ValueError:
        raise SystemExit("The injected HTTPS_PROXY format is unsupported; its value was not printed.")
    if host:
        properties = [f"-D{protocol}.proxy{field}={value}"
                      for protocol in ("http", "https")
                      for field, value in (("Host", host), ("Port", port))]
        settings["GRADLE_OPTS"] = settings.get("GRADLE_OPTS", "") + " " + shlex.join(properties)

    mode = 'release' if args.release else 'debug'
    result = subprocess.run([str(flutter), "build", "apk", '--' + mode, "--no-pub"],
                            cwd=repo, env=settings)
    if result.returncode:
        return result.returncode
    apk = repo / ('build/app/outputs/flutter-apk/app-' + mode + '.apk')
    with zipfile.ZipFile(apk) as archive:
        if archive.testzip() is not None:
            raise SystemExit("APK ZIP integrity check failed.")
    with (base / "apk-signature-check.log").open("w") as log:
        verification = subprocess.run([
            str(sdk / "build-tools/30.0.3/apksigner"), "verify", "--verbose", str(apk)
        ], env=settings, stdout=log, stderr=subprocess.STDOUT)
    if verification.returncode:
        raise SystemExit("APK signature check failed; see toolchains/apk-signature-check.log.")
    print("APK ZIP integrity and development signature verified.")
    print("APK: " + str(apk))
    print("SHA256: " + hashlib.sha256(apk.read_bytes()).hexdigest())
    return 0


if __name__ == "__main__":
    sys.exit(main())
