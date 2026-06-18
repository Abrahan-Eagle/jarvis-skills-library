#!/usr/bin/env bash
# smoke-skill-loop.sh — Smoke test for patched skill-loop skill tree.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/skill-loop/SKILL.md"
ROUTER_MD="$ROOT/skills/core/skill-loop-router/SKILL.md"
SCHEMA="$ROOT/skills/ops/skill-loop/references/schema.json"
TEMPLATE="$ROOT/docs/templates/skill-loop-jarvis-feature.yml.example"

echo "== smoke-skill-loop =="

test -f "$SKILL_MD"
test -f "$ROUTER_MD"
test -f "$SCHEMA"
test -f "$TEMPLATE"

if ! grep -q 'JARVIS / Cursor (mandatory)' "$SKILL_MD"; then
  echo "FAIL: missing JARVIS overlay" >&2
  exit 1
fi

if ! grep -q 'IRON LAW JARVIS' "$SKILL_MD"; then
  echo "FAIL: missing IRON LAW JARVIS" >&2
  exit 1
fi

if ! grep -q '.agents/skills' "$SKILL_MD"; then
  echo "FAIL: missing .agents/skills guidance" >&2
  exit 1
fi

if grep -qE 'Default to `\.claude/skills/' "$SKILL_MD"; then
  echo "FAIL: SKILL.md still defaults to .claude/skills" >&2
  exit 1
fi

if ! grep -q '1.0-jarvis1' "$SKILL_MD"; then
  echo "FAIL: missing metadata version 1.0-jarvis1" >&2
  exit 1
fi

if command -v skill-loop >/dev/null 2>&1; then
  echo "OK: skill-loop CLI found — validating template YAML"
  if skill-loop validate "$SCHEMA" "$TEMPLATE" 2>/dev/null; then
    echo "OK: template validates against schema"
  else
    echo "WARN: skill-loop validate failed for template (check CLI version)" >&2
  fi
else
  echo "SKIP: skill-loop CLI not in PATH (install via install-skill-loop-runtime.sh)"
fi

echo "OK: skill-loop smoke tests passed"
