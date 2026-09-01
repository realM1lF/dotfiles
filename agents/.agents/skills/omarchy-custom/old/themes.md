# Custom Omarchy Themes

## Übersicht

Neben den Omarchy-Standard-Themes liegen unter `~/.config/omarchy/themes/` eigene Themes, die über `omarchy theme set <Name>` angewendet werden können.

## Speicherort

| Symlink in `~/.config/omarchy/themes/` | Quelle in `~/dotfiles/` |
|----------------------------------------|-------------------------|
| `azure-glow` | `omarchy/.config/omarchy/themes/azure-glow` |
| `monochrome` | `omarchy/.config/omarchy/themes/monochrome` |
| `monochrome-round` | `omarchy/.config/omarchy/themes/monochrome-round` |

## Theme-Dateien

Jedes Theme enthält folgende Dateien:

| Datei | Zweck |
|-------|-------|
| `README.md` | Theme-Beschreibung |
| `colors.toml` | Farbpalette |
| `hyprland.conf` | Hyprland-spezifische Farben/Einstellungen |
| `hyprlock.conf` | Lockscreen-Aussehen |
| `waybar.css` | Waybar-Farben |
| `alacritty.toml` | Terminal-Farben |
| `btop.theme` | btop-Farben |
| `mako.ini` | Notification-Daemon-Farben |
| `swayosd.css` | OSD-Farben |
| `walker.css` | App-Launcher-Farben |
| `neovim.lua` | Neovim-Farben |
| `icons.theme` | Icon-Theme-Name |
| `backgrounds/` | Wallpaper(s) |

## Aktuelles Theme

Das aktuell aktive Theme liegt unter:

```
~/.config/omarchy/current/theme -> ../../../dotfiles/omarchy/.config/omarchy/themes/<aktives-theme>
```

## Anwendung

```bash
omarchy theme set "azure-glow"
omarchy theme set "monochrome"
omarchy theme set "monochrome-round"
```

> Beim Erstellen neuer Themes immer ein eigenes Verzeichnis unter `~/dotfiles/omarchy/.config/omarchy/themes/<name>` anlegen und als Symlink unter `~/.config/omarchy/themes/` verfügbar machen.
