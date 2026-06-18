#!/usr/bin/env bash
# sync-spec-kit-skills.sh — Refresh speckit-* skills from github/spec-kit templates (pinned tag).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPEC_KIT_TAG="${SPEC_KIT_TAG:-v0.11.2}"
BASE_URL="https://raw.githubusercontent.com/github/spec-kit/${SPEC_KIT_TAG}/templates/commands"
SDD="$ROOT/skills/sdd"

COMMANDS=(
  constitution
  specify
  clarify
  plan
  tasks
  analyze
  implement
  checklist
  converge
  taskstoissues
)

echo "== sync-spec-kit-skills =="
echo "Tag: $SPEC_KIT_TAG"
echo "Target: $SDD"
echo ""

for cmd in "${COMMANDS[@]}"; do
  name="speckit-${cmd}"
  dest="$SDD/$name"
  tmp="$(mktemp)"
  url="${BASE_URL}/${cmd}.md"

  if ! curl -fsSL "$url" -o "$tmp"; then
    echo "FAIL: could not fetch $url" >&2
    rm -f "$tmp"
    exit 1
  fi

  mkdir -p "$dest"
  cp "$tmp" "$dest/SKILL.upstream.md"
  rm -f "$tmp"
  echo "Fetched $name"
done

echo ""
# Bootstrap new skills before merge
for cmd in "${COMMANDS[@]}"; do
  name="speckit-${cmd}"
  skill_md="$SDD/$name/SKILL.md"
  upstream="$SDD/$name/SKILL.upstream.md"
  if [[ -f "$upstream" && ! -f "$skill_md" ]]; then
    cp "$upstream" "$skill_md"
    echo "Bootstrapped $name from upstream"
  fi
done

# Merge upstream body (keeps existing JARVIS frontmatter if present)
for cmd in "${COMMANDS[@]}"; do
  name="speckit-${cmd}"
  skill_md="$SDD/$name/SKILL.md"
  upstream="$SDD/$name/SKILL.upstream.md"
  if [[ ! -f "$upstream" ]]; then
    continue
  fi
  python3 - "$skill_md" "$upstream" <<'PY'
import re, sys
from pathlib import Path
skill_md, upstream = Path(sys.argv[1]), Path(sys.argv[2])
up = upstream.read_text(encoding="utf-8")
m = re.match(r"^---\s*\n.*?\n---\s*\n", up, re.DOTALL)
body = up[m.end():].lstrip("\n") if m else up
if skill_md.exists():
    current = skill_md.read_text(encoding="utf-8")
    fm = re.match(r"^---\s*\n.*?\n---\s*\n", current, re.DOTALL)
    if fm:
        skill_md.write_text(current[:fm.end()] + body, encoding="utf-8")
    else:
        skill_md.write_text(body, encoding="utf-8")
else:
    skill_md.write_text(body, encoding="utf-8")
upstream.unlink()
PY
  echo "Merged body $name"
done

echo ""
echo "Running patch-speckit-frontmatter.py (frontmatter + H1 + JARVIS overlays)..."
python3 "$ROOT/scripts/patch-speckit-frontmatter.py"

echo ""
echo "Done. Run: bash scripts/validate-all.sh && python3 scripts/sync-lock.py"
