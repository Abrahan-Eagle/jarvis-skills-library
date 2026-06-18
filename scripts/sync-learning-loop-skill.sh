#!/usr/bin/env bash
# sync-learning-loop-skill.sh — Fetch learning-loop SKILL (pinned ref) and patch for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LEARNING_LOOP_REF="${LEARNING_LOOP_REF:-948dc75bc5a771a57366c651c5d442b44cba214d}"
REPO_URL="https://github.com/melodykoh/learning-loop-skill.git"
SYNC_ROOT="$ROOT/.tmp-learning-loop-sync"
DEST="$ROOT/skills/ops/learning-loop"

echo "== sync-learning-loop-skill =="
echo "REF: $LEARNING_LOOP_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone --depth 1 --branch main "$REPO_URL" "$SYNC_ROOT" 2>/dev/null || {
  git clone "$REPO_URL" "$SYNC_ROOT"
  git -C "$SYNC_ROOT" checkout "$LEARNING_LOOP_REF"
}

if [ -d "$SYNC_ROOT/.git" ]; then
  current=$(git -C "$SYNC_ROOT" rev-parse HEAD)
  if [ "$current" != "$LEARNING_LOOP_REF" ]; then
    git -C "$SYNC_ROOT" fetch --depth 1 origin "$LEARNING_LOOP_REF" 2>/dev/null || true
    git -C "$SYNC_ROOT" checkout "$LEARNING_LOOP_REF" 2>/dev/null || true
  fi
fi

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
