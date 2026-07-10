#!/usr/bin/env bash
# install-skill-loop-upstream.sh — Clone skill-loop repo for local diff (optional).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"

SKILL_LOOP_UPSTREAM_HOME="${SKILL_LOOP_UPSTREAM_HOME:-${HOME}/skill-loop}"
SKILL_LOOP_REF="${SKILL_LOOP_REF:-0bea8b08e079c71bc857631e26ada06068e82321}"
REPO_URL="https://github.com/takumiyoshikawa/skill-loop.git"

echo "== install-skill-loop-upstream =="
echo "Target: $SKILL_LOOP_UPSTREAM_HOME"
echo "REF: $SKILL_LOOP_REF"

if [ -d "$SKILL_LOOP_UPSTREAM_HOME/.git" ]; then
  git -C "$SKILL_LOOP_UPSTREAM_HOME" fetch origin
else
  git clone "$REPO_URL" "$SKILL_LOOP_UPSTREAM_HOME"
fi
jarvis_git_checkout_pin "$SKILL_LOOP_UPSTREAM_HOME" "$SKILL_LOOP_REF"

echo "Done: $SKILL_LOOP_UPSTREAM_HOME"
