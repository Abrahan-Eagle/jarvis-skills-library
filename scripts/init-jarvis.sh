#!/usr/bin/env bash
# init-jarvis.sh — Entry point: "init jarvis" in a product repo.
#
# Usage (from product repo root):
#   bash /path/to/jarvis-skills-library/scripts/init-jarvis.sh
#   bash .../init-jarvis.sh --min c
#
# In Cursor Agent chat, write: init jarvis
# → invokes skill project-bootstrap-ops (auto_invoke).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LIBRARY="$(cd "$SCRIPT_DIR/.." && pwd)"
MIN_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --min)
      MIN_ARGS=(--min "${2:-b}")
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

if [[ -d "$LIBRARY/skills/core/jarvis-core" && -f "$LIBRARY/AGENTS.md" ]]; then
  :
else
  echo "ERROR: jarvis-skills-library not found at $LIBRARY" >&2
  exit 1
fi

if [[ "$(basename "$LIBRARY")" == "jarvis-skills-library" && -f "$PWD/AGENTS.md" && "$PWD" != "$LIBRARY" ]]; then
  REPO_ROOT="$PWD"
elif [[ -f AGENTS.md || -d .agents/skills ]]; then
  REPO_ROOT="$PWD"
else
  echo "WARN: run from product repo root (where AGENTS.md or .agents/skills/ will be created)" >&2
  REPO_ROOT="$PWD"
fi

echo "== init jarvis =="
echo "product_repo: $REPO_ROOT"
echo "library:      $LIBRARY"
echo

bash "$LIBRARY/scripts/check-project-bootstrap.sh" "${MIN_ARGS[@]}"
rc=$?

echo
echo "== Next steps =="
if [[ $rc -ne 0 ]]; then
  echo "1. Fix failures above (see docs/PROJECT_ONBOARDING.md)"
  echo "2. Paso A (machine): cd $LIBRARY && bash scripts/install.sh --all"
  echo "3. In Cursor Agent chat: init jarvis  (skill project-bootstrap-ops)"
else
  echo "Bootstrap checks passed for requested level."
  echo "Continue with jarvis-core workflow or ask the agent to scaffold missing Paso B/C files."
fi

exit "$rc"
