#!/bin/bash

# Lazygit Installation Script for Fedora
# This script installs lazygit from source

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "lazygit"

# Check if already installed
if check_already_installed "lazygit" "lazygit" "--version"; then
  exit 0
fi

# Check if Go is installed and available
if ! ensure_go_in_path; then
  exit 1
fi

# Create personal directory
create_personal_dir

# Install lazygit from source
print_status "Cloning lazygit repository..."
cd "$HOME/personal"
if [[ -d "lazygit" ]]; then
  print_status "Removing existing lazygit directory..."
  rm -rf lazygit
fi

git clone https://github.com/jesseduffield/lazygit.git
cd lazygit

print_status "Building and installing lazygit..."
go install

# Verify installation
if ! verify_installation "lazygit" "lazygit" "--version"; then
  print_error "Make sure $HOME/go/bin is in your PATH"
  exit 1
fi

print_status "lazygit installation script completed!"