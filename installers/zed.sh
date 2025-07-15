#!/bin/bash

# Zed Editor Installation Script for Fedora
# This script installs Zed editor using the official installer

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Zed"

# Check if Zed is already installed
if command_exists "zed"; then
  print_warning "Zed appears to be already installed"
  print_warning "Skipping installation..."
  exit 0
fi

# Install required dependencies
install_dependencies "curl"

# Download and run the official Zed installer
print_status "Downloading and running the official Zed installer..."
curl -f https://zed.dev/install.sh | sh

# Verify installation
if command_exists "zed"; then
  print_success "Zed installation completed successfully!"
  print_status "You can launch Zed by running 'zed' command or from the application menu"
  print_status "To edit a file: zed filename"
  print_status "To open current directory: zed ."
else
  print_error "Zed installation failed"
  exit 1
fi

print_status "Zed is a modern, fast code editor with built-in collaboration features"