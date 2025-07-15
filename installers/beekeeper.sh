#!/bin/bash

# Beekeeper Studio Installation Script for Fedora
# This script installs Beekeeper Studio from official releases

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Beekeeper Studio"

# Check if already installed
if command_exists "beekeeper-studio" || [[ -f "/usr/local/bin/beekeeper-studio" ]]; then
  print_warning "Beekeeper Studio appears to be already installed"
  print_warning "Skipping installation..."
  exit 0
fi

# Install dependencies
install_dependencies "curl wget jq"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
  x86_64) ARCH_SUFFIX="x86_64" ;;
  aarch64) ARCH_SUFFIX="aarch64" ;;
  *) 
    print_error "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Get latest version from GitHub releases
print_status "Fetching latest Beekeeper Studio release information..."
LATEST_RELEASE=$(curl -s https://api.github.com/repos/beekeeper-studio/beekeeper-studio/releases/latest)
VERSION=$(echo "$LATEST_RELEASE" | jq -r '.tag_name' | sed 's/^v//')

if [[ -z "$VERSION" || "$VERSION" == "null" ]]; then
  print_error "Failed to fetch latest version"
  exit 1
fi

print_status "Latest version: $VERSION"

# Try RPM first (preferred for Fedora)
RPM_URL="https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${VERSION}/beekeeper-studio-${VERSION}.${ARCH_SUFFIX}.rpm"
print_status "Attempting to install RPM package..."

# Download RPM
TEMP_RPM="/tmp/beekeeper-studio-${VERSION}.${ARCH_SUFFIX}.rpm"
if download_file "$RPM_URL" "$TEMP_RPM" "Beekeeper Studio RPM"; then
  # Install RPM
  print_status "Installing Beekeeper Studio RPM..."
  if sudo dnf install -y "$TEMP_RPM"; then
    cleanup "$TEMP_RPM"
    print_status "Beekeeper Studio installed successfully via RPM!"
  else
    print_warning "RPM installation failed, trying Flatpak..."
    cleanup "$TEMP_RPM"
    
    # Fallback to Flatpak
    if ! command_exists "flatpak"; then
      print_status "Installing Flatpak..."
      install_dependencies "flatpak"
    fi
    
    # Add Flathub repository
    print_status "Adding Flathub repository..."
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Install via Flatpak
    print_status "Installing Beekeeper Studio via Flatpak..."
    if sudo flatpak install -y flathub io.beekeeperstudio.Studio; then
      # Create symlink for command line access
      print_status "Creating command line symlink..."
      sudo tee /usr/local/bin/beekeeper-studio >/dev/null <<EOF
#!/bin/bash
exec flatpak run io.beekeeperstudio.Studio "\$@"
EOF
      sudo chmod +x /usr/local/bin/beekeeper-studio
      print_status "Beekeeper Studio installed successfully via Flatpak!"
    else
      print_error "Failed to install Beekeeper Studio via Flatpak"
      exit 1
    fi
  fi
else
  print_error "Failed to download RPM package"
  exit 1
fi

print_status "Beekeeper Studio installation script completed!"
print_status "You can launch Beekeeper Studio from the applications menu"
