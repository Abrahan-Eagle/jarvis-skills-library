#!/usr/bin/env bash
# sync-ui-ux-pro-max.sh — Refresh ui-ux-pro-max from nextlevelbuilder/ui-ux-pro-max-skill (pinned tag).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UI_UX_TAG="${UI_UX_TAG:-v2.5.0}"
STACKS_TAG="${STACKS_TAG:-v2.3.0}"  # v2.5.0 only ships react-native stack CSV; JARVIS keeps full set
REPO="nextlevelbuilder/ui-ux-pro-max-skill"
BASE="https://raw.githubusercontent.com/${REPO}"
DEST="$ROOT/skills/ui/ui-ux-pro-max"

echo "== sync-ui-ux-pro-max =="
echo "Content tag: $UI_UX_TAG | Stacks tag: $STACKS_TAG"
echo "Target: $DEST"
echo ""

mkdir -p "$DEST/scripts" "$DEST/data/stacks"

# Scripts (v2.5.0)
for f in core.py design_system.py search.py; do
  curl -fsSL "${BASE}/${UI_UX_TAG}/src/ui-ux-pro-max/scripts/${f}" -o "$DEST/scripts/${f}"
  echo "Fetched scripts/${f}"
done

# Data CSVs (v2.5.0)
DATA_FILES=(
  _sync_all.py
  app-interface.csv
  charts.csv
  colors.csv
  design.csv
  draft.csv
  google-fonts.csv
  icons.csv
  landing.csv
  products.csv
  react-performance.csv
  styles.csv
  typography.csv
  ui-reasoning.csv
  ux-guidelines.csv
)

for f in "${DATA_FILES[@]}"; do
  curl -fsSL "${BASE}/${UI_UX_TAG}/src/ui-ux-pro-max/data/${f}" -o "$DEST/data/${f}"
  echo "Fetched data/${f}"
done

# Stack CSVs (v2.3.0 full set; react-native refreshed from v2.5.0)
STACK_FILES=(
  astro.csv flutter.csv html-tailwind.csv jetpack-compose.csv
  nextjs.csv nuxt-ui.csv nuxtjs.csv react.csv shadcn.csv
  svelte.csv swiftui.csv vue.csv
)

for f in "${STACK_FILES[@]}"; do
  curl -fsSL "${BASE}/${STACKS_TAG}/src/ui-ux-pro-max/data/stacks/${f}" -o "$DEST/data/stacks/${f}"
  echo "Fetched stacks/${f} (${STACKS_TAG})"
done

curl -fsSL "${BASE}/${UI_UX_TAG}/src/ui-ux-pro-max/data/stacks/react-native.csv" \
  -o "$DEST/data/stacks/react-native.csv"
echo "Fetched stacks/react-native.csv (${UI_UX_TAG})"

# SKILL.md body from upstream Claude skill package
curl -fsSL "${BASE}/${UI_UX_TAG}/.claude/skills/ui-ux-pro-max/SKILL.md" -o "$DEST/SKILL.upstream.md"
echo "Fetched SKILL.upstream.md"

# Remove deprecated file if present
rm -f "$DEST/data/web-interface.csv"

echo ""
python3 "$ROOT/scripts/patch-ui-ux-pro-max.py"

echo ""
echo "Done. Run: bash scripts/validate-all.sh && python3 scripts/sync-lock.py"
