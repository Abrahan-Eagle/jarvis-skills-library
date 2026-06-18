#!/usr/bin/env bash
# install-open-design-runtime.sh — Clone and start Open Design runtime for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OPEN_DESIGN_HOME="${OPEN_DESIGN_HOME:-$HOME/open-design}"
REPO_URL="https://github.com/nexu-io/open-design.git"
OD_REF="${OPEN_DESIGN_REF:-main}"
NODE_BIN="${OD_NODE_BIN:-$HOME/.nvm/versions/node/v24.16.0/bin/node}"

usage() {
  cat <<'EOF'
Usage: install-open-design-runtime.sh [options]

Install Open Design runtime (daemon :17456, UI :7456).

Options:
  --docker-only   Use Docker Compose only (fail if compose missing)
  --source-only   Use pnpm source mode only
  -h, --help      Show help

Environment:
  OPEN_DESIGN_HOME  Clone target (default: $HOME/open-design)
  OPEN_DESIGN_REF   Git ref (default: main)
  OD_NODE_BIN       Node 24 binary for source mode

Alternatives (documented, not run by this script):
  curl -fsSL https://open-design.ai/install.sh | sh -s cursor
  od mcp install cursor   # after OD CLI available
EOF
}

MODE="auto"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --docker-only) MODE="docker"; shift;;
    --source-only) MODE="source"; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown: $1" >&2; usage >&2; exit 1;;
  esac
done

echo "== install-open-design-runtime =="
echo "HOME: $OPEN_DESIGN_HOME"
echo "REF:  $OD_REF"
echo ""

if [ ! -d "$OPEN_DESIGN_HOME/.git" ]; then
  git clone --depth 1 --branch "$OD_REF" "$REPO_URL" "$OPEN_DESIGN_HOME" 2>/dev/null || \
    git clone --depth 1 "$REPO_URL" "$OPEN_DESIGN_HOME"
  echo "Cloned open-design → $OPEN_DESIGN_HOME"
else
  echo "Exists: $OPEN_DESIGN_HOME"
fi

OD_DEPLOY="$OPEN_DESIGN_HOME/deploy"
if [ ! -f "$OD_DEPLOY/.env" ] && [ -f "$OD_DEPLOY/.env.example" ]; then
  cp "$OD_DEPLOY/.env.example" "$OD_DEPLOY/.env"
  if command -v openssl >/dev/null 2>&1; then
    TOKEN="$(openssl rand -hex 32)"
    if grep -q '^OD_API_TOKEN=' "$OD_DEPLOY/.env"; then
      sed -i "s/^OD_API_TOKEN=.*/OD_API_TOKEN=$TOKEN/" "$OD_DEPLOY/.env"
    else
      echo "OD_API_TOKEN=$TOKEN" >> "$OD_DEPLOY/.env"
    fi
    echo "Generated OD_API_TOKEN in $OD_DEPLOY/.env"
  fi
fi

run_docker() {
  cd "$OD_DEPLOY"
  docker compose pull
  docker compose up -d
  echo ""
  echo "Open Design (Docker) UI: http://127.0.0.1:7456"
  echo "Daemon: http://127.0.0.1:17456"
}

run_source() {
  export PATH="$(dirname "$NODE_BIN"):$PATH"
  if [ ! -x "$NODE_BIN" ]; then
    echo "Node 24 required at $NODE_BIN (nvm install 24)" >&2
    exit 1
  fi
  cd "$OPEN_DESIGN_HOME"
  corepack enable 2>/dev/null || true
  corepack prepare pnpm@10.33.2 --activate
  pnpm install
  corepack pnpm --filter @open-design/daemon rebuild better-sqlite3 --pending 2>/dev/null || true
  export OD_API_TOKEN=$(grep -E '^OD_API_TOKEN=' "$OD_DEPLOY/.env" | cut -d= -f2- || true)
  export OD_BIND_HOST=127.0.0.1
  echo "Starting source mode (daemon 17456, web 7456)..."
  pnpm tools-dev start web --daemon-port 17456 --web-port 7456
}

case "$MODE" in
  docker)
    run_docker
    ;;
  source)
    run_source
    ;;
  auto)
    if docker compose version >/dev/null 2>&1; then
      run_docker
    else
      echo "docker compose not found — source mode"
      run_source
    fi
    ;;
esac

echo ""
echo "Test: open-design status  (skill bin en ~/.cursor/skills/open-design/bin/)"
echo "MCP:  od mcp install cursor"
echo "Doc:  $ROOT/docs/OPEN_DESIGN_INTEGRATION.md"
