#!/usr/bin/env bash
set -euo pipefail

# The checkout is already isolated. This setup needs no Git worktree.
HERREGA_SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
HERREGA_REPO_ROOT="${HERREGA_REPO_ROOT:-$(CDPATH= cd -- "$HERREGA_SCRIPT_DIR/.." && pwd)}"
HERREGA_TOOLCHAINS="${HERREGA_TOOLCHAINS:-/workspace/toolchains}"

python3 - "$HERREGA_TOOLCHAINS" "$HERREGA_REPO_ROOT" <<'PY'
import hashlib
import os
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import sys
import urllib.parse
import urllib.request
import zipfile

base = Path(sys.argv[1]).resolve()
repo = Path(sys.argv[2]).resolve()
sdk = base / "android-sdk"
flutter = base / "flutter-3.10.6"
jdk = base / "java17/usr/lib/jvm/java-17-openjdk-amd64"
mirror = "https://storage.googleapis.com/maven-central/maven2/"
base.mkdir(parents=True, exist_ok=True)

if sys.platform != "linux" or os.uname().machine != "x86_64":
    raise SystemExit("This pinned setup supports Linux x86_64 only.")
if not (flutter / "bin/flutter").is_file():
    raise SystemExit("Prepare Flutter 3.10.6 with tools/setup-flutter.sh first.")
wrapper = (repo / "android/gradle/wrapper/gradle-wrapper.properties").read_text()
distribution = "https://services.gradle.org/distributions/gradle-7.5-all.zip"
if "distributionUrl=" + distribution.replace(":", "\\:") not in wrapper:
    raise SystemExit("Expected repository Gradle 7.5 all; build versions were not changed.")

# Values came from Google's HTTPS SDK repository metadata and the official
# Gradle checksum. Debian package SHA256 values came from a signed Bookworm
# package index verified with the installed Debian archive keyring and sqv.
packages = [
    ("platform-tools_r37.0.1-linux.zip", "477254aa5f903c15cf51001717bdf347fb6b53e0", "platform-tools"),
    ("build-tools_r30.0.3-linux.zip", "2076ea81b5a2fc298ef7bf85d666f496b928c7f1", "build-tools/30.0.3"),
    ("platform-33-ext3_r03.zip", "394bc86d8d3452aa4d419b67743025a6fb2cd9d0", "platforms/android-33"),
    ("commandlinetools-linux-11076708_latest.zip", "d313adb7aedccf6cf0cfca51ec180f0059f5f8f8", "cmdline-tools/12.0"),
]
debs = [
    ("openjdk-17-jre-headless_17.0.19+10-1~deb12u2_amd64.deb", "587784e0d7efa5256b2224c2f177850a2408485b19ab7e5cb206ceba6a6e9bd4"),
    ("openjdk-17-jdk-headless_17.0.19+10-1~deb12u2_amd64.deb", "390eff9273f019e2839a0faaef7a7326d11c32c7db8320316dc6feac48ed2598"),
]
gradle_sha256 = "97a52d145762adc241bad7fd18289bf7f6801e08ece6badf80402fe2b9f250b1"

def digest(path, algorithm):
    result = hashlib.new(algorithm)
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            result.update(chunk)
    return result.hexdigest()

def verified_download(url, filename, expected, algorithm):
    archive = base / filename
    if not archive.exists():
        partial = archive.with_name(archive.name + ".part")
        with urllib.request.urlopen(url, timeout=60) as source, partial.open("wb") as out:
            shutil.copyfileobj(source, out)
        if digest(partial, algorithm) != expected:
            raise RuntimeError("Download checksum mismatch: " + filename)
        partial.replace(archive)
    if digest(archive, algorithm) != expected:
        raise RuntimeError("Cached archive checksum mismatch: " + filename)
    print("Verified " + filename, flush=True)
    return archive

def extract_sdk(archive, destination):
    with zipfile.ZipFile(archive) as zipped:
        for entry in zipped.infolist():
            components = PurePosixPath(entry.filename).parts[1:]
            if not components:
                continue
            target = destination.joinpath(*components)
            if not target.resolve().is_relative_to(destination.resolve()):
                raise RuntimeError("SDK archive path escapes its destination")
            if entry.is_dir():
                target.mkdir(parents=True, exist_ok=True)
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            # A running adb/aapt binary cannot be truncated in place. Replace
            # the inode atomically so repeat setup also works with an adb daemon.
            temporary = target.with_name("." + target.name + ".herrega-" + str(os.getpid()))
            with zipped.open(entry) as source, temporary.open("wb") as out:
                shutil.copyfileobj(source, out)
            mode = (entry.external_attr >> 16) & 0o777
            if mode:
                temporary.chmod(mode)
            temporary.replace(target)

deb_archives = [verified_download(
    "https://deb.debian.org/debian/pool/main/o/openjdk-17/" + name,
    name, checksum, "sha256") for name, checksum in debs]
if not (jdk / "bin/java").exists():
    if shutil.which("dpkg-deb") is None:
        raise SystemExit("dpkg-deb is needed to extract the pinned JDK packages.")
    java_root = base / "java17"
    java_root.mkdir(exist_ok=True)
    for archive in deb_archives:
        subprocess.run(["dpkg-deb", "--extract", str(archive), str(java_root)], check=True)
    for item in java_root.rglob("*"):
        if item.is_symlink():
            target = item.readlink()
            local = java_root.joinpath(*target.parts[1:])
            if target.is_absolute() and local.exists():
                item.unlink()
                item.symlink_to(local)
version = subprocess.run([str(jdk / "bin/java"), "-version"],
                         capture_output=True, text=True, check=True)
if 'version "17.0.19"' not in version.stderr:
    raise SystemExit("Existing workspace JDK differs from pinned OpenJDK 17.0.19.")
print("OpenJDK 17.0.19 ready", flush=True)

for name, checksum, destination in packages:
    archive = verified_download("https://dl.google.com/android/repository/" + name,
                                name, checksum, "sha1")
    extract_sdk(archive, sdk / destination)
latest = sdk / "cmdline-tools/latest"
if latest.is_symlink():
    if latest.readlink() != Path("12.0"):
        raise SystemExit("Existing cmdline-tools/latest points elsewhere; preserving it.")
elif latest.exists():
    raise SystemExit("Existing cmdline-tools/latest directory preserved; use pinned tools 12.0.")
else:
    latest.symlink_to("12.0", target_is_directory=True)

archive = verified_download("https://downloads.gradle.org/distributions/gradle-7.5-all.zip",
                            "gradle-7.5-all.zip", gradle_sha256, "sha256")
# Gradle's wrapper hashes its distribution URL as unsigned MD5, base36.
number = int(hashlib.md5(distribution.encode(), usedforsecurity=False).hexdigest(), 16)
alphabet = "0123456789abcdefghijklmnopqrstuvwxyz"
identifier = ""
while number:
    number, remainder = divmod(number, 36)
    identifier = alphabet[remainder] + identifier
cache = base / "gradle-home/wrapper/dists/gradle-7.5-all" / identifier
cache.mkdir(parents=True, exist_ok=True)
cached_zip = cache / archive.name
if not cached_zip.exists() or digest(cached_zip, "sha256") != gradle_sha256:
    shutil.copyfile(archive, cached_zip)

init = base / "gradle-home/init.d/central-mirror.gradle"
init.parent.mkdir(parents=True, exist_ok=True)
init.write_text("""import org.gradle.api.artifacts.repositories.MavenArtifactRepository

gradle.beforeProject { project ->
    [project.buildscript.repositories, project.repositories].each { repositories ->
        repositories.all { repository ->
            if (repository instanceof MavenArtifactRepository) {
                def source = repository.url.toString().replaceAll('/+$', '')
                if (source in ['https://repo.maven.apache.org/maven2', 'https://repo1.maven.org/maven2']) {
                    repository.setUrl('https://storage.googleapis.com/maven-central/maven2/')
                }
            }
        }
    }
}
""")
gradle_script = flutter / "packages/flutter_tools/gradle/flutter.gradle"
original = gradle_script.read_text()
replacement = "maven { url '" + mirror + "' }"
if original.count("mavenCentral()") == 1:
    backup = base / "flutter-gradle-original-3.10.6.gradle"
    if backup.exists() and backup.read_text() != original:
        raise SystemExit("Existing Flutter Gradle backup differs; preserving it.")
    if not backup.exists():
        backup.write_text(original)
    gradle_script.write_text(original.replace("mavenCentral()", replacement))
elif original.count(replacement) != 1 or "mavenCentral()" in original:
    raise SystemExit("Unexpected Flutter SDK Gradle configuration; no blind rewrite performed.")

settings = os.environ.copy()
settings.update(JAVA_HOME=str(jdk), ANDROID_HOME=str(sdk), ANDROID_SDK_ROOT=str(sdk),
                ANDROID_USER_HOME=str(base / "android-user"))
if not (sdk / "licenses/android-sdk-license").exists():
    args = [str(sdk / "cmdline-tools/12.0/bin/sdkmanager"), "--sdk_root=" + str(sdk), "--licenses"]
    proxy = urllib.parse.urlparse(settings.get("HTTPS_PROXY", ""))
    if proxy.hostname:
        args += ["--proxy=http", "--proxy_host=" + proxy.hostname,
                 "--proxy_port=" + str(proxy.port or 80)]
    with (base / "android-licenses.log").open("w") as log:
        subprocess.run(args, input="y\n" * 100, text=True, stdout=log,
                       stderr=subprocess.STDOUT, env=settings, check=True)
print("Android SDK, JDK and Gradle caches prepared; repository build versions retained.")
print("Next: python3 tools/build-android.py")
PY
