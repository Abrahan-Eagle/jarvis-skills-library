#!/usr/bin/env bash
# sync-cyber-neo-skill.sh — Fetch cyber-neo skill tree (pinned ref) and patch SKILL.md for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CYBER_NEO_REF="${CYBER_NEO_REF:-9a8998a33534bca16c619f4956dd1935dc404620}"
REPO_URL="https://github.com/Hainrixz/cyber-neo.git"
SYNC_ROOT="$ROOT/.tmp-cyber-neo-sync"
DEST="$ROOT/skills/ops/cyber-neo"

echo "== sync-cyber-neo-skill =="
echo "REF: $CYBER_NEO_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone --depth 1 --branch main "$REPO_URL" "$SYNC_ROOT" 2>/dev/null || {
  git clone "$REPO_URL" "$SYNC_ROOT"
  git -C "$SYNC_ROOT" checkout "$CYBER_NEO_REF"
}

if [ -d "$SYNC_ROOT/.git" ]; then
  current=$(git -C "$SYNC_ROOT" rev-parse HEAD)
  if [ "$current" != "$CYBER_NEO_REF" ]; then
  git -C "$SYNC_ROOT" fetch --depth 1 origin "$CYBER_NEO_REF" 2>/dev/null || true
  git -C "$SYNC_ROOT" checkout "$CYBER_NEO_REF" 2>/dev/null || true
  fi
fi

if [ ! -d "$SYNC_ROOT/skills/cyber-neo" ]; then
  echo "ERROR: skills/cyber-neo not found in upstream" >&2
  exit 1
fi

rm -rf "$DEST"
mkdir -p "$DEST"
rsync -a --delete "$SYNC_ROOT/skills/cyber-neo/" "$DEST/"
echo "Synced → skills/ops/cyber-neo/"

export CYBER_NEO_HOME="$DEST"
python3 "$ROOT/scripts/patch-cyber-neo-skill.py"

rm -rf "$SYNC_ROOT"

echo ""
echo "Done. Run: bash scripts/validate-all.sh"
