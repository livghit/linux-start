#!/bin/bash

# PhpStorm Installation Script for Fedora
# This script installs PhpStorm IDE via JetBrains Toolbox or direct download

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "PhpStorm"

# Check if PhpStorm is already installed
if command_exists "phpstorm" || [[ -d "$HOME/.local/share/JetBrains/Toolbox/apps/PhpStorm" ]] || [[ -d "/opt/phpstorm" ]]; then
  print_warning "PhpStorm appears to be already installed"
  print_warning "Skipping installation..."
  exit 0
fi

# Install required dependencies
install_dependencies "curl wget tar jq"

# Get latest PhpStorm version information
print_status "Fetching latest PhpStorm version information..."
API_URL="https://data.services.jetbrains.com/products/releases?code=PS&latest=true"
VERSION_INFO=$(curl -s "$API_URL")

if [[ -z "$VERSION_INFO" ]]; then
  print_error "Failed to fetch PhpStorm version information"
  exit 1
fi

# Extract version and download URL
VERSION=$(echo "$VERSION_INFO" | jq -r '.PS[0].version')
DOWNLOAD_URL=$(echo "$VERSION_INFO" | jq -r '.PS[0].downloads.linux.link')

if [[ "$VERSION" == "null" ]] || [[ "$DOWNLOAD_URL" == "null" ]]; then
  print_error "Failed to parse PhpStorm version information"
  print_status "Falling back to direct download URL..."
  DOWNLOAD_URL="https://data.services.jetbrains.com/products/download?code=PS&platform=linux"
fi

print_status "Latest PhpStorm version: $VERSION"
print_status "Download URL: $DOWNLOAD_URL"

# Create installation directory
INSTALL_DIR="/opt/phpstorm"
print_status "Creating installation directory at $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"

# Download and extract PhpStorm
TEMP_FILE="/tmp/phpstorm.tar.gz"
download_file "$DOWNLOAD_URL" "$TEMP_FILE" "PhpStorm"
extract_tarball "$TEMP_FILE" "$INSTALL_DIR" "PhpStorm"
cleanup "$TEMP_FILE"

# Create symlink for easy access
create_symlink "$INSTALL_DIR/bin/phpstorm.sh" "/usr/local/bin/phpstorm" "phpstorm command symlink"

# Create desktop entry
print_status "Creating desktop entry..."
cat >/tmp/phpstorm.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=PhpStorm
Comment=Lightning-smart PHP IDE
Exec=/opt/phpstorm/bin/phpstorm.sh %f
Icon=/opt/phpstorm/bin/phpstorm.svg
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-phpstorm
StartupNotify=true
EOF

# Install desktop entry
sudo mv /tmp/phpstorm.desktop /usr/share/applications/
sudo chmod 644 /usr/share/applications/phpstorm.desktop

# Update desktop database
if command -v update-desktop-database &>/dev/null; then
  sudo update-desktop-database /usr/share/applications/
fi

# Set permissions
sudo chown -R root:root "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Verify installation
if verify_installation "PhpStorm" "phpstorm" ""; then
  print_status "You can launch PhpStorm by running 'phpstorm' command or from the application menu"
else
  exit 1
fi

print_status "PhpStorm installation script completed!"
print_warning "Note: You will need a JetBrains license to use PhpStorm"
print_warning "You can start a free 30-day trial or use your existing license"

