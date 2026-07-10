#!/usr/bin/env bash
# install-learning-loop-upstream.sh — Clone upstream to ~/learning-loop-skill for diff/review (optional).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"

LEARNING_LOOP_UPSTREAM_HOME="${LEARNING_LOOP_UPSTREAM_HOME:-$HOME/learning-loop-skill}"
LEARNING_LOOP_REF="${LEARNING_LOOP_REF:-948dc75bc5a771a57366c651c5d442b44cba214d}"
REPO_URL="https://github.com/melodykoh/learning-loop-skill.git"

if [ -d "$LEARNING_LOOP_UPSTREAM_HOME/.git" ]; then
  echo "Updating $LEARNING_LOOP_UPSTREAM_HOME"
  git -C "$LEARNING_LOOP_UPSTREAM_HOME" fetch origin
else
  git clone "$REPO_URL" "$LEARNING_LOOP_UPSTREAM_HOME"
fi
jarvis_git_checkout_pin "$LEARNING_LOOP_UPSTREAM_HOME" "$LEARNING_LOOP_REF"

echo "LEARNING_LOOP_UPSTREAM_HOME=$LEARNING_LOOP_UPSTREAM_HOME"
git -C "$LEARNING_LOOP_UPSTREAM_HOME" log -1 --oneline
