#!/usr/bin/env bash
set -euo pipefail

avd_name=${WEARFACES_AVD_NAME:-wearfaces-wearos5}
system_image=${WEARFACES_SYSTEM_IMAGE:-"system-images;android-34;android-wear;x86_64"}
device_profile=${WEARFACES_DEVICE_PROFILE:-wearos_large_round}
recreate=0

while (($#)); do
  case "$1" in
    --recreate) recreate=1 ;;
    -h|--help)
      echo "Usage: $0 [--recreate]"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

if ((recreate)) && avdmanager list avd -c | grep -Fxq "$avd_name"; then
  avdmanager delete avd --name "$avd_name"
fi

if avdmanager list avd -c | grep -Fxq "$avd_name"; then
  echo "AVD already exists: $avd_name"
  exit 0
fi

printf 'no\n' | avdmanager create avd \
  --name "$avd_name" \
  --package "$system_image" \
  --device "$device_profile"

config="$HOME/.android/avd/${avd_name}.avd/config.ini"
{
  echo "hw.keyboard=yes"
  echo "hw.gpu.enabled=yes"
  echo "hw.gpu.mode=auto"
  echo "showDeviceFrame=no"
} >> "$config"

echo "Created AVD $avd_name using $system_image ($device_profile)."
