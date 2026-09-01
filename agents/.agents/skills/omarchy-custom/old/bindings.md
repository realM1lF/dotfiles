# Custom Hyprland Bindings

Diese Datei dokumentiert alle benutzerdefinierten Tastenkürzel in `~/dotfiles/hyprland/.config/hypr/bindings.conf`, die über die Omarchy-Defaults hinausgehen.

## Datei

| Datei | Pfad |
|-------|------|
| bindings.conf | `~/dotfiles/hyprland/.config/hypr/bindings.conf` (via Symlink) |

## Application Bindings

| Binding | Aktion |
|---------|--------|
| `SUPER + Return` | Terminal im aktuellen Working Directory |
| `SUPER ALT + Return` | Tmux-Session im Terminal |
| `SUPER SHIFT + F` | Dateimanager (Nautilus) |
| `SUPER + B` | Browser |
| `SUPER SHIFT + B` | Browser (private) |
| `SUPER + M` | Spotify starten/fokussieren |
| `SUPER + N` | Editor |
| `SUPER + T` | `btop` im Terminal |
| `SUPER + D` | `lazydocker` im Terminal |
| `SUPER + O` | Obsidian starten/fokussieren |
| `SUPER + /` | 1Password |
| `SUPER + Q` | Walker Clipboard-Menü |
| `SUPER SHIFT + S` | Omarchy Screenshot (smart copy) |
| `SUPER SHIFT + I` | Fingerabdruck-Auth toggeln |

## Web App Bindings

| Binding | App |
|---------|-----|
| `SUPER + A` | ChatGPT |
| `SUPER SHIFT + A` | Grok |
| `SUPER + C` | HEY Calendar |
| `SUPER + E` | HEY Mail |
| `SUPER + Y` | YouTube |
| `SUPER SHIFT + G` | WhatsApp |
| `SUPER ALT + G` | Google Messages |
| `SUPER + X` | X/Twitter |
| `SUPER SHIFT + X` | X/Twitter Post verfassen |

## Monitor-Layout Bindings

| Binding | Aktion |
|---------|--------|
| `SUPER + F7` | Work-Monitor-Layout anwenden (3 Monitore) |
| `SUPER + F8` | Home-Monitor-Layout anwenden (Laptop + Xiaomi) |

## split-monitor-workspaces Bindings

> Voraussetzung: Plugin `split-monitor-workspaces` ist geladen.

| Binding | Aktion |
|---------|--------|
| `SUPER + 1..0` | Zu Workspace 1–10 auf dem aktuellen Monitor wechseln |
| `SUPER SHIFT + 1..0` | Fenster zu Workspace 1–10 auf dem aktuellen Monitor verschieben |
| `SUPER + Tab` | Nächster Workspace (auf aktuellem Monitor) |
| `SUPER SHIFT + Tab` | Vorheriger Workspace (auf aktuellem Monitor) |
| `SUPER SHIFT + N` | Fokus auf nächsten Monitor |
| `SUPER SHIFT + M` | Fokus auf vorherigen Monitor |

### Deaktivierte Omarchy-Defaults

Damit `split-workspace` korrekt funktioniert, wurden die Omarchy-Standard-Workspace-Bindings (`SUPER + code:10..19` und `SUPER TAB`) vorher mit `unbind` entfernt.

### Zurückgesetzte Bindings

| Binding | Aktion |
|---------|--------|
| `SUPER + G` | Signal entfernt; explizit `togglegroup` (Toggle window grouping) |

**Wichtig (2026-08-13):** Nur `unbind = SUPER, G` reicht **nicht**. Der Omarchy-Default aus `tiling-v2.conf` wird dadurch entfernt und kehrt nicht zurück. In `bindings.conf` muss danach stehen:

```conf
unbind = SUPER, G
bindd = SUPER, G, Toggle window grouping, togglegroup
```

Hinweis: `SUPER ALT + G` ist bei uns Google Messages und überschreibt damit Omarchys `moveoutofgroup`.
