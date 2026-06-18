#!/usr/bin/env bash
# smoke-kalman-anomaly.sh — Smoke test for kalman-anomaly-defense skill
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/kalman-anomaly-defense/SKILL.md"
ROUTER_MD="$ROOT/skills/core/kalman-anomaly-router/SKILL.md"
SCRIPT="$ROOT/skills/ops/kalman-anomaly-defense/scripts/kalman_1d_anomaly.py"
FIXTURE="$ROOT/skills/ops/kalman-anomaly-defense/scripts/fixtures/sample_traffic.csv"
TEMPLATE="$ROOT/skills/ops/kalman-anomaly-defense/assets/response-policy.template.yaml"

echo "== smoke-kalman-anomaly =="

test -f "$SKILL_MD"
test -f "$ROUTER_MD"
test -f "$SCRIPT"
test -f "$FIXTURE"
test -f "$TEMPLATE"

if ! grep -q 'IRON LAW JARVIS' "$SKILL_MD"; then
  echo "FAIL: missing IRON LAW in SKILL.md" >&2
  exit 1
fi

if ! grep -q 'kalman-anomaly-defense' "$ROUTER_MD"; then
  echo "FAIL: router missing kalman-anomaly-defense ref" >&2
  exit 1
fi

python3 "$SCRIPT" --help >/dev/null

OUT="$(python3 "$SCRIPT" --file "$FIXTURE" --threshold 3.0 2>/dev/null)"
if ! echo "$OUT" | grep -q ',YES$'; then
  echo "FAIL: expected at least one anomaly YES in fixture output" >&2
  echo "$OUT" | tail -5
  exit 1
fi

echo "OK: kalman-anomaly smoke tests passed"
