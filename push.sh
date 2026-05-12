#!/usr/bin/env bash
set -euo pipefail

# Create a new commit by incrementing the trailing number in the latest commit message,
# then push the main branch to origin.

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

latest_msg=$(git log -1 --pretty=%s)

if [[ "$latest_msg" =~ ^(.*?)-([0-9]+)$ ]]; then
  prefix="${BASH_REMATCH[1]}"
  number="${BASH_REMATCH[2]}"
  next_number=$((number + 1))
  new_msg="${prefix}-${next_number}"
else
  echo "Error: latest commit message does not end with a numeric suffix like 'try-0'." >&2
  echo "Latest message: $latest_msg" >&2
  exit 1
fi

# Stage all changes and create the new commit.
git add -A

after_status=$(git status --porcelain)
if [[ -z "$after_status" ]]; then
  echo "Error: no changes to commit." >&2
  exit 1
fi

git commit -m "$new_msg"
git push origin main
