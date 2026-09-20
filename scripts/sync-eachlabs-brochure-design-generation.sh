#!/usr/bin/env bash
# sync-eachlabs-brochure-design-generation.sh — Fetch brochure-design-generation (pinned SHA) from eachlabs/skills.
# Supply-chain: audits the upstream skill with skill-security-auditor --strict BEFORE copying anything.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"
# Upstream has no tags — pin by commit SHA (2026-04-21).
EACHLABS_SKILLS_REF="${EACHLABS_SKILLS_REF:-dbd25b764305f84e5b9df3e095d5e444e6ee94e5}"
REPO_URL="https://github.com/eachlabs/skills.git"
SYNC_ROOT="$ROOT/.tmp-eachlabs-skills-sync"
DEST="$ROOT/skills/non-code/brochure-design-generation"
UPSTREAM_SKILL="skills/brochure-design-generation"
AUDITOR_PY="$ROOT/skills/ops/skill-security-auditor/scripts/skill_security_auditor.py"

echo "== sync-eachlabs-brochure-design-generation =="
echo "REF: $EACHLABS_SKILLS_REF"
echo ""

rm -rf "$SYNC_ROOT"
git clone --no-checkout "$REPO_URL" "$SYNC_ROOT"
jarvis_git_checkout_pin "$SYNC_ROOT" "$EACHLABS_SKILLS_REF"

if [ ! -f "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md" ]; then
  echo "ERROR: $UPSTREAM_SKILL/SKILL.md not found in upstream" >&2
  rm -rf "$SYNC_ROOT"
  exit 1
fi

# Supply-chain gate: strict audit on upstream before copy.
if [ -f "$AUDITOR_PY" ]; then
  echo "== skill-security-auditor --strict (upstream) =="
  if ! python3 "$AUDITOR_PY" "$SYNC_ROOT/$UPSTREAM_SKILL/" --strict; then
    echo "ERROR: upstream skill did not PASS strict audit — aborting sync" >&2
    rm -rf "$SYNC_ROOT"
    exit 1
  fi
else
  echo "WARN: $AUDITOR_PY missing — skipping pre-copy audit (run sync-claude-skills-skill-security-auditor.sh first)" >&2
fi

if ! bash "$ROOT/scripts/validate-skills.sh" --check-net-exec "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md"; then
  echo "ERROR: upstream SKILL.md failed net-exec check — aborting sync" >&2
  rm -rf "$SYNC_ROOT"
  exit 1
fi

# Never vendor a literal API key.
if grep -qE 'X-API-Key: *[^$ ]' "$SYNC_ROOT/$UPSTREAM_SKILL/SKILL.md"; then
  echo "ERROR: upstream SKILL.md contains a literal X-API-Key value — aborting sync" >&2
  rm -rf "$SYNC_ROOT"
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

echo "Synced upstream → skills/non-code/brochure-design-generation/"

python3 "$ROOT/scripts/patch-eachlabs-brochure-design-generation.py"

rm -rf "$SYNC_ROOT"

echo ""
echo "Done. Run: bash scripts/smoke-eachlabs-brochure-design-generation.sh"
