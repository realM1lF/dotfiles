#!/usr/bin/env bash
# shellcheck disable=SC2016
#
# workspace-setup.sh – Hyprland Monitor-Layout für work/home umschalten.
#
# Ohne Argument wird automatisch erkannt, welches Layout passt:
#   - Beide LG-Portrait-Monitore angeschlossen  → work
#   - Nur Laptop + Xiaomi (oder nur Laptop)      → home
#
# Manuelle Modi:
#   workspace-setup.sh work
#   workspace-setup.sh home

set -euo pipefail

MONITOR_CONF="${HOME}/.config/hypr/monitors.conf"

LG_LEFT_SERIAL="0x0003E9A7"
LG_RIGHT_SERIAL="0x00030432"
XIAOMI_DESC="Xiaomi Corporation Mi Monitor 0000000000000"

log() {
    printf '[workspace-setup] %s\n' "$*"
}

# Prüfen, ob Hyprland verfügbar ist.
if ! command -v hyprctl >/dev/null 2>&1; then
    log "hyprctl nicht gefunden – Hyprland läuft nicht?"
    exit 1
fi

# Aktuell verbundene Monitore als JSON ermitteln.
# Beim Autostart kann hyprctl kurzzeitig noch keine Monitore liefern,
# daher kurz warten und mehrmals versuchen.
connected_monitors=""
for _ in {1..10}; do
    connected_monitors=$(hyprctl monitors -j 2>/dev/null || true)
    if [[ -n "$connected_monitors" ]]; then
        break
    fi
    sleep 1
done

if [[ -z "$connected_monitors" ]]; then
    log "Keine Monitore über hyprctl ermittelbar."
    exit 1
fi

has_left_lg() {
    echo "$connected_monitors" | grep -q "$LG_LEFT_SERIAL"
}

has_right_lg() {
    echo "$connected_monitors" | grep -q "$LG_RIGHT_SERIAL"
}

has_xiaomi() {
    echo "$connected_monitors" | grep -q "$XIAOMI_DESC"
}

MODE="${1:-auto}"

if [[ "$MODE" == "auto" ]]; then
    if has_left_lg && has_right_lg && has_xiaomi; then
        MODE="work"
    else
        MODE="home"
    fi
    log "Auto-Detection: ${MODE}"
fi

case "$MODE" in
    work)
        log "Wende work-Layout an (3 Monitore)."
        cat > "$MONITOR_CONF" <<'EOF'
# Hyprland Monitor Configuration
# Managed by workspace-setup.sh

monitor=desc:LG Electronics LG HDR 4K 0x0003E9A7,3840x2160@60.00,0x0,1.50,transform,1
monitor=desc:Xiaomi Corporation Mi Monitor 0000000000000,3440x1440@50.00,1440x0,1
monitor=desc:LG Electronics LG HDR 4K 0x00030432,3840x2160@60.00,4880x0,1.50,transform,1
monitor=eDP-1,1920x1200@60.00,6320x0,1

# Fallback for unknown monitors
monitor=,preferred,auto,1
EOF
        ;;

    home)
        log "Wende home-Layout an (Laptop + Xiaomi)."
        cat > "$MONITOR_CONF" <<'EOF'
# Hyprland Monitor Configuration
# Managed by workspace-setup.sh

monitor=eDP-1,1920x1200@60.00,0x0,1
monitor=desc:Xiaomi Corporation Mi Monitor 0000000000000,3440x1440@50.00,1920x0,1
monitor=desc:LG Electronics LG HDR 4K 0x00030432,disable
monitor=desc:LG Electronics LG HDR 4K 0x0003E9A7,disable

# Fallback for unknown monitors
monitor=,preferred,auto,1
EOF
        ;;

    *)
        log "Unbekannter Modus: ${MODE}"
        log "Verwendung: $0 [work|home|auto]"
        exit 1
        ;;
esac

log "Lade Hyprland-Config neu..."
hyprctl reload

# waybar neu starten, damit die Monitor-Anzeige passt.
# Beim initialen Hyprland-Start startet die Omarchy-Default-Autostart Waybar
# asynchron ueber uwsm-app. Ein sofortiges "omarchy restart waybar" greift dann
# noch ins Leere und erzeugt eine zweite Instanz. Daher nur restarten, wenn
# Waybar bereits laeuft (z. B. bei manuellem work/home-Wechsel).
if command -v omarchy >/dev/null 2>&1; then
    if pgrep -x waybar >/dev/null 2>&1; then
        log "Starte waybar neu..."
        omarchy restart waybar >/dev/null 2>&1 || true
    else
        log "Waybar laeuft noch nicht - ueberspringe Restart (Autostart uebernimmt)."
    fi
fi

log "Fertig."
