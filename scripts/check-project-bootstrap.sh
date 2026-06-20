#!/usr/bin/env bash
# check-project-bootstrap.sh — Diagnose JARVIS onboarding state (machine + product repo).
# Run from product repo root (not jarvis-skills-library).
#
# Usage:
#   bash /path/to/jarvis-skills-library/scripts/check-project-bootstrap.sh
#   bash .../check-project-bootstrap.sh --min b   # require AGENTS.md + .agents/skills/
#   bash .../check-project-bootstrap.sh --min c   # require manifest + sync scripts
#
# Exit: 0 if checks pass for --min level; 1 otherwise.

set -euo pipefail

MIN_LEVEL="a"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --min)
      MIN_LEVEL="${2:-a}"
      shift 2
      ;;
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

fail=0
warn=0

echo "== JARVIS project bootstrap check =="
echo "cwd: $(pwd)"
echo "min_level: $MIN_LEVEL"
echo

# Capa 0 — machine
JC="${HOME}/.cursor/skills/jarvis-core"
GLOBAL_STATE="MISSING"
if [[ -L "$JC" ]]; then
  target="$(readlink -f "$JC" 2>/dev/null || true)"
  echo "GLOBAL_SYMLINK=$target"
  if [[ "$target" == *jarvis-skills-library* ]]; then
    GLOBAL_STATE="OK"
    echo "GLOBAL_STATE=OK"
  elif [[ "$target" == *jarvis-skills* ]]; then
    GLOBAL_STATE="LEGACY"
    echo "GLOBAL_STATE=LEGACY"
    echo "HINT: run install.sh --all; see docs/MIGRATION.md"
    fail=1
  else
    GLOBAL_STATE="UNKNOWN"
    echo "GLOBAL_STATE=UNKNOWN"
    warn=1
  fi
elif [[ -d "$JC" ]]; then
  echo "GLOBAL_DIR_NOT_SYMLINK=$JC"
  GLOBAL_STATE="NOT_SYMLINK"
  fail=1
else
  echo "GLOBAL_MISSING=jarvis-core"
  fail=1
fi

# Capa 1 — product repo
has_agents=0
has_local=0
has_manifest=0
has_sync=0
has_check=0

if [[ -f AGENTS.md ]]; then
  echo "HAS_AGENTS"
  has_agents=1
else
  echo "MISSING_AGENTS"
fi

if [[ -d .agents/skills ]]; then
  echo "HAS_LOCAL_SKILLS"
  has_local=1
  count="$(find .agents/skills -maxdepth 3 -name 'SKILL.md' 2>/dev/null | wc -l | tr -d ' ')"
  echo "LOCAL_SKILL_COUNT=$count"
else
  echo "MISSING_LOCAL_SKILLS"
fi

if [[ -f .agents/skills/.global-sync-manifest ]]; then
  echo "HAS_MANIFEST"
  has_manifest=1
else
  echo "NO_MANIFEST"
fi

[[ -f MAINTENANCE_SKILLS.md ]] && echo "HAS_MAINTENANCE" || echo "NO_MAINTENANCE"
[[ -f scripts/sync-global-skills-from-library.sh ]] && { echo "HAS_SYNC_SCRIPT"; has_sync=1; } || echo "NO_SYNC_SCRIPT"
[[ -f scripts/check-global-skills-sync.sh ]] && { echo "HAS_CHECK_SCRIPT"; has_check=1; } || echo "NO_CHECK_SCRIPT"

if [[ -d .cursor/skills ]]; then
  echo "WARN_REPO_GLOBAL_SKILLS=.cursor/skills"
  echo "HINT: do not version global skills in product repo; use ~/.cursor/skills/"
  warn=1
fi

lib="${JARVIS_SKILLS_LIBRARY:-/var/www/html/proyectos/AIPP/jarvis-skills-library}"
echo "JARVIS_SKILLS_LIBRARY=$lib"
if [[ -d "$lib/skills" ]]; then
  echo "LIBRARY_OK"
else
  echo "LIBRARY_MISSING"
  if [[ "$has_manifest" -eq 1 ]]; then
    warn=1
  fi
fi

# SDD markers
for d in .kittify openspec .specify .agents/plans specs; do
  if [[ -d "$d" ]]; then
    label="${d//\//_}"
    echo "HAS_${label}"
  fi
done

# Skill bootstrap (CorralX-style)
[[ -f .agents/skills/jarvis-core/OVERLAY.md ]] && echo "HAS_JARVIS_CORE_OVERLAY" || true
[[ -f .agents/skills/SKILL_INDEX.md ]] && echo "HAS_SKILL_INDEX" || true
[[ -f .cursor/hooks.json ]] && echo "HAS_CURSOR_HOOKS" || true

echo
echo "== Level checks =="

if [[ "$MIN_LEVEL" == "b" || "$MIN_LEVEL" == "c" ]]; then
  if [[ "$has_agents" -ne 1 || "$has_local" -ne 1 ]]; then
    echo "FAIL: --min $MIN_LEVEL requires AGENTS.md and .agents/skills/"
    fail=1
  else
    echo "PASS: Paso B (AGENTS.md + .agents/skills/)"
  fi
fi

if [[ "$MIN_LEVEL" == "c" ]]; then
  if [[ "$has_manifest" -ne 1 || "$has_sync" -ne 1 || "$has_check" -ne 1 ]]; then
    echo "FAIL: --min c requires manifest + sync + check scripts"
    fail=1
  else
    echo "PASS: Paso C (manifest + sync scripts)"
  fi
fi

if [[ "$fail" -eq 0 ]]; then
  echo "RESULT=OK"
  exit 0
fi

echo "RESULT=FAIL"
exit 1
