#!/bin/bash
# Fix split-monitor-workspaces after docking station reconnect.
#
# Problem: monitors get new port names on each reconnect (DP-8 -> DP-11 etc.),
# so the plugin creates wrong workspace ranges instead of restoring the correct
# ones. This script debounces monitoradded events, reassigns workspaces to the
# correct monitors by ID order, forces the plugin to recreate missing persistent
# workspaces, then restarts waybar.

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
PENDING_FILE="/tmp/monitor-watch-pending"
WS_PER_MONITOR=10

fix_workspaces() {
    # Debounce: docking station connects multiple monitors sequentially.
    # Only the last triggered handler proceeds.
    MY_TIME="$(date +%s%N)"
    echo "$MY_TIME" > "$PENDING_FILE"
    sleep 5
    [ "$(cat "$PENDING_FILE" 2>/dev/null)" = "$MY_TIME" ] || return

    # Assign workspace ranges to monitors in Hyprland ID order,
    # which matches how split-monitor-workspaces assigns them.
    idx=0
    while IFS= read -r monitor; do
        start=$((idx * WS_PER_MONITOR + 1))
        for ws in $(seq "$start" "$((start + WS_PER_MONITOR - 1))"); do
            hyprctl dispatch moveworkspacetomonitor "$ws" "$monitor" 2>/dev/null
        done
        idx=$((idx + 1))
    done < <(hyprctl monitors -j | jq -r 'sort_by(.id) | .[].name')

    # Reload Hyprland config so split-monitor-workspaces recreates any
    # persistent workspaces that are still missing after the moves above.
    hyprctl reload 2>/dev/null
    sleep 2
    omarchy-restart-waybar
}

socat -U - "UNIX-CONNECT:$SOCKET" | while read -r line; do
    case "$line" in
        monitoradded\>\>*)
            fix_workspaces &
            ;;
    esac
done
