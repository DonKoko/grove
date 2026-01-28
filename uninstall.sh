#!/usr/bin/env bash
# Grove uninstaller
# Usage: curl -fsSL https://raw.githubusercontent.com/donkoko/grove/main/uninstall.sh | bash

set -e

INSTALL_DIR="/usr/local"
SHARE_DIR="${INSTALL_DIR}/share/grove"
BIN_DIR="${INSTALL_DIR}/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}==>${NC} $1"; }

# Detect if we need sudo
SUDO=""
if [[ ! -w "$BIN_DIR" ]]; then
  SUDO="sudo"
  info "Root privileges required for uninstallation"
fi

info "Uninstalling Grove..."

# Remove binary
if [[ -f "$BIN_DIR/gwt" ]]; then
  $SUDO rm "$BIN_DIR/gwt"
  info "Removed $BIN_DIR/gwt"
fi

# Remove share directory
if [[ -d "$SHARE_DIR" ]]; then
  $SUDO rm -rf "$SHARE_DIR"
  info "Removed $SHARE_DIR"
fi

echo ""
success "Grove uninstalled!"
echo ""
echo "Don't forget to remove the source line from your shell config:"
echo "  ~/.zshrc or ~/.bashrc"
