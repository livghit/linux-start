#!/bin/bash

# Neovim Installation Script for Fedora
# This script installs Neovim from source

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Neovim"

# Check if already installed
if check_already_installed "Neovim" "nvim" "--version"; then
  exit 0
fi

# Install dependencies
install_dependencies "ninja-build cmake gcc make gettext curl glibc-gconv-extra"

# Create personal directory
create_personal_dir

# Install Neovim from source
print_status "Cloning Neovim repository..."
cd "$HOME/personal"
if [[ -d "neovim" ]]; then
  print_status "Removing existing neovim directory..."
  rm -rf neovim
fi

git clone https://github.com/neovim/neovim
cd neovim
git checkout stable

print_status "Building Neovim..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

print_status "Installing Neovim..."
sudo make install

# Verify installation
verify_installation "Neovim" "nvim" "--version"

print_status "Neovim installation script completed!"