#!/bin/bash

# Screenshot tools installation script for Fedora
# Installs grim and slurp (Wayland-native) for Hyprland compatibility

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Screenshot Tools"

# Check if already installed
if check_already_installed "grim" "grim" "--version" && check_already_installed "slurp" "slurp" "--version"; then
  exit 0
fi

# Update system packages
print_status "Updating system packages..."
sudo dnf update -y

# Install grim and slurp
print_status "Installing grim and slurp..."
sudo dnf install -y grim slurp

# Verify installation
if ! verify_installation "grim" "grim" "--version"; then
  exit 1
fi

if ! verify_installation "slurp" "slurp" "--version"; then
  exit 1
fi

echo
print_status "Screenshot tools installed successfully!"
print_status "To take a screenshot, run: grim -g \"\$(slurp)\" screenshot.png"
print_status "grim and slurp work natively with Hyprland and other Wayland compositors"
