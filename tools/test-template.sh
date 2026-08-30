#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

slug=template-smoke
spec=docs/watchfaces/TEMPLATE-SMOKE.md
module=faces/$slug
settings_backup=$(mktemp)
cp settings.gradle.kts "$settings_backup"

cleanup() {
  cp "$settings_backup" settings.gradle.kts
  rm -f "$settings_backup" "$spec"
  rm -rf "$module"
}
trap cleanup EXIT

[[ ! -e "$module" && ! -e "$spec" ]] || { echo "Template smoke-test paths already exist" >&2; exit 1; }
./scripts/wearfaces create "$slug" --name "Template Smoke"

grep -Fq 'include(":faces:template-smoke")' settings.gradle.kts
grep -Fq 'applicationId = "com.rtosta.wearfaces.templatesmoke"' "$module/build.gradle.kts"
grep -Fq '<string name="watch_face_name">Template Smoke</string>' "$module/src/main/res/values/strings.xml"
if grep -R '{{[A-Z_]*}}' "$module" "$spec"; then
  echo "Unexpanded template placeholder found" >&2
  exit 1
fi

./tools/validate.sh
if [[ ${WEARFACES_TEMPLATE_SKIP_BUILD:-0} == 1 ]]; then
  echo "WARNING: generated module build explicitly skipped" >&2
else
  ./gradlew ":faces:$slug:lint" ":faces:$slug:assembleDebug"
fi

echo "Watch face template generation and build passed."
