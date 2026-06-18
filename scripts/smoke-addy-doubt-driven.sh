#!/usr/bin/env bash
# smoke-addy-doubt-driven.sh — Smoke test for patched doubt-driven-development SKILL.md
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/engineering/doubt-driven-development/SKILL.md"
ROUTER_MD="$ROOT/skills/core/agent-skills-router/SKILL.md"

echo "== smoke-addy-doubt-driven =="

test -f "$SKILL_MD"
test -f "$ROUTER_MD"

if ! grep -q 'JARVIS / Cursor (mandatory)' "$SKILL_MD"; then
  echo "FAIL: missing JARVIS overlay" >&2
  exit 1
fi

if ! grep -q 'IRON LAW JARVIS' "$SKILL_MD"; then
  echo "FAIL: missing IRON LAW JARVIS block" >&2
  exit 1
fi

if ! grep -q 'agent-skills-router' "$SKILL_MD"; then
  echo "FAIL: missing agent-skills-router reference" >&2
  exit 1
fi

if ! grep -q 'code-reviewer' "$SKILL_MD"; then
  echo "FAIL: missing Cursor subagent mapping" >&2
  exit 1
fi

if ! grep -q '1.0-jarvis' "$SKILL_MD"; then
  echo "FAIL: missing metadata version 1.0-jarvis" >&2
  exit 1
fi

if ! grep -q 'addyosmani/agent-skills' "$SKILL_MD"; then
  echo "FAIL: missing upstream attribution" >&2
  exit 1
fi

# Supply-chain: no net-exec in SKILL body
if bash "$ROOT/scripts/validate-skills.sh" --check-net-exec "$SKILL_MD" 2>/dev/null; then
  :
else
  echo "FAIL: net-exec check failed for doubt-driven SKILL.md" >&2
  exit 1
fi

echo "OK: addy doubt-driven smoke tests passed"
