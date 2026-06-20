#!/usr/bin/env bash
# install-stitch-skills.sh — Install Google Stitch agent skills via upstream npx CLI.
# Does NOT vendor skills into jarvis-skills-library.
set -euo pipefail

REPO="google-labs-code/stitch-skills"
SCOPE_FLAG="--global"

# CLI names from: npx skills add google-labs-code/stitch-skills --list
DESIGN_SKILLS=(
  "stitch::generate-design"
  "stitch::extract-design-md"
  "stitch::extract-static-html"
  "stitch::code-to-design"
  "stitch::manage-design-system"
  "stitch::upload-to-stitch"
)
BUILD_SKILLS=(
  "react:components"
  "stitch::react-native"
  "remotion"
  "shadcn-ui"
)
UTILITIES_SKILLS=(
  "design-md"
  "enhance-prompt"
  "stitch-loop"
  "taste-design"
)

usage() {
  cat <<'EOF'
Usage: install-stitch-skills.sh [options]

Install Stitch skills from google-labs-code/stitch-skills (requires Node 18+, npx).
Destination: ~/.cursor/skills/ with --global (or .agents/skills/ in workspace with --local).

Options:
  --list              List available upstream skills
  --skill NAME        Install one skill (e.g. stitch::generate-design, react:components)
  --profile NAME      Install profile bundle: design | build | utilities | all
  --global            Install globally (default)
  --local             Install in current workspace only (omit --global)
  -h, --help          Show help

Profiles:
  design     stitch::generate-design, stitch::extract-design-md, stitch::extract-static-html,
             stitch::code-to-design, stitch::manage-design-system, stitch::upload-to-stitch
  build      react:components, stitch::react-native, remotion, shadcn-ui
  utilities  design-md, enhance-prompt, stitch-loop, taste-design
  all        All profiles above

Optional (install individually with --skill):
  stitch::react-native, taste-design

Examples:
  bash scripts/install-stitch-skills.sh --list
  bash scripts/install-stitch-skills.sh --profile design --global
  bash scripts/install-stitch-skills.sh --skill "stitch::generate-design" --local
  bash scripts/install-stitch-skills.sh --skill stitch-loop --global

Prerequisite: Stitch MCP Server — see docs/STITCH_UPSTREAM.md
EOF
}

install_skill() {
  local name="$1"
  echo "== install: $name =="
  if [[ "$SCOPE_FLAG" == "--global" ]]; then
    npx skills add "$REPO" --skill "$name" --global
  else
    npx skills add "$REPO" --skill "$name"
  fi
}

PROFILE=""
SKILL=""
LIST=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list) LIST=true; shift;;
    --skill) SKILL="${2:-}"; shift 2;;
    --profile) PROFILE="${2:-}"; shift 2;;
    --global) SCOPE_FLAG="--global"; shift;;
    --local) SCOPE_FLAG=""; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown: $1" >&2; usage >&2; exit 1;;
  esac
done

if [[ "$LIST" == true ]]; then
  npx skills add "$REPO" --list
  exit 0
fi

if [[ -n "$SKILL" ]]; then
  install_skill "$SKILL"
  echo "Done: $SKILL"
  exit 0
fi

case "$PROFILE" in
  design)
    for s in "${DESIGN_SKILLS[@]}"; do
      install_skill "$s"
    done
    ;;
  build)
    for s in "${BUILD_SKILLS[@]}"; do
      install_skill "$s"
    done
    ;;
  utilities)
    for s in "${UTILITIES_SKILLS[@]}"; do
      install_skill "$s"
    done
    ;;
  all)
    for s in "${DESIGN_SKILLS[@]}" "${BUILD_SKILLS[@]}" "${UTILITIES_SKILLS[@]}"; do
      install_skill "$s"
    done
    ;;
  "")
    echo "Specify --list, --skill NAME, or --profile design|build|utilities|all" >&2
    usage >&2
    exit 1
    ;;
  *)
    echo "Unknown profile: $PROFILE" >&2
    exit 1
    ;;
esac

echo "Done: Stitch skills profile '$PROFILE'"
