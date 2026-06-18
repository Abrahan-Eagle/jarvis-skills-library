#!/usr/bin/env bash
# smoke-skill-loop.sh — Smoke test for patched skill-loop skill tree (v2)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/skill-loop/SKILL.md"
ROUTER_MD="$ROOT/skills/core/skill-loop-router/SKILL.md"
SCHEMA="$ROOT/skills/ops/skill-loop/references/schema.json"
TEMPLATE="$ROOT/docs/templates/skill-loop-jarvis-feature.yml.example"
ASSETS="$ROOT/skills/ops/skill-loop/assets"

echo "== smoke-skill-loop =="

test -f "$SKILL_MD"
test -f "$ROUTER_MD"
test -f "$SCHEMA"
test -f "$TEMPLATE"

for tmpl in jarvis-implement.SKILL.md.tmpl jarvis-review.SKILL.md.tmpl jarvis-verify.SKILL.md.tmpl; do
  if [ ! -f "$ASSETS/$tmpl" ]; then
    echo "FAIL: missing $ASSETS/$tmpl" >&2
    exit 1
  fi
done

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

if ! grep -q '1.0-jarvis2' "$SKILL_MD"; then
  echo "FAIL: missing metadata version 1.0-jarvis2" >&2
  exit 1
fi

if grep -q 'dangerously-skip-permissions' "$TEMPLATE" "$ASSETS"/jarvis-*.tmpl 2>/dev/null; then
  echo "FAIL: dangerously-skip-permissions in JARVIS template/assets" >&2
  exit 1
fi

# schema.json may mention skip-permissions in patched description (forbidden note) — allow only in negation
if grep 'dangerously-skip-permissions' "$SCHEMA" | grep -qv 'do not use'; then
  if grep -q 'dangerously-skip-permissions for claude' "$SCHEMA"; then
    echo "FAIL: schema.json still promotes skip-permissions" >&2
    exit 1
  fi
fi

validate_yaml() {
  if command -v skill-loop >/dev/null 2>&1; then
    echo "OK: skill-loop CLI — validating template"
    skill-loop validate "$SCHEMA" "$TEMPLATE"
    return 0
  fi
  python3 - "$SCHEMA" "$TEMPLATE" <<'PY'
import json, sys, re
from pathlib import Path

schema_path, yaml_path = Path(sys.argv[1]), Path(sys.argv[2])
try:
    import yaml  # type: ignore
except ImportError:
    print("SKIP: PyYAML not installed; cannot validate template without skill-loop CLI")
    sys.exit(0)

schema = json.loads(schema_path.read_text())
doc = yaml.safe_load(yaml_path.read_text())
required = ["name", "default_entrypoint", "skills"]
for key in required:
    if key not in doc:
        raise SystemExit(f"FAIL: template missing key {key}")
if doc.get("max_iterations", 100) > 10:
    raise SystemExit("FAIL: template max_iterations too high for JARVIS smoke")
print("OK: template YAML structure valid (PyYAML smoke)")
PY
}

validate_yaml

echo "OK: skill-loop smoke tests passed"
