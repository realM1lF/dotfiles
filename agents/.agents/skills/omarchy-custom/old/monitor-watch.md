# monitor-watch.sh – Docking-Station Workspace-Fix

## Problem

Bei `split-monitor-workspaces` bekommen Monitore nach jedem Reconnect einer Docking-Station neue Port-Namen (z. B. `DP-8` → `DP-11`). Das Plugin ordnet dann Workspaces möglicherweise falschen Monitoren zu, anstatt die ursprünglichen Workspace-Bereiche wiederherzustellen.

## Lösung

Das Script `~/.config/hypr/scripts/monitor-watch.sh` lauscht auf Hyprlands `monitoradded`-Events, wartet 5 Sekunden (Debouncing für mehrere gleichzeitige Monitore), weist dann jedem Monitor den korrekten Workspace-Bereich zu und lädt Hyprland neu, damit persistente Workspaces neu erstellt werden.

## Dateien

| Datei | Pfad |
|-------|------|
| monitor-watch.sh | `~/dotfiles/hyprland/.config/hypr/scripts/monitor-watch.sh` (via Symlink) |
| autostart.conf | `~/dotfiles/hyprland/.config/hypr/autostart.conf` (via Symlink) |

## Aktivierungsstatus

Das Script existiert, ist aber in `autostart.conf` derzeit **auskommentiert**:

```conf
# Restart waybar on monitor reconnect to fix split-monitor-workspaces display
# FIXME: Diese Datei existiert noch nicht – anlegen oder omarchy-hyprland-monitor-watch verwenden
# exec-once = ~/.config/hypr/scripts/monitor-watch.sh
```

> Der FIXME-Kommentar ist veraltet – die Datei existiert mittlerweile. Um das Script zu aktivieren, muss die Zeile nur einkommentiert werden.

## Was das Script macht

1. Verbindet sich mit Hyprlands Socket2 (`$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock`).
2. Reagiert auf `monitoradded>>*`.
3. Wartet 5 Sekunden, um mehrere fast gleichzeitige Events zusammenzufassen.
4. Ordnet Workspaces 1–10, 11–20, 21–30 etc. den Monitoren nach ihrer Hyprland-ID zu.
5. Führt `hyprctl reload` aus, damit `split-monitor-workspaces` fehlende Workspaces neu erstellt.
6. Startet Waybar neu (`omarchy-restart-waybar`).
