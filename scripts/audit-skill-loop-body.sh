#!/usr/bin/env bash
# audit-skill-loop-body.sh — Report residual counts for forense (does not fail)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DIR="$ROOT/skills/ops/skill-loop"

echo "== audit-skill-loop-body =="
echo "Tree: $SKILL_DIR"
echo ""

count_tree() {
  local label="$1"
  local pattern="$2"
  local n
  n=$(grep -rE "$pattern" "$SKILL_DIR" --include='*.md' --include='*.tmpl' --include='*.json' 2>/dev/null | wc -l || true)
  printf "  %-42s %s\n" "$label" "$n"
}

count_tree "cursor-cli" 'cursor-cli'
count_tree "codex runtime" 'runtime: codex'
count_tree "claude default text" 'defaults to claude'
count_tree "dangerously-skip-permissions" 'dangerously-skip-permissions'
count_tree ".claude/skills" '\.claude/skills'
count_tree ".agents/skills" '\.agents/skills'
count_tree "raw github schema URL" 'raw\.githubusercontent\.com/takumiyoshikawa/skill-loop'
count_tree "jarvis-implement tmpl" 'jarvis-implement'
count_tree "IRON LAW JARVIS" 'IRON LAW JARVIS'
count_tree "1.0-jarvis2" '1.0-jarvis2'

echo ""
echo "Run smoke: bash scripts/smoke-skill-loop.sh"
