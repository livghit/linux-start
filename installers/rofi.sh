#!/bin/bash

# rofi application launcher installer
# This script installs rofi application launcher

# Source common functions
source "$(dirname "$0")/common.sh"

install_rofi() {
  init_installer "rofi"
  
  if check_already_installed "rofi" "rofi" "--version"; then
    return 0
  fi
  
  print_status "Installing rofi application launcher..."
  
  # Install rofi package
  case "$PACKAGE_MANAGER" in
    dnf)
      install_dependencies "rofi"
      ;;
    apt)
      install_dependencies "rofi"
      ;;
  esac
  
  # Create rofi config directory
  mkdir -p "$HOME/.config/rofi"
  
  # Create basic rofi configuration if it doesn't exist
  if [[ ! -f "$HOME/.config/rofi/config.rasi" ]]; then
    print_status "Creating default rofi configuration..."
    cat > "$HOME/.config/rofi/config.rasi" << 'EOF'
configuration {
    modes: "window,drun,run,ssh";
    font: "mono 12";
    show-icons: true;
    icon-theme: "Papirus";
    terminal: "kitty";
    drun-display-format: "{icon} {name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    display-drun: "   Apps ";
    display-run: "   Run ";
    display-window: " 﩯  Window";
    display-Network: " 󰤨  Network";
    sidebar-mode: true;
}

@theme "default"

* {
    background-color: #282c34;
    text-color: #abb2bf;
    border-color: #61afef;
    width: 600;
    lines: 15;
}

window {
    transparency: "real";
    background-color: #282c34;
    border: 1;
    border-color: #61afef;
    border-radius: 12;
    padding: 5;
}

mainbox {
    background-color: transparent;
    children: [ inputbar, listview ];
}

inputbar {
    background-color: #3e4451;
    text-color: #abb2bf;
    border-radius: 5;
    padding: 8;
    spacing: 0;
    children: [ prompt, entry ];
}

prompt {
    enabled: true;
    background-color: transparent;
    text-color: #61afef;
    font: "Font Awesome 5 Free 10";
    padding: 0 8 0 0;
}

entry {
    background-color: transparent;
    text-color: #abb2bf;
    placeholder-color: #5c6370;
    expand: true;
    padding: 0;
}

listview {
    background-color: transparent;
    margin: 10 0 0 0;
    spacing: 2;
    cycle: true;
    dynamic: true;
    layout: vertical;
}

element {
    background-color: transparent;
    text-color: #abb2bf;
    orientation: horizontal;
    border-radius: 5;
    padding: 8;
}

element-icon {
    background-color: transparent;
    size: 24;
    border: 0;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    expand: true;
    vertical-align: 0.5;
    margin: 0 0 0 8;
}

element normal.urgent,
element alternate.urgent {
    background-color: #e06c75;
    text-color: #282c34;
}

element normal.active,
element alternate.active {
    background-color: #98c379;
    text-color: #282c34;
}

element selected {
    background-color: #61afef;
    text-color: #282c34;
}

element selected.urgent {
    background-color: #e06c75;
    text-color: #282c34;
}

element selected.active {
    background-color: #98c379;
    text-color: #282c34;
}
EOF
  fi
  
  verify_installation "rofi" "rofi" "--version"
}

# Run the installer
install_rofi