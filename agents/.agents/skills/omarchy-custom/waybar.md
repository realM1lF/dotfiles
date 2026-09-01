# Waybar – Custom Status Bar

## Dateien

| Datei | Pfad |
|-------|------|
| config.jsonc | `~/dotfiles/waybar/.config/waybar/config.jsonc` (via Symlink) |
| style.css | `~/dotfiles/waybar/.config/waybar/style.css` (via Symlink) |

## Hauptunterschiede zum Omarchy-Default

### Workspaces

- `all-outputs: false` – Workspaces werden pro Monitor angezeigt (empfohlen für `split-monitor-workspaces`).
- Workspace-Icons für 1–100 definiert, damit jeder Monitor seine eigenen 10 Workspaces anzeigen kann (1–10, 11–20, …, 91–100).
- Jedes Workspace-Icon wird als Ziffer 1–10 dargestellt, nicht als fortlaufende Nummer.

### Module

| Bereich | Module |
|---------|--------|
| links | `custom/omarchy`, `hyprland/workspaces` |
| center | `clock`, `custom/weather`, `custom/update`, `custom/voxtype`, `custom/screenrecording-indicator` |
| rechts | `group/tray-expander`, `bluetooth`, `network`, `pulseaudio`, `cpu`, `battery` |

Entfernt bzw. nicht im Center enthalten (im Vergleich zum Default):
- `custom/idle-indicator`
- `custom/notification-silencing-indicator`

Diese Module sind zwar noch in der Config definiert, werden aber nicht mehr in `modules-center` angezeigt.

### Styling

- Schriftart: `JetBrainsMono Nerd Font`, 12px.
- `@import "../omarchy/current/theme/waybar.css"` – Theme-Farben werden aus dem aktuellen Omarchy-Theme geladen.
- Angepasste Margins für Tray, Bluetooth, Network, Expand-Icon, etc.
- `.active`-Klassen für Screenrecording, Idle und Notification-Silencing färben sich rot (`#a55555`).

## Wichtige Hinweise

- Nach Änderungen an `config.jsonc` oder `style.css` muss Waybar neu gestartet werden: `omarchy restart waybar`.
- Waybar lädt das aktuelle Theme-Farbschema dynamisch aus `../omarchy/current/theme/waybar.css`.
- **2026-06-19:** Doppelte Waybar-Bar nach Login behoben – siehe [`workspace-setup.md` → Waybar-Restart-Race-Condition](./workspace-setup.md#waybar-restart-race-condition).
