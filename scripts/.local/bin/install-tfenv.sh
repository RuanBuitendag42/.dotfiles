#!/usr/bin/env bash
set -euo pipefail

TFENV_DIR="$HOME/.tfenv"
BIN_DIR="$HOME/.local/bin"

if [ -d "$TFENV_DIR/.git" ]; then
  echo "tfenv already installed at $TFENV_DIR"
  exit 0
fi

echo "Cloning tfenv into $TFENV_DIR..."
git clone https://github.com/tfutils/tfenv.git "$TFENV_DIR"

mkdir -p "$BIN_DIR"
ln -sf "$TFENV_DIR/bin/tfenv" "$BIN_DIR/tfenv"

echo "tfenv installed. Symlink created at $BIN_DIR/tfenv"

echo "Ensure $BIN_DIR is in your PATH (e.g., export PATH=\"$BIN_DIR:$PATH\")"
