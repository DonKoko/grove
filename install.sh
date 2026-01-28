#!/usr/bin/env bash
# Grove installer for Linux/macOS (manual)
# Usage: curl -fsSL https://raw.githubusercontent.com/donkoko/grove/main/install.sh | bash

set -e

REPO="donkoko/grove"
INSTALL_DIR="/usr/local"
SHARE_DIR="${INSTALL_DIR}/share/grove"
BIN_DIR="${INSTALL_DIR}/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}==>${NC} $1"; }
error() { echo -e "${RED}Error:${NC} $1"; exit 1; }

# Check for required tools
command -v git >/dev/null 2>&1 || error "git is required but not installed"
command -v curl >/dev/null 2>&1 || error "curl is required but not installed"

# Detect if we need sudo
SUDO=""
if [[ ! -w "$BIN_DIR" ]]; then
  SUDO="sudo"
  info "Root privileges required for installation to $INSTALL_DIR"
fi

info "Installing Grove..."

# Create temp directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Clone the repo
info "Downloading Grove..."
git clone --depth 1 "https://github.com/${REPO}.git" "$TMP_DIR/grove" 2>/dev/null

# Install binary
info "Installing gwt to ${BIN_DIR}..."
$SUDO mkdir -p "$BIN_DIR"
$SUDO cp "$TMP_DIR/grove/bin/gwt" "$BIN_DIR/gwt"
$SUDO chmod +x "$BIN_DIR/gwt"

# Install completions and integrations
info "Installing shell integrations..."
$SUDO mkdir -p "$SHARE_DIR/completions"
$SUDO mkdir -p "$SHARE_DIR/integrations"
$SUDO cp "$TMP_DIR/grove/completions/"* "$SHARE_DIR/completions/"
$SUDO cp "$TMP_DIR/grove/integrations/"* "$SHARE_DIR/integrations/"

# Detect shell and show integration instructions
SHELL_NAME=$(basename "$SHELL")

echo ""
success "Grove installed successfully!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To enable auto-cd into worktrees, run:"
echo ""

if [[ "$SHELL_NAME" == "zsh" ]]; then
  echo "  echo 'source /usr/local/share/grove/integrations/grove.zsh' >> ~/.zshrc && source ~/.zshrc"
elif [[ "$SHELL_NAME" == "bash" ]]; then
  echo "  echo 'source /usr/local/share/grove/integrations/grove.bash' >> ~/.bashrc && source ~/.bashrc"
else
  echo "  # For zsh:"
  echo "  echo 'source /usr/local/share/grove/integrations/grove.zsh' >> ~/.zshrc && source ~/.zshrc"
  echo ""
  echo "  # For bash:"
  echo "  echo 'source /usr/local/share/grove/integrations/grove.bash' >> ~/.bashrc && source ~/.bashrc"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Usage: gwt --help"
