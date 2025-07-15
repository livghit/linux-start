#!/bin/bash

# Beekeeper Studio Installation Script for Fedora
# This script installs Beekeeper Studio from source

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Beekeeper Studio"

# Check if already installed by looking for the built app
if [[ -f "$HOME/personal/beekeeper-studio/dist_electron/beekeeper-studio" ]]; then
  print_warning "Beekeeper Studio appears to be already built"
  print_warning "Skipping installation..."
  exit 0
fi

# Install build dependencies
print_status "Installing build dependencies..."
install_dependencies "nodejs npm git"

# Install Yarn globally if not present
if ! command_exists "yarn"; then
  print_status "Installing Yarn..."
  sudo npm install -g yarn
fi

# Create personal directory
create_personal_dir

# Clone Beekeeper Studio repository
print_status "Cloning Beekeeper Studio repository..."
cd "$HOME/personal"
if [[ -d "beekeeper-studio" ]]; then
  print_status "Removing existing beekeeper-studio directory..."
  rm -rf beekeeper-studio
fi

git clone https://github.com/beekeeper-studio/beekeeper-studio.git
cd beekeeper-studio

# Install dependencies
print_status "Installing project dependencies (this may take a while)..."
yarn install

# Build the application
print_status "Building Beekeeper Studio (this may take several minutes)..."
yarn run electron:build

# Create desktop entry
print_status "Creating desktop entry..."
DESKTOP_FILE="$HOME/.local/share/applications/beekeeper-studio.desktop"
mkdir -p "$HOME/.local/share/applications"

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Beekeeper Studio
Comment=Modern and easy to use SQL client
Exec=$HOME/personal/beekeeper-studio/dist_electron/beekeeper-studio
Icon=$HOME/personal/beekeeper-studio/build/icons/icon.png
Type=Application
Categories=Development;Database;
Terminal=false
StartupNotify=true
EOF

# Make desktop file executable
chmod +x "$DESKTOP_FILE"

# Create symlink for command line access
print_status "Creating command line symlink..."
sudo ln -sf "$HOME/personal/beekeeper-studio/dist_electron/beekeeper-studio" /usr/local/bin/beekeeper-studio

# Verify installation
if [[ -f "$HOME/personal/beekeeper-studio/dist_electron/beekeeper-studio" ]]; then
  print_status "Beekeeper Studio build completed successfully!"
  print_status "You can launch it from the applications menu or run 'beekeeper-studio' in terminal"
else
  print_error "Beekeeper Studio build failed!"
  exit 1
fi

print_status "Beekeeper Studio installation script completed!"
