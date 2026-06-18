#!/usr/bin/env bash
# validate-all.sh — Ejecuta validación shell + PyYAML en todas las skills.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "== validate-all: shell linter =="
bash "$ROOT/scripts/validate-skills.sh"

echo ""
echo "== validate-all: PyYAML =="
if ! python3 "$ROOT/scripts/validate-yaml.py"; then
  exit 1
fi

echo ""
echo "== validate-all: ui-ux-pro-max smoke =="
bash "$ROOT/scripts/validate-ui-ux-pro-max.sh"

echo ""
echo "== validate-all: cyber-neo smoke =="
bash "$ROOT/scripts/smoke-cyber-neo.sh"
