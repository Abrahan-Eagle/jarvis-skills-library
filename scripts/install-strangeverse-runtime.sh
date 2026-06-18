#!/usr/bin/env bash
# install-strangeverse-runtime.sh — Clone and prepare StrangeVerse for JARVIS.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STRANGEVERSE_HOME="${STRANGEVERSE_HOME:-/var/www/strangeverse}"
REPO_URL="https://github.com/Abrahan-Eagle/strangeverse.git"
SV_REF="${STRANGEVERSE_REF:-main}"

usage() {
  cat <<'EOF'
Usage: install-strangeverse-runtime.sh [options]

Install StrangeVerse runtime (API :5001, UI :3000).

Options:
  --docker-only   Use Docker Compose only
  --source-only   Use npm source mode only (setup:all + dev)
  -h, --help      Show help

Environment:
  STRANGEVERSE_HOME  Clone target (default: /var/www/strangeverse)
  STRANGEVERSE_REF   Git ref (default: main)

After install:
  npm run dev   (from STRANGEVERSE_HOME) — frontend :3000, backend :5001
  UI: http://127.0.0.1:3000
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

echo "== install-strangeverse-runtime =="
echo "HOME: $STRANGEVERSE_HOME"
echo "REF:  $SV_REF"
echo ""

if [ ! -d "$STRANGEVERSE_HOME/.git" ]; then
  git clone --depth 1 --branch "$SV_REF" "$REPO_URL" "$STRANGEVERSE_HOME" 2>/dev/null || \
    git clone --depth 1 "$REPO_URL" "$STRANGEVERSE_HOME"
  echo "Cloned strangeverse → $STRANGEVERSE_HOME"
else
  echo "Exists: $STRANGEVERSE_HOME"
fi

if [ ! -f "$STRANGEVERSE_HOME/.env" ] && [ -f "$STRANGEVERSE_HOME/.env.example" ]; then
  cp "$STRANGEVERSE_HOME/.env.example" "$STRANGEVERSE_HOME/.env"
  echo "Created .env from .env.example — configure LLM_API_KEY and ZEP_API_KEY"
fi

run_docker() {
  cd "$STRANGEVERSE_HOME"
  docker compose up -d
  echo ""
  echo "StrangeVerse (Docker) UI: http://127.0.0.1:3000"
  echo "API: http://127.0.0.1:5001"
}

run_source_setup() {
  cd "$STRANGEVERSE_HOME"
  if ! command -v node >/dev/null 2>&1; then
    echo "Node.js 18+ required" >&2
    exit 1
  fi
  if ! command -v uv >/dev/null 2>&1; then
    echo "uv (Python package manager) recommended — see README-ES.md" >&2
  fi
  npm run setup:all
  echo ""
  echo "Setup complete. Start with:"
  echo "  cd $STRANGEVERSE_HOME && npm run dev"
  echo "UI: http://127.0.0.1:3000  API: http://127.0.0.1:5001"
}

case "$MODE" in
  docker) run_docker;;
  source) run_source_setup;;
  auto)
    if docker compose version >/dev/null 2>&1 && [ -f "$STRANGEVERSE_HOME/docker-compose.yml" ]; then
      echo "docker compose found — use --docker-only to start containers"
      echo "Or source mode: npm run setup:all && npm run dev"
      run_source_setup
    else
      run_source_setup
    fi
    ;;
esac

code=$(curl -sS -o /dev/null -w "%{http_code}" http://127.0.0.1:5001/health 2>/dev/null || echo 000)
echo ""
echo "Health check: $code (200 = backend already running)"
echo "Test: strangeverse status  (bin en ~/.cursor/skills/strangeverse/bin/)"
echo "Doc:  $ROOT/docs/STRANGEVERSE_INTEGRATION.md"
