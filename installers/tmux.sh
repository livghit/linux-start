#!/bin/bash

# Tmux Installation Script
# This script installs tmux on supported Linux distributions

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "tmux"

# Check if already installed
if check_already_installed "tmux" "tmux" "-V"; then
  exit 0
fi

# Install tmux
print_status "Installing tmux..."
$INSTALL_CMD tmux

# Verify installation
verify_installation "tmux" "tmux" "-V"

print_status "tmux installation script completed!"