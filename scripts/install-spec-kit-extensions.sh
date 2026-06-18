#!/usr/bin/env bash
# install-spec-kit-extensions.sh — Install MartyBonacci/spec-kit-extensions into a product repo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SPEC_KIT_EXT_REF="${SPEC_KIT_EXT_REF:-main}"
REPO_URL="https://github.com/MartyBonacci/spec-kit-extensions.git"
TMP_DIR="${TMPDIR:-/tmp}/spec-kit-extensions-install-$$"

usage() {
  cat <<'EOF'
Usage: install-spec-kit-extensions.sh --target PATH

Install spec-kit-extensions lifecycle workflows into a product repo with .specify/.

Options:
  --target PATH   Product repo root (must contain or will need .specify/)
  -h, --help      Show this help

Environment:
  SPEC_KIT_EXT_REF  Git ref to clone (default: main)

Example:
  bash scripts/install-spec-kit-extensions.sh --target ../ZonixPharma-Backend
EOF
}

TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "ERROR: --target PATH is required" >&2
  usage >&2
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

if [[ ! -d "$TARGET" ]]; then
  echo "ERROR: target directory does not exist: $TARGET" >&2
  exit 1
fi

if [[ ! -d "$TARGET/.specify" ]]; then
  echo "ERROR: $TARGET has no .specify/ — initialize Spec Kit first (specify init)" >&2
  exit 1
fi

echo "== install-spec-kit-extensions =="
echo "Ref:   $SPEC_KIT_EXT_REF"
echo "Target: $TARGET"
echo ""

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

git clone --depth 1 --branch "$SPEC_KIT_EXT_REF" "$REPO_URL" "$TMP_DIR" 2>/dev/null || \
  git clone --depth 1 "$REPO_URL" "$TMP_DIR"

# extensions → .specify/extensions/
mkdir -p "$TARGET/.specify/extensions"
if [[ -d "$TMP_DIR/extensions" ]]; then
  cp -r "$TMP_DIR/extensions/." "$TARGET/.specify/extensions/"
  echo "Copied extensions/ → .specify/extensions/"
else
  echo "WARN: no extensions/ in upstream" >&2
fi

# bash scripts
mkdir -p "$TARGET/.specify/scripts/bash"
if compgen -G "$TMP_DIR/scripts/create-*.sh" > /dev/null; then
  cp "$TMP_DIR/scripts"/create-*.sh "$TARGET/.specify/scripts/bash/"
  chmod +x "$TARGET/.specify/scripts/bash/create-"*.sh
  echo "Copied create-*.sh → .specify/scripts/bash/"
else
  echo "WARN: no create-*.sh scripts in upstream" >&2
fi

# Cursor commands
mkdir -p "$TARGET/.cursor/commands"
if compgen -G "$TMP_DIR/commands/*.md" > /dev/null; then
  cp "$TMP_DIR/commands/"*.md "$TARGET/.cursor/commands/"
  echo "Copied commands/*.md → .cursor/commands/"
else
  echo "WARN: no commands/*.md in upstream" >&2
fi

# Constitution append (manual review required)
CONSTITUTION="$TARGET/.specify/memory/constitution.md"
TEMPLATE="$TMP_DIR/docs/constitution-template.md"
if [[ -f "$TEMPLATE" ]]; then
  if [[ -f "$CONSTITUTION" ]]; then
    if grep -q "Section VI" "$CONSTITUTION" 2>/dev/null; then
      echo "SKIP: constitution.md already mentions Section VI — merge manually if needed"
    else
      {
        echo ""
        echo "---"
        echo "# Appended from spec-kit-extensions ($SPEC_KIT_EXT_REF) — review and dedupe"
        cat "$TEMPLATE"
      } >> "$CONSTITUTION"
      echo "Appended constitution-template.md → .specify/memory/constitution.md (REVIEW MANUALLY)"
    fi
  else
    mkdir -p "$(dirname "$CONSTITUTION")"
    cp "$TEMPLATE" "$CONSTITUTION"
    echo "Created .specify/memory/constitution.md from template"
  fi
fi

# Verify
if [[ -d "$TARGET/.specify/extensions/workflows" ]]; then
  echo ""
  echo "OK: .specify/extensions/workflows/ present"
  ls "$TARGET/.specify/extensions/workflows/"
else
  echo "FAIL: .specify/extensions/workflows/ missing after install" >&2
  exit 1
fi

echo ""
echo "Done. Reload Cursor; test /speckit.bugfix or:"
echo "  cd $TARGET && .specify/scripts/bash/create-bugfix.sh --help"
echo "JARVIS skill: speckit-lifecycle-router (global)"
