#!/usr/bin/env bash
#
# workspace-setup.sh – Hyprland Monitor-Layout für work/home umschalten.
#
# Schreibt ~/.config/hypr/monitors.lua (Lua-Config, Omarchy 4) und lädt
# Hyprland neu. Die Datei ist ein Symlink ins dotfiles-Repo – Änderungen
# am Layout daher hier im Skript machen, nicht in monitors.lua.
#
# Ohne Argument wird automatisch erkannt, welches Layout passt:
#   - Beide LG-Portrait-Monitore angeschlossen  → work
#   - Nur Laptop + Xiaomi (oder nur Laptop)      → home
#
# Manuelle Modi:
#   workspace-setup.sh work
#   workspace-setup.sh home

set -euo pipefail

MONITORS_LUA="${HOME}/.config/hypr/monitors.lua"

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

header() {
    cat <<EOF
-- Managed by workspace-setup.sh -- do not edit manually.
-- Regenerate: ~/.config/hypr/scripts/workspace-setup.sh [work|home|auto]
-- Current layout: ${MODE}

local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

EOF
}

footer() {
    cat <<'EOF'

-- Fallback for unknown monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
EOF
}

case "$MODE" in
    work)
        log "Wende work-Layout an (3 Monitore + Laptop)."
        {
            header
            cat <<'EOF'
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x0003E9A7", mode = "3840x2160@60.00", position = "0x0", scale = 1.50, transform = 1 })
hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor 0000000000000", mode = "3440x1440@50.00", position = "1440x0", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x00030432", mode = "3840x2160@60.00", position = "4880x0", scale = 1.50, transform = 1 })
hl.monitor({ output = "eDP-1", mode = "1920x1200@60.00", position = "6320x0", scale = 1 })
EOF
            footer
        } > "$MONITORS_LUA"
        ;;

    home)
        log "Wende home-Layout an (Laptop + Xiaomi)."
        {
            header
            cat <<'EOF'
hl.monitor({ output = "eDP-1", mode = "1920x1200@60.00", position = "0x0", scale = 1 })
hl.monitor({ output = "desc:Xiaomi Corporation Mi Monitor 0000000000000", mode = "3440x1440@50.00", position = "1920x0", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x00030432", disabled = true })
hl.monitor({ output = "desc:LG Electronics LG HDR 4K 0x0003E9A7", disabled = true })
EOF
            footer
        } > "$MONITORS_LUA"
        ;;

    *)
        log "Unbekannter Modus: ${MODE}"
        log "Verwendung: $0 [work|home|auto]"
        exit 1
        ;;
esac

log "Lade Hyprland-Config neu..."
hyprctl reload

log "Fertig."
