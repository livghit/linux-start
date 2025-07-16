# Linux Development Environment Setup

This script collection transforms a fresh Fedora or Ubuntu install into a complete development system.

## Supported Distributions

- **Fedora** (using dnf package manager)
- **Ubuntu** (using apt package manager)
- **Debian-based distributions** (using apt package manager)

The scripts automatically detect your distribution and use the appropriate package manager.

## Setup Process

### 1. System Update and Directory Setup
First, we detect your Linux distribution (Fedora/Ubuntu), update the system using the appropriate package manager, and create a personal folder structure.

### 2. Package Installation
The following development tools will be installed:

- **Neovim** & neovim configs (from source)
- **lazygit** - Git terminal UI
- **lazydocker** - Docker terminal UI  
- **tmux** - Terminal multiplexer
- **Git** - Version control
- **Docker** - Containerization platform
- **Bun** - JavaScript runtime
- **nvm** - Node.js version manager

### 3. Desktop Environment
**Hyprland with Wayland** will be installed using the installation script from:
<https://github.com/JaKooLit/Fedora-Hyprland>
