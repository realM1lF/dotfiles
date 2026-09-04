# Theme Rins

User-Theme, 1:1-Fork vom Stock-Theme **Solitude** (Omarchy 4 / Quattro).

| | |
|---|---|
| Anzeigename | `Rins` |
| Slug | `rins` |
| Quelle | `/usr/share/omarchy/themes/solitude` |
| User-Kopie | `~/.config/omarchy/themes/rins` |
| Aktivieren | `omarchy theme set Rins` |

Nicht im dotfiles-Repo. Liegt nur unter `~/.config/omarchy/themes/rins`.

## Warum Fork, nicht Overlay

Overlay (gleicher Slug `solitude` unter `~/.config/omarchy/themes/`) würde Stock-Solitude patchen. Eigener Slug `rins` hält die Variante unabhängig, Solitude bleibt unangetastet.

## Abweichungen von Solitude

- `hyprland.lua`: Default-Opacity `0.985 0.96` → `0.935 override 0.91 override` (5 Prozentpunkte mehr Durchschein, absolut). Gilt für `default-opacity`-Fenster. Browser/Steam/Games bleiben opaque.
- `hyprland.lua`: leichtes Kawase-Blur (`size = 2`, `passes = 1`, `ignore_opacity`) hinter transparenten Fenstern. Stock hat Blur aus.
- `colors.toml`: BG/FG/Muted bleiben Solitude-Kohle. ANSI + `accent` aus User-Palette (Olive/Khaki/Salbei, Screenshot `Pictures/screenshot-2026-09-04_18-32-50.png`). `accent` / Active-Border `#a5975f`. Cursor/`bright_foreground` und Selection ohne Stahlblau (`#ccccb2` / `#252822`).
- `btop.theme`: Graph-Enden folgen derselben Accent-Palette.
- Kein `vscode.json`: Cursor/VS Code nutzt generiertes Omarchy-Theme statt Noctokai (Lila/Blau raus).
- Hook `theme-set.d/rins-gtk-accent`: GTK/libadwaita-Accent `yellow` + `#a5975f` in `gtk-3.0`/`gtk-4.0` `gtk.css`. Default wäre Adwaita-Blau.

## Anpassen

Edits nur in `~/.config/omarchy/themes/rins/`. Nie `/usr/share/omarchy/themes/solitude`.

Nach Farb-Änderungen:

```bash
omarchy theme set Rins
```

## Entfernen

```bash
omarchy theme remove Rins
```
