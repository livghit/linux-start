#!/bin/bash

# Flameshot installation script for Fedora
# Installs Flameshot screenshot tool

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Flameshot"

# Check if already installed
if check_already_installed "flameshot" "flameshot" "--version"; then
  exit 0
fi

# Install flameshot
print_status "Installing Flameshot..."
$INSTALL_CMD flameshot

# Verify installation
if ! verify_installation "Flameshot" "flameshot" "--version"; then
  exit 1
fi

echo
print_status "Flameshot installed successfully!"
print_status "To take a screenshot, run: flameshot gui"
print_status "You can also set up keybindings in your desktop environment"
