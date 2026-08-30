#!/usr/bin/env bash
set -euo pipefail

headless=${WEARFACES_HEADLESS:-0}
recreate=0
wipe_data=0
clean_stale_locks=0

while (($#)); do
  case "$1" in
    --headless) headless=1 ;;
    --recreate) recreate=1 ;;
    --wipe-data) wipe_data=1 ;;
    --clean-stale-locks) clean_stale_locks=1 ;;
    -h|--help)
      echo "Usage: $0 [--headless] [--recreate] [--wipe-data] [--clean-stale-locks]"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

create_args=()
((recreate)) && create_args+=(--recreate)
/opt/wearfaces/create-avd.sh "${create_args[@]}"

if ((clean_stale_locks)); then
  avd_name=${WEARFACES_AVD_NAME:-wearfaces-wearos5}
  avd_home=${ANDROID_AVD_HOME:-"$HOME/.android/avd"}
  avd_dir="$avd_home/${avd_name}.avd"
  if [[ -d "$avd_dir" ]]; then
    find "$avd_dir" -maxdepth 1 -depth -name '*.lock' -delete
  fi
  if [[ -d "$avd_home/running" ]]; then
    find "$avd_home/running" -depth -mindepth 1 -delete
  fi
  echo "Cleared stale lock and discovery state for AVD $avd_name."
fi

emulator -accel-check

args=(
  -avd "${WEARFACES_AVD_NAME:-wearfaces-wearos5}"
  -accel on
  -no-boot-anim
  -no-metrics
  -no-snapshot-save
)
((wipe_data)) && args+=(-wipe-data)

if ((headless)); then
  args+=(-no-window -gpu swiftshader_indirect)
else
  args+=(-gpu auto)
fi

exec emulator "${args[@]}"
