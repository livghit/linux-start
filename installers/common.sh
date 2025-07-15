#!/bin/bash

# Common library for installer scripts
# This file contains shared functions used by all installer scripts

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

# Common validation functions
check_root() {
  if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
    exit 1
  fi
}

# Detect the operating system
detect_os() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS_ID="$ID"
    OS_ID_LIKE="$ID_LIKE"
  else
    print_error "Cannot detect operating system"
    exit 1
  fi
}

# Check if OS is supported and set package manager
check_supported_os() {
  detect_os
  
  case "$OS_ID" in
    fedora)
      PACKAGE_MANAGER="dnf"
      UPDATE_CMD="sudo dnf update -y"
      INSTALL_CMD="sudo dnf install -y"
      ;;
    ubuntu|debian)
      PACKAGE_MANAGER="apt"
      UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
      INSTALL_CMD="sudo apt install -y"
      ;;
    *)
      # Check ID_LIKE for derivatives
      case "$OS_ID_LIKE" in
        *debian*|*ubuntu*)
          PACKAGE_MANAGER="apt"
          UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
          INSTALL_CMD="sudo apt install -y"
          ;;
        *fedora*|*rhel*)
          PACKAGE_MANAGER="dnf"
          UPDATE_CMD="sudo dnf update -y"
          INSTALL_CMD="sudo dnf install -y"
          ;;
        *)
          print_error "Unsupported operating system: $OS_ID"
          print_error "This script supports Fedora, Ubuntu, and Debian-based distributions"
          exit 1
          ;;
      esac
      ;;
  esac
  
  print_status "Detected OS: $OS_ID (using $PACKAGE_MANAGER package manager)"
}

check_fedora() {
  if ! command -v dnf &>/dev/null; then
    print_error "This script is designed for Fedora systems with dnf package manager."
    exit 1
  fi
}

# Check if a command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# Ensure Go is available in PATH
ensure_go_in_path() {
  if ! command_exists "go"; then
    print_status "Refreshing environment to find Go..."
    export PATH=$PATH:/usr/bin:/usr/local/bin
    hash -r  # Refresh command hash table
    
    if ! command_exists "go"; then
      print_error "Go is not installed or not found in PATH"
      print_error "Please install Go first: sudo dnf install go"
      return 1
    fi
  fi
  print_status "Go found: $(go version)"
  return 0
}

# Check if a tool is already installed
check_already_installed() {
  local tool_name="$1"
  local command_name="${2:-$1}"
  
  if command_exists "$command_name"; then
    print_warning "$tool_name is already installed"
    if command_exists "$command_name" && [[ -n "$3" ]]; then
      print_warning "Version: $($command_name $3 2>/dev/null || echo 'Unknown')"
    fi
    print_warning "Skipping installation..."
    return 0
  fi
  return 1
}

# Common initialization
init_installer() {
  local tool_name="$1"
  print_status "Starting $tool_name installation process..."
  
  check_root
  check_supported_os
  
  set -e # Exit on any error
}

# Create personal directory if it doesn't exist
create_personal_dir() {
  if [ ! -d "$HOME/personal" ]; then
    mkdir -p "$HOME/personal"
  fi
}

# Verify installation
verify_installation() {
  local tool_name="$1"
  local command_name="${2:-$1}"
  local version_flag="${3:---version}"
  
  # Ensure $HOME/go/bin is in PATH for verification
  if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    export PATH="$PATH:$HOME/go/bin"
  fi
  
  if command_exists "$command_name"; then
    print_status "$tool_name installation completed successfully!"
    if [[ -n "$version_flag" ]]; then
      print_status "Version: $($command_name $version_flag 2>/dev/null | head -1 || echo 'Unknown')"
    fi
    return 0
  else
    print_error "$tool_name installation failed!"
    return 1
  fi
}

# Install dependencies
install_dependencies() {
  local deps="$*"
  if [[ -n "$deps" ]]; then
    print_status "Installing dependencies: $deps"
    $INSTALL_CMD $deps
  fi
}

# Clean up downloaded files
cleanup() {
  local files="$*"
  for file in $files; do
    if [[ -f "$file" ]]; then
      rm -f "$file"
    fi
  done
}

# Download file with error handling
download_file() {
  local url="$1"
  local output="$2"
  local description="${3:-file}"
  
  print_status "Downloading $description..."
  if ! wget -O "$output" "$url"; then
    print_error "Failed to download $description from $url"
    return 1
  fi
  return 0
}

# Extract tar.gz file
extract_tarball() {
  local tarball="$1"
  local destination="$2"
  local description="${3:-archive}"
  
  print_status "Extracting $description..."
  if ! sudo tar -xzf "$tarball" -C "$destination" --strip-components=1; then
    print_error "Failed to extract $description"
    return 1
  fi
  return 0
}

# Create symlink
create_symlink() {
  local source="$1"
  local target="$2"
  local description="${3:-symlink}"
  
  print_status "Creating $description..."
  sudo ln -sf "$source" "$target"
}