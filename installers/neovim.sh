#!/bin/bash

# =============================================================================
# Neovim Installation Script
# =============================================================================
#
# Description: Installs the latest stable Neovim from source
# Supported OS: Fedora, Ubuntu, Debian-based distributions
# Requirements: git, cmake, make, gcc, ninja-build, gettext, curl
# Installation time: ~5-10 minutes depending on system performance
#
# What this script does:
# 1. Checks if Neovim is already installed
# 2. Installs build dependencies for your OS
# 3. Clones Neovim stable branch from GitHub
# 4. Builds Neovim with optimized settings
# 5. Installs system-wide to /usr/local/bin/nvim
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Neovim"

# Check if already installed
if check_already_installed "Neovim" "nvim" "--version"; then
  exit 0
fi

# Validate required tools
validate_required_tools "git" "make" "cmake"

# Install dependencies based on OS
if [[ "$PACKAGE_MANAGER" == "dnf" ]]; then
  install_dependencies "ninja-build cmake gcc make gettext curl glibc-gconv-extra"
elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
  install_dependencies "ninja-build gettext cmake unzip curl"
fi

# Create personal directory
create_personal_dir

# Install Neovim from source
cd "$HOME/personal"

# Use safe git clone function
if ! safe_git_clone "https://github.com/neovim/neovim" "$HOME/personal/neovim" "stable"; then
  print_error "Failed to clone Neovim repository"
  exit 1
fi

cd neovim

print_status "Building Neovim (this may take several minutes)..."
if ! make CMAKE_BUILD_TYPE=RelWithDebInfo; then
  print_error "Failed to build Neovim"
  cleanup_on_failure "$HOME/personal/neovim"
  exit 1
fi

print_status "Installing Neovim..."
if ! sudo make install; then
  print_error "Failed to install Neovim"
  cleanup_on_failure "$HOME/personal/neovim"
  exit 1
fi

# Verify installation
verify_installation "Neovim" "nvim" "--version"

print_status "Neovim installation script completed!"

