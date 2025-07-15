#!/bin/bash

# Lazydocker Installation Script for Fedora
# This script installs lazydocker from source

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "lazydocker"

# Check if already installed
if check_already_installed "lazydocker" "lazydocker" "--version"; then
  exit 0
fi

# Check if Go is installed and available
if ! ensure_go_in_path; then
  exit 1
fi

# Create personal directory
create_personal_dir

# Install lazydocker from source
print_status "Cloning lazydocker repository..."
cd "$HOME/personal"
if [[ -d "lazydocker" ]]; then
  print_status "Removing existing lazydocker directory..."
  rm -rf lazydocker
fi

git clone https://github.com/jesseduffield/lazydocker.git
cd lazydocker

print_status "Building and installing lazydocker..."
go install

# Verify installation
if ! verify_installation "lazydocker" "lazydocker" "--version"; then
  print_error "Make sure $HOME/go/bin is in your PATH"
  exit 1
fi

print_status "lazydocker installation script completed!"