#!/usr/bin/env bash
# install-cyber-neo-upstream.sh — Clone upstream repo to ~/cyber-neo for diff/review (optional).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=lib/git-pin.sh
source "$ROOT/scripts/lib/git-pin.sh"

CYBER_NEO_HOME="${CYBER_NEO_HOME:-$HOME/cyber-neo}"
CYBER_NEO_REF="${CYBER_NEO_REF:-9a8998a33534bca16c619f4956dd1935dc404620}"
REPO_URL="https://github.com/Hainrixz/cyber-neo.git"

if [ -d "$CYBER_NEO_HOME/.git" ]; then
  echo "Updating $CYBER_NEO_HOME"
  git -C "$CYBER_NEO_HOME" fetch origin
else
  git clone "$REPO_URL" "$CYBER_NEO_HOME"
fi
jarvis_git_checkout_pin "$CYBER_NEO_HOME" "$CYBER_NEO_REF"

echo "CYBER_NEO_HOME=$CYBER_NEO_HOME"
git -C "$CYBER_NEO_HOME" log -1 --oneline
