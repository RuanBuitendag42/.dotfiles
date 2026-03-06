#!/usr/bin/env bash
set -euo pipefail

TFENV_DIR="$HOME/.tfenv"
BIN_DIR="$HOME/.local/bin"

if [ -L "$BIN_DIR/tfenv" ]; then
  rm -f "$BIN_DIR/tfenv"
  echo "Removed symlink $BIN_DIR/tfenv"
fi

if [ -d "$TFENV_DIR" ]; then
  rm -rf "$TFENV_DIR"
  echo "Removed $TFENV_DIR"
else
  echo "No $TFENV_DIR found"
fi
