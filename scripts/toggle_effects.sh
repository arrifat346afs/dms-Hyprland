#!/bin/bash

# Path to store current state
STATE_FILE="/tmp/hypr_effects_state"

# Function to disable visual effects
disable_effects() {
  hyprctl --batch "
    keyword animations:enabled false;
    keyword decoration:drop_shadow false;
  "
  notify-send "🔋 Performance Mode" "Animations, blur, and shadows disabled."
}

# Function to enable visual effects
enable_effects() {
  hyprctl --batch "
    keyword animations:enabled true;
    keyword decoration:drop_shadow true;
  "
  notify-send "✨ Visual Mode" "Animations, blur, and shadows re-enabled."
}

# Toggle between states
if [ -f "$STATE_FILE" ]; then
  enable_effects
  rm "$STATE_FILE"
else
  disable_effects
  touch "$STATE_FILE"
fi
