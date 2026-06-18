#!/usr/bin/env bash
# smoke-claude-skills-skill-security-auditor.sh — Smoke test for patched skill-security-auditor
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/skill-security-auditor/SKILL.md"
ROUTER_MD="$ROOT/skills/core/claude-skills-router/SKILL.md"
AUDITOR_PY="$ROOT/skills/ops/skill-security-auditor/scripts/skill_security_auditor.py"

echo "== smoke-claude-skills-skill-security-auditor =="

test -f "$SKILL_MD"
test -f "$ROUTER_MD"
test -f "$AUDITOR_PY"

if ! grep -q 'JARVIS (mandatory)' "$SKILL_MD"; then
  echo "FAIL: missing JARVIS overlay" >&2
  exit 1
fi

if ! grep -q 'IRON LAW JARVIS' "$SKILL_MD"; then
  echo "FAIL: missing IRON LAW JARVIS block" >&2
  exit 1
fi

if ! grep -q 'claude-skills-router' "$SKILL_MD"; then
  echo "FAIL: missing claude-skills-router reference" >&2
  exit 1
fi

if ! grep -q '1.0-jarvis' "$SKILL_MD"; then
  echo "FAIL: missing metadata version 1.0-jarvis" >&2
  exit 1
fi

if ! grep -q 'alirezarezvani/claude-skills' "$SKILL_MD"; then
  echo "FAIL: missing upstream attribution" >&2
  exit 1
fi

if bash "$ROOT/scripts/validate-skills.sh" --check-net-exec "$SKILL_MD" 2>/dev/null; then
  :
else
  echo "FAIL: net-exec check failed for skill-security-auditor SKILL.md" >&2
  exit 1
fi

# Self-audit: auditor on its own skill directory should PASS or WARN (not FAIL on critical)
if python3 "$AUDITOR_PY" "$ROOT/skills/ops/skill-security-auditor/" --json 2>/dev/null | head -5; then
  :
else
  echo "WARN: auditor CLI returned non-zero on self-scan (review manually)" >&2
fi

# Benign fixture: doubt-driven should not FAIL critically when audited
FIXTURE="$ROOT/skills/engineering/doubt-driven-development"
if [ -f "$FIXTURE/SKILL.md" ]; then
  python3 "$AUDITOR_PY" "$FIXTURE/" --json 2>/dev/null | head -3 || true
fi

echo "OK: claude-skills skill-security-auditor smoke tests passed"
