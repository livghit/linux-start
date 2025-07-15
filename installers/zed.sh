#!/bin/bash

# Zed Editor Installation Script for Fedora
# This script installs Zed editor from the official release

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Zed"

# Check if Zed is already installed
if command_exists "zed" || [[ -f "$HOME/.local/bin/zed" ]] || [[ -f "/usr/local/bin/zed" ]]; then
  print_warning "Zed appears to be already installed"
  print_warning "Skipping installation..."
  exit 0
fi

# Install required dependencies
install_dependencies "curl wget tar"

# Get latest Zed version information
print_status "Fetching latest Zed version information..."
API_URL="https://api.github.com/repos/zed-industries/zed/releases/latest"
VERSION_INFO=$(curl -s "$API_URL")

if [[ -z "$VERSION_INFO" ]]; then
  print_error "Failed to fetch Zed version information"
  exit 1
fi

# Extract version and download URL for Linux x64
VERSION=$(echo "$VERSION_INFO" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)
DOWNLOAD_URL=$(echo "$VERSION_INFO" | grep -o '"browser_download_url": "[^"]*linux[^"]*\.tar\.gz"' | cut -d'"' -f4 | head -n1)

if [[ -z "$VERSION" ]] || [[ -z "$DOWNLOAD_URL" ]]; then
  print_error "Failed to parse Zed version information"
  exit 1
fi

print_status "Latest Zed version: $VERSION"
print_status "Download URL: $DOWNLOAD_URL"

# Create installation directory
INSTALL_DIR="$HOME/.local/share/zed"
print_status "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# Download and extract Zed
TEMP_FILE="/tmp/zed.tar.gz"
download_file "$DOWNLOAD_URL" "$TEMP_FILE" "Zed"
extract_tarball "$TEMP_FILE" "$INSTALL_DIR" "Zed"
cleanup "$TEMP_FILE"

# Find the actual Zed binary (it might be in a subdirectory)
ZED_BINARY=$(find "$INSTALL_DIR" -name "zed" -type f -executable | head -n1)

if [[ -z "$ZED_BINARY" ]]; then
  print_error "Could not find Zed binary after extraction"
  exit 1
fi

print_status "Found Zed binary at: $ZED_BINARY"

# Create wrapper script for command line usage
print_status "Creating Zed wrapper script..."
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/zed" <<EOF
#!/bin/bash
# Handle Wayland compatibility
if [[ "\$XDG_SESSION_TYPE" == "wayland" ]]; then
    export WAYLAND_DISPLAY=\${WAYLAND_DISPLAY:-wayland-1}
fi
# Ensure DISPLAY is set for X11 fallback
if [[ -z "\$DISPLAY" ]]; then
    export DISPLAY=:0
fi
exec "$ZED_BINARY" "\$@"
EOF
chmod +x "$HOME/.local/bin/zed"

# Create desktop entry
print_status "Creating desktop entry..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/zed.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Zed
Comment=A high-performance, multiplayer code editor
Exec=$HOME/.local/bin/zed %F
Icon=$ZED_BINARY
Categories=Development;TextEditor;
Terminal=false
StartupNotify=true
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/javascript;application/json;text/css;text/html;text/xml;text/x-sql;text/x-sh;
EOF

# Update desktop database if available
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$HOME/.local/share/applications/"
fi

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  print_status "Adding ~/.local/bin to PATH..."
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  print_warning "Please run 'source ~/.bashrc' or restart your terminal to update PATH"
fi

# Verify installation
if verify_installation "Zed" "$HOME/.local/bin/zed" ""; then
  print_status "You can launch Zed by running 'zed' command or from the application menu"
  print_status "To edit a file: zed filename"
  print_status "To open current directory: zed ."
else
  exit 1
fi

print_status "Zed installation script completed!"
print_status "Zed is a modern, fast code editor with built-in collaboration features"