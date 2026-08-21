#!/usr/bin/env bash
set -euo pipefail

tag=${1:-}
[[ "$tag" =~ ^v([0-9]+\.[0-9]+\.[0-9]+)$ ]] || { echo "Expected SemVer tag vX.Y.Z" >&2; exit 1; }
version=${BASH_REMATCH[1]}
grep -Eq "^## \\[${version}\\] - [0-9]{4}-[0-9]{2}-[0-9]{2}$" CHANGELOG.md || {
  echo "CHANGELOG.md has no dated section for $version" >&2
  exit 1
}
while IFS= read -r build_file; do
  grep -Eq "versionName[[:space:]]*=[[:space:]]*\"${version}\"" "$build_file" || {
    echo "$build_file does not declare versionName $version" >&2
    exit 1
  }
done < <(find faces -mindepth 2 -maxdepth 2 -name build.gradle.kts | sort)
echo "Release metadata is coherent for $tag."
