#!/usr/bin/env bash
# install-skill-loop-runtime.sh — Install skill-loop Go CLI (pinned) and verify tmux.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_LOOP_REF="${SKILL_LOOP_REF:-0bea8b08e079c71bc857631e26ada06068e82321}"
MODULE="github.com/takumiyoshikawa/skill-loop/cmd/skill-loop@${SKILL_LOOP_REF}"

echo "== install-skill-loop-runtime =="
echo "Module: $MODULE"
echo ""

if ! command -v go >/dev/null 2>&1; then
  echo "ERROR: go not found. Install Go or use: brew install takumiyoshikawa/tap/skill-loop" >&2
  exit 1
fi

if ! command -v tmux >/dev/null 2>&1; then
  echo "WARN: tmux not found — skill-loop requires tmux for execution" >&2
fi

go install "$MODULE"

if command -v skill-loop >/dev/null 2>&1; then
  echo "Installed: $(command -v skill-loop)"
  skill-loop --help 2>&1 | head -3 || true
else
  gopath_bin="$(go env GOPATH)/bin"
  echo "Binary likely at: ${gopath_bin}/skill-loop"
  echo "Ensure GOPATH/bin is in PATH"
fi

echo ""
echo "Optional: brew install takumiyoshikawa/tap/skill-loop"
echo "Template: docs/templates/skill-loop-jarvis-feature.yml.example"
