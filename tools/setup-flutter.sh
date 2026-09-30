#!/usr/bin/env bash
set -euo pipefail

# Every cloud task already has an isolated checkout; no worktree is needed.
HERREGA_SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
HERREGA_REPO_ROOT="${HERREGA_REPO_ROOT:-$(CDPATH= cd -- "$HERREGA_SCRIPT_DIR/.." && pwd)}"
HERREGA_TOOLCHAINS="${HERREGA_TOOLCHAINS:-/workspace/toolchains}"
HERREGA_FLUTTER="$HERREGA_TOOLCHAINS/flutter-3.10.6"
HERREGA_FLUTTER_REVISION=f468f3366c26a5092eb964a230ce7892fda8f2f8

mkdir -p "$HERREGA_TOOLCHAINS/config" "$HERREGA_TOOLCHAINS/pub-cache" "$HERREGA_TOOLCHAINS/analyzer-state"
export PUB_CACHE="$HERREGA_TOOLCHAINS/pub-cache"
export XDG_CONFIG_HOME="$HERREGA_TOOLCHAINS/config"
export ANALYZER_STATE_LOCATION_OVERRIDE="$HERREGA_TOOLCHAINS/analyzer-state"
export CI=true

if [ ! -f "$HERREGA_FLUTTER/bin/flutter" ]; then
  git clone --depth 1 --branch 3.10.6 https://github.com/flutter/flutter.git "$HERREGA_FLUTTER"
fi
if [ "$(git -C "$HERREGA_FLUTTER" rev-parse HEAD)" != "$HERREGA_FLUTTER_REVISION" ]; then
  echo 'Expected the pinned Flutter 3.10.6 revision; existing toolchain was left unchanged.' >&2
  exit 1
fi

"$HERREGA_FLUTTER/bin/flutter" config --no-analytics
"$HERREGA_FLUTTER/bin/flutter" precache --web --android
cd "$HERREGA_REPO_ROOT"
"$HERREGA_FLUTTER/bin/flutter" pub get --enforce-lockfile
"$HERREGA_FLUTTER/bin/flutter" --version
