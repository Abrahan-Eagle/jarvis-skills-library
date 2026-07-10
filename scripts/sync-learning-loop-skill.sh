#!/usr/bin/env bash
# sync-learning-loop-skill.sh — Fetch learning-loop SKILL (pinned ref) and patch for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"
LEARNING_LOOP_REF="${LEARNING_LOOP_REF:-948dc75bc5a771a57366c651c5d442b44cba214d}"
REPO_URL="https://github.com/melodykoh/learning-loop-skill.git"
SYNC_ROOT="$ROOT/.tmp-learning-loop-sync"
DEST="$ROOT/skills/ops/learning-loop"

echo "== sync-learning-loop-skill =="
echo "REF: $LEARNING_LOOP_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone "$REPO_URL" "$SYNC_ROOT"
jarvis_git_checkout_pin "$SYNC_ROOT" "$LEARNING_LOOP_REF"

if [ ! -f "$SYNC_ROOT/SKILL.md" ]; then
  echo "ERROR: SKILL.md not found in upstream" >&2
  exit 1
fi

mkdir -p "$DEST/references"
cp "$SYNC_ROOT/SKILL.md" "$DEST/SKILL.md"
if [ -f "$SYNC_ROOT/SESSION_LOG.md" ]; then
  cp "$SYNC_ROOT/SESSION_LOG.md" "$DEST/references/SESSION_LOG.upstream.md"
fi
echo "Synced → skills/ops/learning-loop/"

export LEARNING_LOOP_HOME="$DEST"
python3 "$ROOT/scripts/patch-learning-loop-skill.py"

rm -rf "$SYNC_ROOT"

echo ""
echo "Done. Run: bash scripts/smoke-learning-loop.sh"
