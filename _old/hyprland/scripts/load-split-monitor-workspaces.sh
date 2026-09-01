#!/usr/bin/env bash
# Ensure split-monitor-workspaces is loaded after Hyprland start.
# The plugin = directive in hyprland.conf can fail silently on cold boot;
# this script is the reliable fallback.

set -euo pipefail

PLUGIN="${HOME}/.config/hypr/plugins/libsplit-monitor-workspaces.so"

if [[ ! -f "$PLUGIN" ]]; then
  notify-send -u critical "Hyprland" "split-monitor-workspaces plugin missing: $PLUGIN"
  exit 1
fi

if hyprctl plugin list 2>/dev/null | grep -q 'split-monitor-workspaces'; then
  exit 0
fi

if ! hyprctl plugin load "$PLUGIN" 2>/dev/null; then
  notify-send -u critical "Hyprland" "Failed to load split-monitor-workspaces — rebuild the plugin for your Hyprland version"
  exit 1
fi

hyprctl reload
