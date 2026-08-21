#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
  set -- faces/*/build/outputs/apk/release/*.apk
fi

files=()
for candidate in "$@"; do
  [[ -f "$candidate" ]] && files+=("$candidate")
done
(( ${#files[@]} > 0 )) || { echo "No APK files found" >&2; exit 1; }
sha256sum "${files[@]}"
