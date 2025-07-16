#!/bin/bash

# kitty terminal emulator installer
# This script installs kitty terminal emulator

# Source common functions
source "$(dirname "$0")/common.sh"

install_kitty() {
  init_installer "kitty terminal emulator"
  
  if check_already_installed "kitty" "kitty" "--version"; then
    return 0
  fi
  
  print_status "Installing kitty terminal emulator..."
  
  # Install kitty package
  case "$PACKAGE_MANAGER" in
    dnf)
      install_dependencies "kitty"
      ;;
    apt)
      install_dependencies "kitty"
      ;;
  esac
  
  # Create kitty config directory
  mkdir -p "$HOME/.config/kitty"
  
  # Create basic kitty configuration if it doesn't exist
  if [[ ! -f "$HOME/.config/kitty/kitty.conf" ]]; then
    print_status "Creating default kitty configuration..."
    cat > "$HOME/.config/kitty/kitty.conf" << 'EOF'
# Kitty terminal configuration

# Font configuration
font_family      JetBrains Mono
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size        12.0

# Cursor configuration
cursor_shape     block
cursor_blink_interval     0.5
cursor_stop_blinking_after 15.0

# Scrollback
scrollback_lines 2000
scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER

# Mouse
mouse_hide_wait 3.0
url_color #0087BD
url_style curly

# Performance tuning
repaint_delay 10
input_delay 3
sync_to_monitor yes

# Window layout
remember_window_size  yes
initial_window_width  640
initial_window_height 400
window_border_width 0.5pt
window_margin_width 0
window_padding_width 0
placement_strategy center
active_border_color #00ff00
inactive_border_color #cccccc
bell_border_color #ff5a00

# Tab bar
tab_bar_edge bottom
tab_bar_margin_width 0.0
tab_bar_margin_height 0.0 0.0
tab_bar_style fade
tab_bar_min_tabs 2
tab_switch_strategy previous
tab_fade 0.25 0.5 0.75 1
tab_separator " ┇"
tab_title_template "{title}"
active_tab_title_template none
active_tab_foreground   #000
active_tab_background   #eee
active_tab_font_style   bold-italic
inactive_tab_foreground #444
inactive_tab_background #999
inactive_tab_font_style normal

# Color scheme (One Dark)
foreground #abb2bf
background #282c34
selection_foreground #282c34
selection_background #979eab
url_color #56b6c2
cursor #abb2bf
cursor_text_color #282c34

# Normal colors
color0 #282c34
color1 #e06c75
color2 #98c379
color3 #e5c07b
color4 #61afef
color5 #c678dd
color6 #56b6c2
color7 #abb2bf

# Bright colors
color8  #5c6370
color9  #e06c75
color10 #98c379
color11 #e5c07b
color12 #61afef
color13 #c678dd
color14 #56b6c2
color15 #ffffff

# Advanced
shell .
editor .
close_on_child_death no
allow_remote_control no
update_check_interval 24
startup_session none
clipboard_control write-clipboard write-primary
term xterm-kitty

# OS specific tweaks
linux_display_server auto

# Keyboard shortcuts
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+s paste_from_selection
map shift+insert paste_from_selection
map ctrl+shift+o pass_selection_to_program

# Window management
map ctrl+shift+enter new_window
map ctrl+shift+n new_os_window
map ctrl+shift+w close_window
map ctrl+shift+] next_window
map ctrl+shift+[ previous_window
map ctrl+shift+f move_window_forward
map ctrl+shift+b move_window_backward
map ctrl+shift+` move_window_to_top
map ctrl+shift+r start_resizing_window
map ctrl+shift+1 first_window
map ctrl+shift+2 second_window
map ctrl+shift+3 third_window
map ctrl+shift+4 fourth_window
map ctrl+shift+5 fifth_window
map ctrl+shift+6 sixth_window
map ctrl+shift+7 seventh_window
map ctrl+shift+8 eighth_window
map ctrl+shift+9 ninth_window
map ctrl+shift+0 tenth_window

# Tab management
map ctrl+shift+right next_tab
map ctrl+shift+left previous_tab
map ctrl+shift+t new_tab
map ctrl+shift+q close_tab
map ctrl+shift+. move_tab_forward
map ctrl+shift+, move_tab_backward
map ctrl+shift+alt+t set_tab_title

# Layout management
map ctrl+shift+l next_layout

# Font sizes
map ctrl+shift+equal change_font_size all +2.0
map ctrl+shift+minus change_font_size all -2.0
map ctrl+shift+backspace change_font_size all 0

# Miscellaneous
map ctrl+shift+f5 load_config_file
map ctrl+shift+f6 debug_config
map ctrl+shift+delete clear_terminal reset active
map ctrl+shift+u kitten unicode_input
map ctrl+shift+f2 edit_config_file
map ctrl+shift+escape kitty_shell window
EOF
  fi
  
  verify_installation "kitty" "kitty" "--version"
}

# Run the installer
install_kitty