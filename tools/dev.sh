#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
image=${WEARFACES_IMAGE:-localhost/wearfaces-dev:0.1.0}
gradle_volume=${WEARFACES_GRADLE_VOLUME:-wearfaces-gradle-cache}
android_volume=${WEARFACES_ANDROID_VOLUME:-wearfaces-android-home}
command_name=${1:-test}
shift || true

command -v podman >/dev/null || { echo "Podman is required for the official environment." >&2; exit 1; }

case "$command_name" in
  image)
    exec podman build --tag "$image" "$repo_root"
    ;;
  rebuild)
    podman build --no-cache --tag "$image" "$repo_root"
    exit
    ;;
esac

if ! podman image exists "$image"; then
  podman build --tag "$image" "$repo_root"
fi

case "$command_name" in
  validate) inner=(./tools/validate.sh "$@") ;;
  test) inner=(./tools/test.sh "$@") ;;
  build)
    face=${1:-}
    if [[ -n "$face" ]]; then inner=(./gradlew ":faces:${face}:assembleDebug"); else inner=(./tools/build-all.sh); fi
    ;;
  shell) inner=(bash "$@") ;;
  *) echo "Usage: $0 {validate|test|build [face]|image|rebuild|shell}" >&2; exit 2 ;;
esac

exec podman run --rm \
  --userns=keep-id \
  --volume "$repo_root:/workspace:Z" \
  --volume "$gradle_volume:/home/wearfaces/.gradle:Z" \
  --volume "$android_volume:/home/ubuntu/.android:Z" \
  --workdir /workspace \
  "$image" "${inner[@]}"
