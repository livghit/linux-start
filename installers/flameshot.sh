#!/bin/bash

# Flameshot Installation Script for Fedora
# This script installs Flameshot screenshot tool from the official Fedora repository

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Flameshot"

# Check if already installed
if check_already_installed "Flameshot" "flameshot" "--version"; then
  exit 0
fi

# Update system packages
print_status "Updating system packages..."
sudo dnf update -y

# Install Flameshot
print_status "Installing Flameshot..."
sudo dnf install -y flameshot

# Verify installation
if ! verify_installation "Flameshot" "flameshot" "--version"; then
  exit 1
fi

echo
print_status "Flameshot can be launched from the applications menu or by running 'flameshot' in terminal"
print_status "To take a screenshot, run: flameshot gui"
print_status "To configure Flameshot, run: flameshot config"
print_status "Flameshot installation script completed!"
