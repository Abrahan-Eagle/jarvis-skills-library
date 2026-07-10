#!/usr/bin/env bash
# sync-claude-skills-skill-security-auditor.sh — Fetch skill-security-auditor (pinned ref) from alirezarezvani/claude-skills.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"
CLAUDE_SKILLS_REZVANI_REF="${CLAUDE_SKILLS_REZVANI_REF:-v2.9.0}"
REPO_URL="https://github.com/alirezarezvani/claude-skills.git"
SYNC_ROOT="$ROOT/.tmp-claude-skills-rezvani-sync"
DEST="$ROOT/skills/ops/skill-security-auditor"
UPSTREAM_SKILL="engineering/skills/skill-security-auditor"

echo "== sync-claude-skills-skill-security-auditor =="
echo "REF: $CLAUDE_SKILLS_REZVANI_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone "$REPO_URL" "$SYNC_ROOT"
jarvis_git_checkout_pin "$SYNC_ROOT" "$CLAUDE_SKILLS_REZVANI_REF"

if [ ! -f "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md" ]; then
  echo "ERROR: $UPSTREAM_SKILL/SKILL.md not found in upstream" >&2
  exit 1
fi

mkdir -p "$DEST"
rm -rf "$DEST/scripts" "$DEST/references"
cp "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md" "$DEST/SKILL.md.upstream"
if [ -d "$SYNC_ROOT/$UPSTREAM_SKILL/scripts" ]; then
  cp -r "$SYNC_ROOT/$UPSTREAM_SKILL/scripts" "$DEST/scripts"
fi
if [ -d "$SYNC_ROOT/$UPSTREAM_SKILL/references" ]; then
  cp -r "$SYNC_ROOT/$UPSTREAM_SKILL/references" "$DEST/references"
fi

echo "Synced upstream → skills/ops/skill-security-auditor/"

python3 "$ROOT/scripts/patch-claude-skills-skill-security-auditor.py"

rm -rf "$SYNC_ROOT"

echo ""
echo "Done. Run: bash scripts/smoke-claude-skills-skill-security-auditor.sh"
