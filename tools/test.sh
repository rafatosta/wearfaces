#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

./tools/validate.sh
./tools/validate-commit.sh --self-test
./tools/check-changelog.sh
./gradlew check assembleDebug

memory_jar=${WFF_MEMORY_JAR:-/opt/wff-tools/memory-footprint.jar}
if [[ ! -f "$memory_jar" ]]; then
  echo "Official memory evaluator not found at $memory_jar." >&2
  echo "Use ./tools/dev.sh test or set WFF_MEMORY_JAR." >&2
  exit 1
fi

while IFS= read -r -d '' apk; do
  java -jar "$memory_jar" \
    --watch-face "$apk" \
    --schema-version 2 \
    --ambient-limit-mb 10 \
    --active-limit-mb 100 \
    --apply-v1-offload-limitations \
    --estimate-optimization
done < <(find faces -path '*/build/outputs/apk/debug/*.apk' -print0)

echo "Local test suite passed."
