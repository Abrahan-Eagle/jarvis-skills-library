#!/usr/bin/env bash
# install-notebooklm-runtime.sh — Install notebooklm-mcp-cli and Cursor MCP integration.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<'EOF'
Usage: install-notebooklm-runtime.sh [options]

Install NotebookLM CLI & MCP server (notebooklm-mcp-cli via uv tool).

Options:
  --skip-setup    Only install binary, skip Cursor MCP merge
  --skip-login    Skip nlm login guidance
  -h, --help      Show help

Environment:
  NLM_BIN  Override notebooklm-mcp binary path after install

After install: Reload Cursor (Developer: Reload Window) and run `nlm login` once.

Note: This script MERGES notebooklm-mcp into existing Cursor MCP config.
      It does NOT run `nlm setup add cursor` (that command overwrites other MCPs
      such as stitch). See docs/NOTEBOOKLM_INTEGRATION.md.
EOF
}

SKIP_SETUP=false
SKIP_LOGIN=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-setup) SKIP_SETUP=true; shift;;
    --skip-login) SKIP_LOGIN=true; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown: $1" >&2; usage >&2; exit 1;;
  esac
done

merge_notebooklm_into_cursor_mcp() {
  local nlm_bin="${NLM_BIN:-$(command -v notebooklm-mcp 2>/dev/null || true)}"
  if [[ -z "$nlm_bin" ]]; then
    echo "ERROR: notebooklm-mcp not found in PATH after install." >&2
    exit 1
  fi

  python3 - "$nlm_bin" <<'PY'
import json
import os
import sys
from pathlib import Path

nlm_bin = sys.argv[1]
entry = {"command": nlm_bin, "args": []}

paths = [
    Path.home() / ".config" / "cursor" / "mcp.json",
    Path.home() / ".cursor" / "mcp.json",
]

def load_cfg(path: Path) -> dict:
    if not path.is_file():
        return {"mcpServers": {}}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise SystemExit(f"ERROR: invalid JSON in {path}: {exc}") from exc
    if "mcpServers" not in data or not isinstance(data["mcpServers"], dict):
        data["mcpServers"] = {}
    return data

# Prefer XDG config; fall back to legacy; merge servers from both if present.
base = load_cfg(paths[0])
legacy = load_cfg(paths[1])
merged_servers = dict(legacy.get("mcpServers", {}))
merged_servers.update(base.get("mcpServers", {}))
merged_servers["notebooklm-mcp"] = entry
out = {"mcpServers": merged_servers}

for path in paths:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
    print(f"OK: merged notebooklm-mcp into {path} (preserved: {', '.join(sorted(k for k in merged_servers if k != 'notebooklm-mcp')) or 'none'})")
PY
}

echo "== install-notebooklm-runtime =="
echo ""

if ! command -v uv >/dev/null 2>&1; then
  echo "ERROR: uv not found. Install: curl -LsSf https://astral.sh/uv/install.sh | sh" >&2  # jarvis-allow-net-exec (docs only)
  exit 1
fi

if command -v nlm >/dev/null 2>&1; then
  echo "OK: nlm already in PATH ($(command -v nlm))"
  nlm --version 2>/dev/null || true
  echo "Upgrading..."
  uv tool upgrade notebooklm-mcp-cli 2>/dev/null || uv tool install notebooklm-mcp-cli
else
  echo "Installing via uv tool..."
  uv tool install notebooklm-mcp-cli
fi

if ! $SKIP_SETUP; then
  echo ""
  echo "== merge notebooklm-mcp into Cursor MCP (preserve stitch & others) =="
  merge_notebooklm_into_cursor_mcp
  echo ""
  echo "Cursor MCP config updated. Reload Cursor to activate."
  echo "WARN: Do not run 'nlm setup add cursor' — it overwrites other MCP servers."
fi

if ! $SKIP_LOGIN; then
  echo ""
  echo "== auth (one-time) =="
  if nlm login --check >/dev/null 2>&1; then
    echo "Auth OK."
  else
    echo "Run: nlm login   (use a secondary Google account)"
  fi
fi

echo ""
echo "Test: nlm doctor"
nlm doctor 2>/dev/null || true
echo ""
echo "Skills: notebooklm-router"
echo "Doc:   $ROOT/docs/NOTEBOOKLM_INTEGRATION.md"
echo "Run:   bash $ROOT/scripts/install.sh   # symlink skills to ~/.cursor/skills"
