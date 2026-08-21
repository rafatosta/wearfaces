#!/usr/bin/env bash
set -euo pipefail

grep -Fq '## [Unreleased]' CHANGELOG.md || { echo "CHANGELOG.md lacks [Unreleased]" >&2; exit 1; }

if [[ -z ${CHANGELOG_BASE:-} ]] || ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Changelog structure passed; no comparison base supplied."
  exit 0
fi

changed=$(git diff --name-only "$CHANGELOG_BASE"...HEAD)
[[ -n "$changed" ]] || exit 0
if grep -qx 'CHANGELOG.md' <<<"$changed"; then
  exit 0
fi
skip_reason=${CHANGELOG_SKIP_REASON:-}
if [[ -z "$skip_reason" && -n ${PR_BODY:-} ]]; then
  skip_reason=$(grep -E '^Changelog: not required - .+' <<<"$PR_BODY" | head -n1 || true)
fi
if [[ -n "$skip_reason" ]]; then
  echo "Changelog bypass documented: $skip_reason"
  exit 0
fi
if grep -Eq '^(faces/|tools/|gradle/|Containerfile$|build\.gradle|settings\.gradle|\.github/workflows/)' <<<"$changed"; then
  echo "Relevant changes require CHANGELOG.md or CHANGELOG_SKIP_REASON." >&2
  exit 1
fi
