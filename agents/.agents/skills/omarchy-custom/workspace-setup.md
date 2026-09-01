# workspace-setup.sh – Work/Home Monitor-Layout

## Ziel

Hyprland automatisch oder manuell zwischen zwei Monitor-Setups umschalten:

| Modus | Monitore | Xiaomi-Position |
|-------|----------|-----------------|
| `work` | 3 Monitore (LG links, Xiaomi Mitte, LG rechts) + Laptop | `1440x0` |
| `home` | Laptop + Xiaomi | `1920x0` |

## Dateien

| Datei | Pfad | Rolle |
|-------|------|-------|
| `workspace-setup.sh` | `~/dotfiles/hyprland/.config/hypr/scripts/workspace-setup.sh` (via Symlink) | Schreibt `monitors.lua` und lädt Hyprland neu |
| `monitors.lua` | `~/dotfiles/hyprland/.config/hypr/monitors.lua` (via Symlink) | Wird vom Skript generiert – **nicht manuell bearbeiten** |
| `bindings.lua` | `~/dotfiles/hyprland/.config/hypr/bindings.lua` (via Symlink) | Tastenkürzel F7/F8 |
| `autostart.lua` | `~/dotfiles/hyprland/.config/hypr/autostart.lua` (via Symlink) | Startet Auto-Detection beim Login |

> ⚠️ `monitors.lua` ist ein Symlink ins dotfiles-Repo. Das Skript schreibt durch den Symlink – die Layout-Definitionen gehören ins Skript, nicht in die Datei.

## Omarchy 4: Lua statt conf

Seit Omarchy 4 schreibt das Skript `monitors.lua` (Lua-Syntax, `hl.monitor({ ... })`), nicht mehr `monitors.conf`. Der Waybar-Restart-Block ist entfernt (Waybar existiert in Omarchy 4 nicht mehr). Die alte Version liegt in [old/](./old/) bzw. im Repo unter `_old/hyprland/`.

## Konfiguration

### Autostart

In `~/dotfiles/hyprland/.config/hypr/autostart.lua`:

```lua
o.exec_on_start(os.getenv("HOME") .. "/.config/hypr/scripts/workspace-setup.sh auto")
```

### Tastenkürzel

In `~/dotfiles/hyprland/.config/hypr/bindings.lua`:

```lua
o.bind("SUPER + F7", "Work monitor layout", ".../workspace-setup.sh work")
o.bind("SUPER + F8", "Home monitor layout", ".../workspace-setup.sh home")
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

#### `work` (3-Monitor-Setup + Laptop)

| Monitor | Position | Logische Breite | Bemerkung |
|---------|----------|-----------------|-----------|
| LG HDR 4K links (`0x0003E9A7`) | `0x0` | 1440 px (2160 / 1.5) | `scale = 1.5, transform = 1` (Portrait) |
| Xiaomi Mi Monitor | `1440x0` | 3440 px | |
| LG HDR 4K rechts (`0x00030432`) | `4880x0` | 1440 px | `scale = 1.5, transform = 1` (Portrait) |
| Laptop (`eDP-1`) | `6320x0` | 1920 px | |

#### `home` (Laptop + Xiaomi)

| Monitor | Position | Logische Breite |
|---------|----------|-----------------|
| Laptop (`eDP-1`) | `0x0` | 1920 px |
| Xiaomi Mi Monitor | `1920x0` | 3440 px |
| LG-Monitore | `disabled = true` | — |

## Verwendung

```bash
~/.config/hypr/scripts/workspace-setup.sh auto   # automatisch erkennen
~/.config/hypr/scripts/workspace-setup.sh work   # manuell work
~/.config/hypr/scripts/workspace-setup.sh home   # manuell home
```

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| Maus springt zwischen Monitoren | Physische Anordnung vs. Seriennummern prüfen (`hyprctl monitors`) |
| Config-Fehler nach Layoutwechsel | `hyprctl configerrors` – generierte `monitors.lua` prüfen |
| `hyprctl` nicht verfügbar beim Autostart | Skript wartet intern bis zu 10 Sekunden auf Hyprland |
