#!/bin/bash

# This script will download all the necessary config files for the fedora setup

set -e

echo "🔧 Setting up configuration files..."

# Create .config directory if it doesn't exist
if [ ! -d "$HOME/.config" ]; then
    echo "📁 Creating .config directory..."
    mkdir -p "$HOME/.config"
fi

# Create common directories
echo "📁 Creating configuration directories..."
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/lazygit"

# Neovim configuration
echo "⚙️  Setting up Neovim configuration..."

# Here we import the configs from github and clone it into the .config folder as nvim

EOF
    echo "✅ Neovim configuration created"
else
    echo "ℹ️  Neovim configuration already exists"
fi

# Tmux configuration
echo "⚙️  Setting up Tmux configuration..."
# Here as well as the config for gitbhub clone it into the .config folder as tmux
EOF
    echo "✅ Tmux configuration created"
else
    echo "ℹ️  Tmux configuration already exists"
fi

# Git configuration
echo "⚙️  Setting up Git configuration..."
if [ ! -f "$HOME/.gitconfig" ]; then
    cat > "$HOME/.gitconfig" << 'EOF'
[user]
    name = livghit
    email = your.email@example.com

[color]
    ui = auto

[delta]
    navigate = true
    light = false
    line-numbers = true
    syntax-theme = Dracula
EOF
    echo "✅ Git configuration created"
    echo "⚠️  Please update your name and email in ~/.gitconfig"
else
    echo "ℹ️  Git configuration already exists"
fi

# Create a basic .bashrc addition for non-fish users
# For this as well we are going to clone the config from github

echo "🎉 Configuration setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Update your name and email in ~/.gitconfig"
echo "2. Restart your terminal or run 'source ~/.bashrc' to apply changes"
echo "3. Install Oh My Fish for enhanced Fish shell experience"
echo "4. Configure your development tools as needed"
