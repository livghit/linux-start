#!/bin/bash

# =============================================================================
# Linux Development Environment Setup Script
# =============================================================================
#
# Description: Transforms a fresh Linux installation into a complete dev environment
# Supported OS: Fedora, Ubuntu, Debian-based distributions
# Total installation time: ~15-30 minutes depending on internet speed
#
# This script will install:
# - Neovim (built from source)
# - lazygit & lazydocker (Git/Docker terminal UIs)  
# - tmux (terminal multiplexer)
# - Docker CE (containerization platform)
# - Development IDEs and tools
#
# Prerequisites: sudo privileges, internet connection
# =============================================================================

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/installers/common.sh"

# Initialize the installer (checks OS, sets package manager vars)
init_installer "System Setup"

print_status "Starting system setup process..."

# Update the system
print_status "Updating system packages..."
eval "$UPDATE_CMD"

# Create a personal folder in the home directory if it doesn't exist
create_personal_dir

# Installing software from source in the personal folder
print_status "Installing development dependencies..."

# Define dependencies based on package manager
if [[ "$PACKAGE_MANAGER" == "dnf" ]]; then
  DEPS="ninja-build cmake gcc make gettext curl glibc-gconv-extra go"
elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
  DEPS="ninja-build cmake gcc make gettext curl libc-bin golang-go"
fi

install_dependencies $DEPS

# Ensure Go is in PATH after installation
print_status "Configuring Go environment..."
ensure_go_in_path

# Install Neovim
NEOVIM_SCRIPT="$SCRIPT_DIR/installers/neovim.sh"
if [[ -f "$NEOVIM_SCRIPT" ]]; then
  chmod +x "$NEOVIM_SCRIPT"
  "$NEOVIM_SCRIPT"
else
  print_error "neovim.sh not found at $NEOVIM_SCRIPT"
fi

# Install lazygit
LAZYGIT_SCRIPT="$SCRIPT_DIR/installers/lazygit.sh"
if [[ -f "$LAZYGIT_SCRIPT" ]]; then
  chmod +x "$LAZYGIT_SCRIPT"
  "$LAZYGIT_SCRIPT"
else
  print_error "lazygit.sh not found at $LAZYGIT_SCRIPT"
fi

# Install lazydocker
LAZYDOCKER_SCRIPT="$SCRIPT_DIR/installers/lazydocker.sh"
if [[ -f "$LAZYDOCKER_SCRIPT" ]]; then
  chmod +x "$LAZYDOCKER_SCRIPT"
  "$LAZYDOCKER_SCRIPT"
else
  print_error "lazydocker.sh not found at $LAZYDOCKER_SCRIPT"
fi

# Add Go binary path to PATH for bash
print_status "Configuring PATH for Go binaries..."
GO_PATH="$HOME/go/bin"
BASHRC="$HOME/.bashrc"

if ! grep -q "export PATH=\$PATH:$GO_PATH" "$BASHRC" 2>/dev/null; then
  echo "export PATH=\$PATH:$GO_PATH" >>"$BASHRC"
  print_status "Added Go binary path to $BASHRC"
  print_warning "Please restart your shell or run 'source ~/.bashrc' to use lazygit and lazydocker"
else
  print_status "Go binary path already configured in $BASHRC"
fi

# Install tmux
TMUX_SCRIPT="$SCRIPT_DIR/installers/tmux.sh"
if [[ -f "$TMUX_SCRIPT" ]]; then
  chmod +x "$TMUX_SCRIPT"
  "$TMUX_SCRIPT"
else
  print_error "tmux.sh not found at $TMUX_SCRIPT"
fi

# Install Docker
DOCKER_SCRIPT="$SCRIPT_DIR/installers/docker.sh"
if [[ -f "$DOCKER_SCRIPT" ]]; then
  chmod +x "$DOCKER_SCRIPT"
  "$DOCKER_SCRIPT"
else
  print_error "docker.sh not found at $DOCKER_SCRIPT"
fi

# Install PhpStorm
PHPSTORM_SCRIPT="$SCRIPT_DIR/installers/phpstorm.sh"
if [[ -f "$PHPSTORM_SCRIPT" ]]; then
  chmod +x "$PHPSTORM_SCRIPT"
  "$PHPSTORM_SCRIPT"
else
  print_error "phpstorm.sh not found at $PHPSTORM_SCRIPT"
fi

# Install Beekeeper Studio
BEEKEEPER_SCRIPT="$SCRIPT_DIR/installers/beekeeper.sh"
if [[ -f "$BEEKEEPER_SCRIPT" ]]; then
  chmod +x "$BEEKEEPER_SCRIPT"
  "$BEEKEEPER_SCRIPT"
else
  print_error "beekeeper.sh not found at $BEEKEEPER_SCRIPT"
fi

# Install Flameshot
FLAMESHOT_SCRIPT="$SCRIPT_DIR/installers/flameshot.sh"
if [[ -f "$FLAMESHOT_SCRIPT" ]]; then
  chmod +x "$FLAMESHOT_SCRIPT"
  "$FLAMESHOT_SCRIPT"
else
  print_error "flameshot.sh not found at $FLAMESHOT_SCRIPT"
fi

print_status "System setup completed successfully!"
print_status "Summary of installed tools:"
echo "  - Neovim: $(nvim --version 2>/dev/null | head -1 || echo 'Failed to install')"
echo "  - lazygit: $(lazygit --version 2>/dev/null || echo 'Failed to install')"
echo "  - lazydocker: $(lazydocker --version 2>/dev/null || echo 'Failed to install')"
echo "  - tmux: $(tmux -V 2>/dev/null || echo 'Failed to install')"
echo "  - Docker: $(docker --version 2>/dev/null || echo 'Failed to install')"
echo "  - PhpStorm: $(command -v phpstorm >/dev/null 2>&1 && echo 'Installed' || echo 'Failed to install')"
echo "  - Beekeeper Studio: $(command -v beekeeper-studio >/dev/null 2>&1 && echo 'Installed' || echo 'Failed to install')"
echo "  - Flameshot: $(flameshot --version 2>/dev/null || echo 'Failed to install')"
echo
print_warning "Remember to restart your shell or run 'source ~/.bashrc' (or appropriate shell config) to use Go binaries"
print_warning "Log out and log back in for Docker group changes to take effect"
