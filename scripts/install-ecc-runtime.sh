#!/usr/bin/env bash
# install-ecc-runtime.sh — Clone ECC upstream and install into project .cursor/ (official install.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ECC_HOME="${ECC_HOME:-$HOME/ecc}"
REPO_URL="https://github.com/affaan-m/ecc.git"
ECC_REF="${ECC_REF:-v2.0.0}"
PROJECT_DIR=""
PROFILE="minimal"
LANGUAGES="php typescript"
WITH_HOOKS=false
DRY_RUN=false

usage() {
  cat <<'EOF'
Usage: install-ecc-runtime.sh [options]

Install ECC (Everything Claude Code) into a product repo via official install.sh.

Options:
  --project-dir PATH   Repo where .cursor/ is created (required unless --dry-run preview only)
  --profile NAME       minimal (default) | core
  --languages LIST     Space-separated language packs (default: php typescript)
  --with-hooks         Add hooks-runtime module (opt-in)
  --dry-run            Preview commands without applying install to project
  -h, --help           Show help

Environment:
  ECC_HOME             Clone target (default: $HOME/ecc)
  ECC_REF              Git ref (default: v2.0.0)

Examples:
  bash scripts/install-ecc-runtime.sh --project-dir /path/to/CorralX-Backend
  bash scripts/install-ecc-runtime.sh --project-dir ./my-repo --with-hooks --profile core
  bash scripts/install-ecc-runtime.sh --dry-run --project-dir ./my-repo
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-dir) PROJECT_DIR="$2"; shift 2;;
    --profile) PROFILE="$2"; shift 2;;
    --languages) LANGUAGES="$2"; shift 2;;
    --with-hooks) WITH_HOOKS=true; shift;;
    --dry-run) DRY_RUN=true; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown: $1" >&2; usage >&2; exit 1;;
  esac
done

if [ -z "$PROJECT_DIR" ] && [ "$DRY_RUN" = false ]; then
  echo "ERROR: --project-dir is required (path to product repo)" >&2
  usage >&2
  exit 1
fi

if [ -n "$PROJECT_DIR" ]; then
  PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
fi

echo "== install-ecc-runtime =="
echo "ECC_HOME:    $ECC_HOME"
echo "ECC_REF:     $ECC_REF"
echo "PROJECT:     ${PROJECT_DIR:-<none>}"
echo "PROFILE:     $PROFILE"
echo "LANGUAGES:   $LANGUAGES"
echo "WITH_HOOKS:  $WITH_HOOKS"
echo "DRY_RUN:     $DRY_RUN"
echo ""

clone_ecc() {
  if [ ! -d "$ECC_HOME/.git" ]; then
    git clone --depth 1 --branch "$ECC_REF" "$REPO_URL" "$ECC_HOME" 2>/dev/null || \
      git clone --depth 1 "$REPO_URL" "$ECC_HOME"
    echo "Cloned ECC → $ECC_HOME"
  else
    echo "Exists: $ECC_HOME"
  fi
}

install_deps() {
  cd "$ECC_HOME"
  if [ -f package-lock.json ]; then
    npm ci --no-audit --no-fund --loglevel=error
  else
    npm install --no-audit --no-fund --loglevel=error
  fi
}

build_install_cmd() {
  local cmd=("$ECC_HOME/install.sh" --profile "$PROFILE" --target cursor)
  # shellcheck disable=SC2206
  local langs=( $LANGUAGES )
  cmd+=("${langs[@]}")
  if [ "$WITH_HOOKS" = true ]; then
    cmd+=(--modules hooks-runtime)
  fi
  printf '%q ' "${cmd[@]}"
  echo
}

if [ "$DRY_RUN" = true ]; then
  echo "[dry-run] Would clone/update ECC at $ECC_HOME (ref $ECC_REF)"
  if [ -n "$PROJECT_DIR" ]; then
    echo "[dry-run] From $PROJECT_DIR would run:"
    build_install_cmd
    if command -v npx >/dev/null 2>&1; then
      echo "[dry-run] Optional: npx ecc-universal consult \"laravel security\" --target cursor"
    fi
  fi
  exit 0
fi

clone_ecc
install_deps

cd "$PROJECT_DIR"
echo "Installing ECC into $PROJECT_DIR/.cursor ..."
INSTALL_CMD=("$ECC_HOME/install.sh" --profile "$PROFILE" --target cursor)
# shellcheck disable=SC2206
LANG_ARR=( $LANGUAGES )
INSTALL_CMD+=("${LANG_ARR[@]}")
if [ "$WITH_HOOKS" = true ]; then
  INSTALL_CMD+=(--modules hooks-runtime)
fi

"${INSTALL_CMD[@]}"

if ! command -v ecc-universal >/dev/null 2>&1; then
  echo ""
  echo "Optional: npm install -g ecc-universal  (for ecc consult / doctor)"
fi

echo ""
echo "Done. Verify: ecc status (from project dir) or npx ecc-universal --version"
echo "Doc: $ROOT/docs/ECC_INTEGRATION.md"
