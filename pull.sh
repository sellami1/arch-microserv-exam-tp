#!/usr/bin/env bash
set -euo pipefail

# Pull the main branch from origin.

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

git pull origin main

