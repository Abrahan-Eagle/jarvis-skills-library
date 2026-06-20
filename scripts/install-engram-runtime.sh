#!/usr/bin/env bash
# install-engram-runtime.sh — Install Engram binary and Cursor MCP integration.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: install-engram-runtime.sh [options]

Install Engram persistent memory (optional MCP for Cursor).

Options:
  --skip-setup    Only install binary, skip engram setup cursor
  -h, --help      Show help

Environment:
  ENGRAM_BIN      Override engram binary path after install

After install: Reload Cursor (Developer: Reload Window).
EOF
}

SKIP_SETUP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-setup) SKIP_SETUP=true; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown: $1" >&2; usage >&2; exit 1;;
  esac
done

echo "== install-engram-runtime =="
echo ""

install_engram() {
  if command -v engram >/dev/null 2>&1; then
    echo "OK: engram already in PATH ($(command -v engram))"
    engram version 2>/dev/null || true
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "Installing via Homebrew..."
    brew tap gentleman-programming/tap 2>/dev/null || true
    brew install gentleman-programming/tap/engram
    return 0
  fi

  echo "ERROR: engram not found and Homebrew unavailable." >&2
  echo "Install manually: https://github.com/Gentleman-Programming/engram/blob/main/docs/INSTALLATION.md" >&2
  exit 1
}

install_engram

if ! $SKIP_SETUP; then
  echo ""
  echo "== engram setup cursor =="
  engram setup cursor
  echo ""
  echo "Cursor MCP config updated. Reload Cursor to activate."
fi

echo ""
echo "Test: engram version"
engram version 2>/dev/null || true
echo ""
echo "Skills: engram-router, engram-memory-protocol"
echo "Doc:  $ROOT/docs/ENGRAM_INTEGRATION.md"
echo "Run:  bash $ROOT/scripts/install.sh   # symlink skills to ~/.cursor/skills"
