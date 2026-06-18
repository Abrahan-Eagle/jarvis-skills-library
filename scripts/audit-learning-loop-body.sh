#!/usr/bin/env bash
# audit-learning-loop-body.sh — Report residual CLAUDE-centric counts (forense; does not fail)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_MD="$ROOT/skills/ops/learning-loop/SKILL.md"

echo "== audit-learning-loop-body =="
echo "SKILL: $SKILL_MD"
echo ""

count() {
  local label="$1"
  local pattern="$2"
  local n
  n=$(grep -cE "$pattern" "$SKILL_MD" 2>/dev/null || true)
  printf "  %-40s %s\n" "$label" "$n"
}

count "CLAUDE.md (literal)" 'CLAUDE\.md'
count "AGENTS.md / .cursorrules (patched)" 'AGENTS\.md'
count "Judgment Ledger (raw)" 'Judgment Ledger'
count "[JARVIS: no rutear]" '\[JARVIS: no rutear'
count "~/.claude/learning-captures" '~/.claude/learning-captures'
count "~/.claude/ (any)" '~/.claude/'
count "MEMORY.md" 'MEMORY\.md'
count "active_context.md" 'active_context\.md'
count "/ce:compound" '/ce:compound'
count "documentar-avances" 'documentar-avances'
count "IRON LAW JARVIS" 'IRON LAW JARVIS'
count "content_wedges" 'content_wedges'
count "PERSONAL_CONTEXT" 'PERSONAL_CONTEXT'

echo ""
echo "Run smoke: bash scripts/smoke-learning-loop.sh"
