#!/bin/bash

# i3status installer
# This script installs i3status status bar for i3 window manager

# Source common functions
source "$(dirname "$0")/common.sh"

install_i3status() {
  init_installer "i3status"

  if check_already_installed "i3status" "i3status" "--version"; then
    return 0
  fi

  print_status "Installing i3status..."

  # Install i3status package
  case "$PACKAGE_MANAGER" in
  dnf)
    install_dependencies "i3status"
    ;;
  apt)
    install_dependencies "i3status"
    ;;
  esac

  # Create i3status config directory
  mkdir -p "$HOME/.config/i3status"

  # Create basic i3status configuration if it doesn't exist
  if [[ ! -f "$HOME/.config/i3status/config" ]]; then
    print_status "Creating default i3status configuration..."
    cat >"$HOME/.config/i3status/config" <<'EOF'
# i3status configuration file
# see "man i3status" for documentation.

general {
        colors = true
        interval = 5
        color_good = "#a3be8c"
        color_bad = "#bf616a"
        color_degraded = "#ebcb8b"
}

order += "wireless _first_"
order += "ethernet _first_"
order += "battery all"
order += "load"
order += "memory"
order += "disk /"
order += "volume master"
order += "tztime local"

wireless _first_ {
        format_up = "W: (%quality at %essid) %ip"
        format_down = "W: down"
}

ethernet _first_ {
        format_up = "E: %ip (%speed)"
        format_down = "E: down"
}

battery all {
        format = "%status %percentage %remaining"
        format_down = "No battery"
        status_chr = "⚡ CHR"
        status_bat = "🔋 BAT"
        status_unk = "? UNK"
        status_full = "☻ FULL"
        path = "/sys/class/power_supply/BAT%d/uevent"
        low_threshold = 10
}

load {
        format = "Load: %1min"
}

memory {
        format = "RAM: %used / %available"
        threshold_degraded = "1G"
        format_degraded = "MEMORY < %available"
}

disk "/" {
        format = "Disk: %avail"
}

volume master {
        format = "♪: %volume"
        format_muted = "♪: muted (%volume)"
        device = "default"
        mixer = "Master"
        mixer_idx = 0
}

tztime local {
        format = "%Y-%m-%d %H:%M:%S"
}
EOF
  fi

  verify_installation "i3status" "i3status" "--version"
}

# Run the installer
install_i3status

