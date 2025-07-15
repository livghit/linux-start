#!/bin/bash

# Docker Installation Script for Fedora
# This script installs Docker CE on Fedora using the official Docker repository

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Docker"

# Get Fedora version
FEDORA_VERSION=$(rpm -E %fedora)
print_status "Detected Fedora $FEDORA_VERSION"

# Update system packages
print_status "Updating system packages..."
sudo dnf update -y

# Step 2: Remove any existing Docker packages
print_status "Removing any existing Docker packages..."
sudo dnf remove -y docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine \
  podman-docker || true

# Install required packages
install_dependencies "dnf-plugins-core"

# Add Docker repository
print_status "Adding Docker CE repository..."
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker packages
install_dependencies "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

# Start and enable Docker service
print_status "Starting and enabling Docker service..."
sudo systemctl enable --now docker

# Add current user to docker group
print_status "Adding current user ($USER) to docker group..."
sudo usermod -aG docker $USER

# Test Docker installation
print_status "Testing Docker installation..."
sudo docker run hello-world

# Display Docker version information
print_status "Docker installation completed successfully!"
echo
print_status "Docker version information:"
docker --version
docker compose version

echo
print_warning "IMPORTANT: You need to log out and log back in (or restart) for group changes to take effect."
print_warning "After logging back in, you can run Docker commands without sudo."

echo
print_status "To verify Docker is working without sudo after relogging:"
echo "  docker run hello-world"

echo
print_status "To start using Docker Compose:"
echo "  docker compose --help"

echo
print_status "Docker installation script completed!"
