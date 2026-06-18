#!/usr/bin/env bash
# sync-addy-doubt-driven.sh — Fetch doubt-driven-development SKILL (pinned ref) from addyosmani/agent-skills.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADDY_AGENT_SKILLS_REF="${ADDY_AGENT_SKILLS_REF:-36c543d93b3f2bc0a3c01904c753121e56c105b1}"
REPO_URL="https://github.com/addyosmani/agent-skills.git"
SYNC_ROOT="$ROOT/.tmp-addy-agent-skills-sync"
DEST="$ROOT/skills/engineering/doubt-driven-development"
UPSTREAM_SKILL="skills/doubt-driven-development"

echo "== sync-addy-doubt-driven =="
echo "REF: $ADDY_AGENT_SKILLS_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone --depth 1 "$REPO_URL" "$SYNC_ROOT" 2>/dev/null || {
  git clone "$REPO_URL" "$SYNC_ROOT"
}

if [ -d "$SYNC_ROOT/.git" ]; then
  if [ "$ADDY_AGENT_SKILLS_REF" != "main" ]; then
    git -C "$SYNC_ROOT" fetch --depth 1 origin "$ADDY_AGENT_SKILLS_REF" 2>/dev/null || true
    git -C "$SYNC_ROOT" checkout "$ADDY_AGENT_SKILLS_REF" 2>/dev/null || true
  fi
  PINNED=$(git -C "$SYNC_ROOT" rev-parse HEAD)
  echo "Pinned commit: $PINNED"
fi

if [ ! -f "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md" ]; then
  echo "ERROR: $UPSTREAM_SKILL/SKILL.md not found in upstream" >&2
  exit 1
fi

mkdir -p "$DEST/references"
cp "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md" "$DEST/SKILL.md.upstream"
if [ -d "$SYNC_ROOT/$UPSTREAM_SKILL/references" ]; then
  cp -r "$SYNC_ROOT/$UPSTREAM_SKILL/references" "$DEST/references/upstream" 2>/dev/null || true
fi
if [ -f "$SYNC_ROOT/references/orchestration-patterns.md" ]; then
  cp "$SYNC_ROOT/references/orchestration-patterns.md" "$DEST/references/orchestration-patterns.upstream.md"
fi

echo "Synced upstream body → skills/engineering/doubt-driven-development/SKILL.md.upstream"
echo "Run: python3 scripts/patch-addy-doubt-driven.py"
