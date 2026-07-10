#!/usr/bin/env bash
# sync-skill-loop-skill.sh — Fetch skill-loop skill tree (pinned ref) and patch for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"
SKILL_LOOP_REF="${SKILL_LOOP_REF:-0bea8b08e079c71bc857631e26ada06068e82321}"
REPO_URL="https://github.com/takumiyoshikawa/skill-loop.git"
SYNC_ROOT="$ROOT/.tmp-skill-loop-sync"
DEST="$ROOT/skills/ops/skill-loop"
UPSTREAM_SKILL="$SYNC_ROOT/skills/skill-loop"

echo "== sync-skill-loop-skill =="
echo "REF: $SKILL_LOOP_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone "$REPO_URL" "$SYNC_ROOT"
jarvis_git_checkout_pin "$SYNC_ROOT" "$SKILL_LOOP_REF"

if [ ! -d "$UPSTREAM_SKILL" ]; then
  echo "ERROR: upstream skills/skill-loop not found" >&2
  exit 1
fi

mkdir -p "$DEST"
JARVIS_BACKUP="$(mktemp -d)"
if [ -d "$DEST/assets" ]; then
  cp "$DEST/assets"/jarvis-*.tmpl "$JARVIS_BACKUP/" 2>/dev/null || true
  cp "$DEST/assets/skill-loop.jarvis.yml.tmpl" "$JARVIS_BACKUP/" 2>/dev/null || true
fi
rsync -a --delete "$UPSTREAM_SKILL/" "$DEST/"
mkdir -p "$DEST/references" "$DEST/assets"
cp "$JARVIS_BACKUP"/jarvis-*.tmpl "$DEST/assets/" 2>/dev/null || true
cp "$JARVIS_BACKUP/skill-loop.jarvis.yml.tmpl" "$DEST/assets/" 2>/dev/null || true
rm -rf "$JARVIS_BACKUP"
if [ -f "$SYNC_ROOT/schema.json" ]; then
  cp "$SYNC_ROOT/schema.json" "$DEST/references/schema.json"
fi
echo "Synced → skills/ops/skill-loop/"

export SKILL_LOOP_HOME="$DEST"
python3 "$ROOT/scripts/patch-skill-loop-skill.py"

rm -rf "$SYNC_ROOT"

echo ""
echo "Done. Run: bash scripts/smoke-skill-loop.sh"
