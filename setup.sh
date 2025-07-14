#!/bin/bash

# Script for setting up fedora fresh install with necessary packages and configurations

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status "Starting Fedora setup process..."

# Update the system
print_status "Updating system packages..."
sudo dnf update -y

# Create a personal folder in the home directory if it doesn't exist
if [ ! -d $HOME/personal ]; then
  mkdir -p $HOME/personal
fi

# Installing software from source in the personal folder
print_status "Installing development dependencies..."
sudo dnf -y install ninja-build cmake gcc make gettext curl glibc-gconv-extra go

# Ensure Go is in PATH after installation
print_status "Configuring Go environment..."
export PATH=$PATH:/usr/bin:/usr/local/bin
hash -r  # Refresh command hash table

# Verify Go installation
if ! command -v go &>/dev/null; then
  print_error "Go installation failed or not found in PATH"
  exit 1
fi
print_status "Go version: $(go version)"

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

print_status "Fedora setup completed successfully!"
print_status "Summary of installed tools:"
echo "  - Neovim: $(nvim --version 2>/dev/null | head -1 || echo 'Failed to install')"
echo "  - lazygit: $(lazygit --version 2>/dev/null || echo 'Failed to install')"
echo "  - lazydocker: $(lazydocker --version 2>/dev/null || echo 'Failed to install')"
echo "  - tmux: $(tmux -V 2>/dev/null || echo 'Failed to install')"
echo "  - Docker: $(docker --version 2>/dev/null || echo 'Failed to install')"
echo "  - PhpStorm: $(command -v phpstorm >/dev/null 2>&1 && echo 'Installed' || echo 'Failed to install')"
echo
print_warning "Remember to restart your shell or run 'source ~/.bashrc' (or appropriate shell config) to use Go binaries"
print_warning "Log out and log back in for Docker group changes to take effect"
