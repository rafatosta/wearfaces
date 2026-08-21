#!/usr/bin/env bash
set -euo pipefail

pattern='^(feat|fix|refactor|perf|test|docs|build|ci|chore|revert)(\([a-z0-9][a-z0-9._/-]*\))?!?: [^[:space:]].+$'

validate_subject() {
  local subject=$1
  [[ "$subject" =~ $pattern ]] || {
    echo "Invalid Conventional Commit subject: $subject" >&2
    return 1
  }
}

if [[ ${1:-} == --self-test ]]; then
  valid=('feat(aurora): add ambient color variants' 'ci: validate container build' 'docs(adb): clarify pairing ports')
  invalid=('update' 'fix stuff' 'changes' 'new files')
  for subject in "${valid[@]}"; do validate_subject "$subject"; done
  for subject in "${invalid[@]}"; do
    if validate_subject "$subject" 2>/dev/null; then
      echo "Self-test accepted invalid subject: $subject" >&2
      exit 1
    fi
  done
  echo "Conventional Commit validator self-test passed."
  exit 0
fi

if (($#)); then
  validate_subject "$*"
elif [[ -n ${COMMIT_RANGE:-} ]]; then
  while IFS= read -r subject; do validate_subject "$subject"; done < <(git log --format=%s "$COMMIT_RANGE")
else
  validate_subject "$(git log -1 --format=%s)"
fi
