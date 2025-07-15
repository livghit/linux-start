#!/bin/bash

# Docker Installation Script
# This script installs Docker CE on supported Linux distributions using official repositories

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Initialize installer
init_installer "Docker"

# Update system packages
print_status "Updating system packages..."
$UPDATE_CMD

# Remove any existing Docker packages and install Docker
print_status "Removing any existing Docker packages..."
if [[ "$PACKAGE_MANAGER" == "dnf" ]]; then
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

elif [[ "$PACKAGE_MANAGER" == "apt" ]]; then
  sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
  
  # Install prerequisites
  install_dependencies "ca-certificates curl gnupg lsb-release"
  
  # Add Docker's official GPG key
  print_status "Adding Docker GPG key..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  
  # Set up the repository
  print_status "Adding Docker repository..."
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  # Update package index
  sudo apt-get update
  
  # Install Docker packages
  install_dependencies "docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
fi

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
