#!/bin/bash

# This script will setup all the configs from my github repository
# the configs are stored in https://github.com/livghit/{$application_name} - exp https://github.com/livghit/nvim / https://github.com/livghit/tmux and so on

# Source common functions
source "$(dirname "$0")/common.sh"

# Initialize the installer
init_installer "Configuration Setup"

# GitHub username
GITHUB_USER="livghit"

# Configuration repositories and their local paths
declare -A CONFIG_REPOS=(
  ["nvim"]="$HOME/.config/nvim-lazy"
  ["tmux"]="$HOME/.config/tmux"
  ["bash"]="$HOME/.config/bash"
  ["i3"]="$HOME/.config/i3"
  ["i3status"]="$HOME/.config/i3status"
  ["rofi"]="$HOME/.config/rofi"
  ["kitty"]="$HOME/.config/kitty"
)

# Function to backup existing config
backup_config() {
  local config_path="$1"
  local config_name="$2"

  if [[ -d "$config_path" ]]; then
    local backup_path="$config_path.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing $config_name configuration to $backup_path"
    mv "$config_path" "$backup_path"
  fi
}

# Function to clone or update config repository
setup_config() {
  local repo_name="$1"
  local config_path="$2"
  local repo_url="git@github.com:$GITHUB_USER/$repo_name.git"

  print_status "Setting up $repo_name configuration..."

  # Check if repository exists
  if ! wget --spider "$repo_url" 2>/dev/null; then
    print_warning "Repository $repo_url does not exist, skipping..."
    return 0
  fi

  # Create parent directory if it doesn't exist
  local parent_dir="$(dirname "$config_path")"
  if [[ ! -d "$parent_dir" ]]; then
    mkdir -p "$parent_dir"
  fi

  # Backup existing config if it exists
  backup_config "$config_path" "$repo_name"

  # Clone the repository
  print_status "Cloning $repo_name configuration..."
  if git clone "$repo_url" "$config_path"; then
    print_status "$repo_name configuration installed successfully!"
  else
    print_error "Failed to clone $repo_name configuration"
    return 1
  fi
}

# Function to setup dotfiles (files that go directly in HOME)
setup_dotfiles() {
  local dotfiles_repo="git@github.com:$GITHUB_USER/dotfiles.git"
  local temp_dir="/tmp/dotfiles_setup"

  print_status "Setting up dotfiles..."

  # Check if dotfiles repository exists
  if ! wget --spider "$dotfiles_repo" 2>/dev/null; then
    print_warning "Dotfiles repository $dotfiles_repo does not exist, skipping..."
    return 0
  fi

  # Clean up any existing temp directory
  if [[ -d "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi

  # Clone dotfiles to temp directory
  if git clone "$dotfiles_repo" "$temp_dir"; then
    print_status "Copying dotfiles to home directory..."

    # Copy dotfiles to home directory
    find "$temp_dir" -name ".*" -type f -exec cp {} "$HOME/" \;

    # Clean up temp directory
    rm -rf "$temp_dir"

    print_status "Dotfiles setup completed!"
  else
    print_warning "Failed to clone dotfiles repository"
  fi
}

# Main configuration setup function
main() {
  print_status "Starting configuration setup for development environment..."

  # Ensure git is installed
  if ! command_exists git; then
    print_status "Installing git..."
    install_dependencies git
  fi

  # Create .config directory if it doesn't exist
  if [[ ! -d "$HOME/.config" ]]; then
    mkdir -p "$HOME/.config"
  fi

  # Setup each configuration
  for repo_name in "${!CONFIG_REPOS[@]}"; do
    setup_config "$repo_name" "${CONFIG_REPOS[$repo_name]}"
  done

  # Setup dotfiles
  setup_dotfiles

  print_status "Configuration setup completed!"
  print_status "Note: You may need to restart your terminal or reload your shell configuration"
  print_status "to see the changes take effect."
}

# Run main function
main "$@"
