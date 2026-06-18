#!/usr/bin/env bash
# sync-ecc-skills.sh — Fetch 3 curated ECC skills (pinned ref) and patch for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ECC_REF="${ECC_REF:-v2.0.0}"
BASE="https://raw.githubusercontent.com/affaan-m/ecc/${ECC_REF}"

CURATED=(
  continuous-learning-v2
  security-review
  configure-ecc
)

echo "== sync-ecc-skills =="
echo "REF: $ECC_REF"
echo ""

SYNC_ROOT="$ROOT/.tmp-ecc-sync"
rm -rf "$SYNC_ROOT"
mkdir -p "$SYNC_ROOT/skills"

for skill in "${CURATED[@]}"; do
  mkdir -p "$SYNC_ROOT/skills/$skill"
  curl -fsSL "${BASE}/skills/${skill}/SKILL.md" -o "$SYNC_ROOT/skills/$skill/SKILL.md"
  echo "Fetched skills/${skill}/SKILL.md"
done

export ECC_HOME="$SYNC_ROOT"
python3 "$ROOT/scripts/patch-ecc-skills.py"

rm -rf "$SYNC_ROOT"

echo ""
echo "Done. Run: bash scripts/validate-all.sh"
