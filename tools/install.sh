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
(( install_all == 0 || ${#faces[@]} > 0 )) || { echo "No face modules found" >&2; exit 1; }

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

command -v adb >/dev/null || { echo "adb is not available on the host" >&2; exit 1; }
mapfile -t devices < <(adb devices | awk 'NR > 1 && $2 == "device" {print $1}')
if [[ -n "$serial" ]]; then
  printf '%s\n' "${devices[@]}" | grep -Fxq "$serial" || { echo "ADB device is not connected: $serial" >&2; exit 1; }
elif (( ${#devices[@]} == 1 )); then
  serial=${devices[0]}
elif (( ${#devices[@]} == 0 )); then
  echo "No online ADB device found. Run adb connect first." >&2
  exit 1
else
  echo "Multiple ADB devices found; select one with --device SERIAL:" >&2
  printf '  %s\n' "${devices[@]}" >&2
  exit 1
fi

for face in "${faces[@]}"; do
  mapfile -t apks < <(find "faces/$face/build/outputs/apk/debug" -maxdepth 1 -type f -name '*.apk' -printf '%T@ %p\n' 2>/dev/null | sort -rn | cut -d' ' -f2-)
  (( ${#apks[@]} > 0 )) || { echo "No debug APK found for $face" >&2; exit 1; }
  apk=${apks[0]}
  package_id=$(sed -n 's/.*applicationId = "\([^"]*\)".*/\1/p' "faces/$face/build.gradle.kts" | head -n1)
  adb -s "$serial" install -r "$apk"
  echo "Installed $package_id from $apk on $serial"
done

echo "Select the installed watch face using the normal Wear OS picker."
