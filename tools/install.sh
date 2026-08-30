#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

no_build=0
install_all=0
serial=""
faces=()

while (($#)); do
  case "$1" in
    --no-build) no_build=1 ;;
    --all) install_all=1 ;;
    --device|-s)
      shift
      [[ $# -gt 0 ]] || { echo "--device requires an ADB serial" >&2; exit 2; }
      serial=$1
      ;;
    -h|--help)
      echo "Usage: $0 <face> [--no-build] [--device SERIAL] | $0 --all [--no-build] [--device SERIAL]"
      exit 0
      ;;
    --*) echo "Unknown option: $1" >&2; exit 2 ;;
    *) faces+=("$1") ;;
  esac
  shift
done

if ((install_all)); then
  mapfile -t faces < <(find faces -mindepth 2 -maxdepth 2 -name build.gradle.kts -printf '%h\n' | sed 's#^faces/##' | sort)
fi
(( ${#faces[@]} > 0 )) || { echo "Select a face or use --all" >&2; exit 2; }

for face in "${faces[@]}"; do
  [[ -f "faces/$face/build.gradle.kts" ]] || { echo "Unknown face: $face" >&2; exit 2; }
done

if ((no_build == 0)); then
  if [[ ${WEARFACES_NATIVE_BUILD:-0} == 1 ]]; then
    ./tools/validate.sh
    for face in "${faces[@]}"; do ./gradlew ":faces:${face}:assembleDebug"; done
  else
    ./tools/dev.sh validate
    for face in "${faces[@]}"; do ./tools/dev.sh build "$face"; done
  fi
fi

for face in "${faces[@]}"; do
  args=("$face" --no-build)
  [[ -z "$serial" ]] || args+=(--device "$serial")
  ./scripts/wearfaces install "${args[@]}"
done
