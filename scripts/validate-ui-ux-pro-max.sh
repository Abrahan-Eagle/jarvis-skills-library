#!/usr/bin/env bash
# validate-ui-ux-pro-max.sh — Smoke test for ui-ux-pro-max scripts and data.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_ROOT="$ROOT/skills/ui/ui-ux-pro-max"
export UI_UX_SKILL_ROOT="$SKILL_ROOT"

echo "== validate-ui-ux-pro-max =="

test -f "$SKILL_ROOT/scripts/search.py"
test -f "$SKILL_ROOT/data/stacks/flutter.csv"
test -f "$SKILL_ROOT/data/google-fonts.csv"
test -f "$SKILL_ROOT/data/app-interface.csv"

python3 "$SKILL_ROOT/scripts/search.py" "healthcare pharmacy" \
  --design-system -p "Smoke" -f markdown | head -5

python3 "$SKILL_ROOT/scripts/search.py" "navigation" --stack flutter | head -3

python3 "$SKILL_ROOT/scripts/search.py" "sans serif" --domain google-fonts | head -3

echo "OK: ui-ux-pro-max smoke tests passed"
