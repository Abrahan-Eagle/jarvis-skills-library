#!/usr/bin/env bash
# smoke-learning-loop.sh — Smoke test for patched learning-loop SKILL.md
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/learning-loop/SKILL.md"
ROUTER_MD="$ROOT/skills/core/learning-loop-router/SKILL.md"

echo "== smoke-learning-loop =="

test -f "$SKILL_MD"
test -f "$ROUTER_MD"

if ! grep -q 'JARVIS / Cursor (mandatory)' "$SKILL_MD"; then
  echo "FAIL: missing JARVIS overlay" >&2
  exit 1
fi

if grep -q '~/.claude/learning-captures' "$SKILL_MD"; then
  echo "FAIL: SKILL.md still contains ~/.claude/learning-captures" >&2
  exit 1
fi

if ! grep -q 'LEARNING_LOOP_HOME\|~/.cursor/learning-captures' "$SKILL_MD"; then
  echo "FAIL: missing LEARNING_LOOP_HOME / ~/.cursor/learning-captures" >&2
  exit 1
fi

if ! grep -q 'active_context' "$SKILL_MD"; then
  echo "FAIL: missing JARVIS destination active_context" >&2
  exit 1
fi

if ! grep -q 'walkthrough' "$SKILL_MD"; then
  echo "FAIL: missing JARVIS destination walkthrough" >&2
  exit 1
fi

if grep -qE '^allowed-tools:.*Skill' "$SKILL_MD"; then
  echo "FAIL: Skill tool still in allowed-tools" >&2
  exit 1
fi

echo "OK: learning-loop smoke tests passed"
