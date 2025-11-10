#!/bin/bash

STATE_FILE="/tmp/workspace_scroll_state"
DELAY=0.8 # seconds between workspace switches (adjust if too fast/slow)

# If it's already running, kill it (toggle off)
if [ -f "$STATE_FILE" ]; then
  pkill -f "workspace_scroll.sh"
  rm -f "$STATE_FILE"
  notify-send "🛑 Workspace Scrolling Stopped"
  exit 0
fi

# Otherwise, start scrolling loop
touch "$STATE_FILE"
notify-send "🔁 Workspace Scrolling Started"

# Get total number of workspaces
TOTAL_WS=$(hyprctl workspaces -j | jq length)
if [ -z "$TOTAL_WS" ] || [ "$TOTAL_WS" -eq 0 ]; then
  TOTAL_WS=10 # fallback in case jq fails
fi

# Continuous loop: scroll forward then backward
dir=1 # 1 = forward, -1 = backward
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

while [ -f "$STATE_FILE" ]; do
  next_ws=$((current_ws + dir))

  # Reverse direction at edges
  if [ "$next_ws" -gt "$TOTAL_WS" ]; then
    dir=-1
    next_ws=$((TOTAL_WS - 1))
  elif [ "$next_ws" -lt 1 ]; then
    dir=1
    next_ws=2
  fi

  hyprctl dispatch workspace "$next_ws"
  current_ws=$next_ws

  sleep "$DELAY"
done
