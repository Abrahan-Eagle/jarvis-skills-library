#!/usr/bin/env bash
# smoke-eachlabs-brochure-design-generation.sh — Smoke test for patched brochure-design-generation + eachlabs-router
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DIR="$ROOT/skills/non-code/brochure-design-generation"
SKILL_MD="$SKILL_DIR/SKILL.md"
UPSTREAM_MD="$SKILL_DIR/SKILL.md.upstream"
ROUTER_MD="$ROOT/skills/ui/eachlabs-router/SKILL.md"
AUDITOR_PY="$ROOT/skills/ops/skill-security-auditor/scripts/skill_security_auditor.py"

echo "== smoke-eachlabs-brochure-design-generation =="

test -f "$SKILL_MD"
test -f "$UPSTREAM_MD"
test -f "$ROUTER_MD"
test -f "$SKILL_DIR/references/SSE-EVENTS.md"

for needle in 'JARVIS (mandatory)' 'IRON LAW JARVIS' 'eachlabs-router' '2.0-jarvis' 'eachlabs/skills' \
              'Tríptico informativo' 'Fallback sin' 'EACHLABS_API_KEY'; do
  if ! grep -q -- "$needle" "$SKILL_MD"; then
    echo "FAIL: missing '$needle' in $SKILL_MD" >&2
    exit 1
  fi
done

for needle in 'IRON LAW' 'brochure-design-generation' 'open-design-router' 'skill-security-auditor'; do
  if ! grep -q -- "$needle" "$ROUTER_MD"; then
    echo "FAIL: missing '$needle' in $ROUTER_MD" >&2
    exit 1
  fi
done

# No literal API key vendored (only $EACHLABS_API_KEY env reference allowed)
if grep -nE 'X-API-Key: *[^$ ]' "$SKILL_MD" "$UPSTREAM_MD"; then
  echo "FAIL: literal X-API-Key value found" >&2
  exit 1
fi

for f in "$SKILL_MD" "$ROUTER_MD"; do
  if ! bash "$ROOT/scripts/validate-skills.sh" --check-net-exec "$f" >/dev/null 2>&1; then
    echo "FAIL: net-exec check failed for $f" >&2
    exit 1
  fi
done

# Curated skill must PASS the security auditor (strict)
if [ -f "$AUDITOR_PY" ]; then
  if ! python3 "$AUDITOR_PY" "$SKILL_DIR/" --strict >/dev/null 2>&1; then
    echo "FAIL: skill-security-auditor --strict did not PASS on $SKILL_DIR" >&2
    exit 1
  fi
else
  echo "WARN: auditor missing at $AUDITOR_PY — skipped" >&2
fi

echo "OK: eachlabs brochure-design-generation smoke tests passed"
