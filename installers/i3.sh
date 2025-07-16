#!/bin/bash

# i3 window manager installer
# This script installs i3 window manager and essential tools

# Source common functions
source "$(dirname "$0")/common.sh"

install_i3() {
  init_installer "i3 window manager"
  
  if check_already_installed "i3" "i3" "--version"; then
    return 0
  fi
  
  print_status "Installing i3 window manager and essential tools..."
  
  # Core i3 packages
  local core_packages="i3 i3lock i3blocks dmenu"
  
  # Additional utilities
  local utilities="feh picom dunst arandr lxappearance nitrogen"
  
  # Install packages based on distribution
  case "$PACKAGE_MANAGER" in
    dnf)
      install_dependencies $core_packages $utilities
      ;;
    apt)
      install_dependencies $core_packages $utilities
      ;;
  esac
  
  # Create i3 config directory
  mkdir -p "$HOME/.config/i3"
  
  # Generate default i3 config if it doesn't exist
  if [[ ! -f "$HOME/.config/i3/config" ]]; then
    print_status "Generating default i3 configuration..."
    i3-config-wizard || print_warning "i3-config-wizard failed, you may need to run it manually"
  fi
  
  verify_installation "i3" "i3" "--version"
}

# Run the installer
install_i3