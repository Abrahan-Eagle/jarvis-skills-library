#!/usr/bin/env bash
# smoke-learning-loop.sh — Smoke test for patched learning-loop SKILL.md (v2)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/learning-loop/SKILL.md"
ROUTER_MD="$ROOT/skills/core/learning-loop-router/SKILL.md"
SESSION_LOG="$ROOT/skills/ops/learning-loop/references/SESSION_LOG.upstream.md"

echo "== smoke-learning-loop =="

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

# Judgment Ledger: only allowed with JARVIS marker (overlay or patched body)
ledger_count=$(grep -c 'Judgment Ledger' "$SKILL_MD" || true)
jarvis_ledger=$(grep -c '\[JARVIS: no rutear' "$SKILL_MD" || true)
if [[ "$ledger_count" -gt 0 ]] && [[ "$jarvis_ledger" -lt "$ledger_count" ]]; then
  echo "FAIL: Judgment Ledger without JARVIS no-rutear marker ($ledger_count vs $jarvis_ledger)" >&2
  exit 1
fi

# /ce:compound must not appear (replaced by documentar-avances + walkthrough)
if grep -q '/ce:compound' "$SKILL_MD"; then
  echo "FAIL: SKILL.md still contains /ce:compound" >&2
  exit 1
fi

# Version marker for patch v2
if ! grep -q '4.1-jarvis2' "$SKILL_MD"; then
  echo "FAIL: missing metadata version 4.1-jarvis2" >&2
  exit 1
fi

# SESSION_LOG upstream may still mention claude paths — that's OK
if [[ -f "$SESSION_LOG" ]]; then
  echo "OK: SESSION_LOG.upstream.md present (excluded from body checks)"
fi

echo "OK: learning-loop smoke tests passed"
