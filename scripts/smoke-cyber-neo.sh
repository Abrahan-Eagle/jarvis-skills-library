#!/usr/bin/env bash
# smoke-cyber-neo.sh — Smoke test for cyber-neo CLI and patched SKILL.md (fixture only).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$ROOT/skills/non-code/cyber-neo/bin/cyber-neo"
FIXTURE="$ROOT/scripts/fixtures/cyber-neo-fixture"
SKILL_MD="$ROOT/skills/ops/cyber-neo/SKILL.md"

echo "== smoke-cyber-neo =="

test -x "$BIN"
test -d "$FIXTURE"
test -f "$SKILL_MD"

"$BIN" status

"$BIN" secrets "$FIXTURE" 2>&1 | head -5 || true
"$BIN" lockfiles "$FIXTURE" 2>&1 | head -5 || true

if grep -q '\${CLAUDE_SKILL_DIR}' "$SKILL_MD"; then
  echo "FAIL: SKILL.md still contains \${CLAUDE_SKILL_DIR}" >&2
  exit 1
fi

if grep -q '\$ARGUMENTS' "$SKILL_MD"; then
  echo "FAIL: SKILL.md still contains \$ARGUMENTS" >&2
  exit 1
fi

if ! grep -q 'CYBER_NEO_SKILL_DIR' "$SKILL_MD"; then
  echo "FAIL: SKILL.md missing CYBER_NEO_SKILL_DIR guidance" >&2
  exit 1
fi

if ! grep -q 'composer audit' "$SKILL_MD"; then
  echo "FAIL: SKILL.md missing composer audit guidance" >&2
  exit 1
fi

if grep -E 'launch.*Agent tool|using the Agent tool' "$SKILL_MD"; then
  echo "FAIL: SKILL.md still references Agent tool for subagents" >&2
  exit 1
fi

echo "OK: cyber-neo smoke tests passed"
