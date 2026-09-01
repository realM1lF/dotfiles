# workspace-setup.sh – Work/Home Monitor-Layout

## Ziel

Hyprland automatisch oder manuell zwischen zwei Monitor-Setups umschalten:

| Modus | Monitore | Xiaomi-Position |
|-------|----------|-----------------|
| `work` | 3 Monitore (LG links, Xiaomi Mitte, LG rechts) | `1440x0` |
| `home` | Laptop + Xiaomi | `1920x0` |

## Warum nicht mehr hyprmon?

`hyprmon` hat im Hintergrund laufend `monitors.conf` und `monitors.json` überschrieben und dabei die workspace-spezifische Unterscheidung zwischen `work` und `home` ignoriert. Dadurch entstanden Lücken oder Überlappungen zwischen den Monitoren.

## Dateien

| Datei | Pfad | Rolle |
|-------|------|-------|
| `workspace-setup.sh` | `~/dotfiles/hyprland/.config/hypr/scripts/workspace-setup.sh` (via Symlink) | Schreibt `monitors.conf` und lädt Hyprland neu |
| `monitors.conf` | `~/dotfiles/hyprland/.config/hypr/monitors.conf` (via Symlink) | Wird vom Skript überschrieben |
| `bindings.conf` | `~/dotfiles/hyprland/.config/hypr/bindings.conf` (via Symlink) | Tastenkürzel für work/home |
| `autostart.conf` | `~/dotfiles/hyprland/.config/hypr/autostart.conf` (via Symlink) | Startet Auto-Detection beim Login |

## Konfiguration

### Autostart

In `~/dotfiles/hyprland/.config/hypr/autostart.conf`:

```conf
# Auto-Detect work/home monitor layout on login
exec-once = ~/.config/hypr/scripts/workspace-setup.sh auto
```

### Tastenkürzel

In `~/dotfiles/hyprland/.config/hypr/bindings.conf`:

```conf
bindd = SUPER, F7, Work layout, exec, ~/.config/hypr/scripts/workspace-setup.sh work
bindd = SUPER, F8, Home layout, exec, ~/.config/hypr/scripts/workspace-setup.sh home
```

### Auto-Detection

Ohne Argument wählt das Skript automatisch:

- `work`: wenn beide LG-Portrait-Monitore **und** der Xiaomi-Monitor erkannt werden
- `home`: in allen anderen Fällen

Erkennung über die Monitor-Seriennummern:

| Monitor | Seriennummer / Beschreibung |
|---------|----------------------------|
| LG links | `0x0003E9A7` |
| LG rechts | `0x00030432` |
| Xiaomi | `Xiaomi Corporation Mi Monitor 0000000000000` |

### Layout-Details

#### `work` (3-Monitor-Setup)

| Monitor | Position | Logische Breite |
|---------|----------|-----------------|
| LG HDR 4K links (`0x0003E9A7`) | `0x0` | 1440 px (2160 / 1.5) |
| Xiaomi Mi Monitor | `1440x0` | 3440 px |
| LG HDR 4K rechts (`0x00030432`) | `4880x0` | 1440 px |
| Laptop (`eDP-1`) | `6320x0` | 1920 px |

#### `home` (Laptop + Xiaomi)

| Monitor | Position | Logische Breite |
|---------|----------|-----------------|
| Laptop (`eDP-1`) | `0x0` | 1920 px |
| Xiaomi Mi Monitor | `1920x0` | 3440 px |
| LG-Monitore | `disable` | — |

## Verwendung

```bash
# Automatisch erkennen und anwenden
~/.config/hypr/scripts/workspace-setup.sh auto

# Manuell work
~/.config/hypr/scripts/workspace-setup.sh work

# Manuell home
~/.config/hypr/scripts/workspace-setup.sh home
```

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| Maus springt zwischen Monitoren | Prüfen, ob die physische Anordnung noch mit den Seriennummern übereinstimmt (`hyprctl monitors`) |
| waybar zeigt falsche Workspaces | Skript startet waybar automatisch neu; sonst `omarchy restart waybar` |
| `hyprctl` nicht verfügbar beim Autostart | Skript wartet intern bis zu 10 Sekunden auf Hyprland |
| Zwei Waybar-Bars übereinander nach Login | Behoben: `workspace-setup.sh` restartet Waybar nur noch, wenn es bereits läuft. Siehe [Waybar-Restart-Race-Condition](#waybar-restart-race-condition) |

## Waybar-Restart-Race-Condition (behoben)

**Problem (2026-06-19):** Nach dem Login waren zwei Waybar-Bars übereinander sichtbar.

**Ursache:** Omarchys Default-Autostart startet Waybar asynchron über `uwsm-app -- waybar`. `workspace-setup.sh` führte aber sofort nach `hyprctl reload` ein `omarchy restart waybar` aus. Zu diesem Zeitpunkt lief Waybar noch nicht, sodass `pkill` ins Leere griff und eine zweite Instanz gestartet wurde. Kurz darauf startete auch die ursprüngliche Instanz.

**Fix in `workspace-setup.sh`:** Der `omarchy restart waybar` wird nur noch ausgeführt, wenn Waybar bereits läuft:

```bash
if command -v omarchy >/dev/null 2>&1; then
    if pgrep -x waybar >/dev/null 2>&1; then
        log "Starte waybar neu..."
        omarchy restart waybar >/dev/null 2>&1 || true
    else
        log "Waybar laeuft noch nicht - ueberspringe Restart (Autostart uebernimmt)."
    fi
fi
```

**Stand:** Nur noch ein Waybar-Prozess; auf jedem Monitor genau eine Bar.

## hyprmon-Reste entfernen

`hyprmon` wird nicht mehr verwendet. Für die vollständige Deinstallation müssen folgende Dateien entfernt werden (erfordert `sudo`):

```bash
sudo rm -f /usr/local/bin/hyprmon
sudo rm -f /usr/bin/hyprmon.original.*
sudo pacman -R hyprmon
rm -rf ~/.cache/hyprmon-src
```
