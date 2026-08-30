#!/usr/bin/env bash
set -euo pipefail

headless=${WEARFACES_HEADLESS:-0}
recreate=0
wipe_data=0

while (($#)); do
  case "$1" in
    --headless) headless=1 ;;
    --recreate) recreate=1 ;;
    --wipe-data) wipe_data=1 ;;
    -h|--help)
      echo "Usage: $0 [--headless] [--recreate] [--wipe-data]"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

create_args=()
((recreate)) && create_args+=(--recreate)
/opt/wearfaces/create-avd.sh "${create_args[@]}"

emulator -accel-check

args=(
  -avd "${WEARFACES_AVD_NAME:-wearfaces-wearos5}"
  -accel on
  -no-boot-anim
  -no-snapshot-save
)
((wipe_data)) && args+=(-wipe-data)

if ((headless)); then
  args+=(-no-window -gpu swiftshader_indirect)
else
  args+=(-gpu auto)
fi

exec emulator "${args[@]}"
