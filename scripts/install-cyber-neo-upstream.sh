#!/usr/bin/env bash
# install-cyber-neo-upstream.sh — Clone upstream repo to ~/cyber-neo for diff/review (optional).
set -euo pipefail

CYBER_NEO_HOME="${CYBER_NEO_HOME:-$HOME/cyber-neo}"
CYBER_NEO_REF="${CYBER_NEO_REF:-9a8998a33534bca16c619f4956dd1935dc404620}"
REPO_URL="https://github.com/Hainrixz/cyber-neo.git"

if [ -d "$CYBER_NEO_HOME/.git" ]; then
  echo "Updating $CYBER_NEO_HOME"
  git -C "$CYBER_NEO_HOME" fetch origin
  git -C "$CYBER_NEO_HOME" checkout "$CYBER_NEO_REF" 2>/dev/null || git -C "$CYBER_NEO_HOME" pull
else
  git clone "$REPO_URL" "$CYBER_NEO_HOME"
  git -C "$CYBER_NEO_HOME" checkout "$CYBER_NEO_REF" 2>/dev/null || true
fi

echo "CYBER_NEO_HOME=$CYBER_NEO_HOME"
git -C "$CYBER_NEO_HOME" log -1 --oneline
