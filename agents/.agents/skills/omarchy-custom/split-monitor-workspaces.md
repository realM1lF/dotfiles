# split-monitor-workspaces – Workspace-Split pro Monitor

## Quelle

`https://github.com/zjeffer/split-monitor-workspaces`

## Was macht es?

Jeder physische Monitor bekommt eigene Workspace-Gruppen. Mit 2 Monitoren und `workspace_count = 10` hat Monitor 1 die Workspaces 1–10, Monitor 2 die 11–20. Workspaces wandern beim Monitor-Wechsel nicht mit.

## Wichtig: Seit Omarchy 4 als Lua-Package

Omarchy 4 nutzt die Lua-Config von Hyprland (`hyprland.lua`). Das Plugin existiert dafür als **Lua-Package** – das alte C++-Plugin (`.so`, kompilieren, ABI-Probleme) ist damit hinfällig. Das alte Vorgehen liegt in [old/](./old/) (siehe `quattro-update-recovery.md`).

## Installation

| Komponente | Pfad |
|------------|------|
| Lua-Package (git-Clone, Branch `release/0.56.x`) | `~/.config/hypr/plugins/split-monitor-workspaces` |
| Einbindung + Bindings | `~/dotfiles/hyprland/.config/hypr/bindings.lua` (via Symlink) |

```bash
git clone https://github.com/zjeffer/split-monitor-workspaces \
  ~/.config/hypr/plugins/split-monitor-workspaces
cd ~/.config/hypr/plugins/split-monitor-workspaces
git checkout release/0.56.x   # Branch passend zur Hyprland-Version (0.56.x bei Hyprland 0.56.2)
```

Der Clone liegt **nicht** im dotfiles-Repo. Bei einem Hyprland-Minor-Update: `git pull` im Plugin-Verzeichnis; bei neuem Major-Release (0.57, ...) auf den passenden `release/0.XX.x`-Branch wechseln.

## Einbindung in `bindings.lua`

```lua
package.path = package.path .. ";./?.lua;./?/init.lua"
local smw_ok, smw = pcall(require, "plugins.split-monitor-workspaces")
```

Der `pcall` ist Absicht: Fehlt das Package, bleiben die Omarchy-Default-Bindings aktiv und es gibt nur eine Notification statt einer kaputten Config.

## Konfiguration (`smw.setup`)

| Option | Wert | Bedeutung |
|--------|------|-----------|
| `workspace_count` | `10` | Workspaces pro Monitor |
| `keep_focused` | `false` | Fokus nach Reload nicht explizit setzen |
| `enable_notifications` | `true` | Popup bei Workspace-Wechsel |
| `enable_persistent_workspaces` | `true` | Alle Workspaces sofort erstellen |
| `enable_wrapping` | `false` | Kein Wrap-around beim Cyclen |

## Bindings (in `bindings.lua`)

| Binding | Aktion |
|---------|--------|
| `SUPER + 1..0` | Workspace 1–10 auf dem aktuellen Monitor |
| `SUPER SHIFT + 1..0` | Fenster dorthin verschieben (silent) |
| `SUPER + TAB` / `SUPER SHIFT + TAB` | Nächster/vorheriger Workspace (dieser Monitor) |
| `SUPER SHIFT + N` / `SUPER SHIFT + M` | Fokus nächster/vorheriger Monitor (Standard-Dispatcher `focus monitor ±1`) |

Vorher werden die Omarchy-Defaults entbunden: `SUPER + code:10..19`, `SUPER SHIFT + code:10..19`, `SUPER + TAB`, `SUPER SHIFT + TAB`. Außerdem `SUPER SHIFT + N` (Default: Editor) und `SUPER SHIFT + M` (Default: Music).

## Verifikation

```bash
hyprctl configerrors      # muss leer sein
hyprctl workspaces        # persistente Workspaces 1–10 pro Monitor sichtbar
hyprctl binds | grep -A6 "this monitor"
```

> Hinweis: Lua-gebundene Dispatcher erscheinen in `hyprctl binds` als `dispatcher: __lua` – das ist normal.

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| Workspace-Bindings tot, Defaults aktiv | Package fehlt/Requirement-Fehler → `hyprctl configerrors`, Clone + Branch prüfen |
| Nach Hyprland-Update seltsames Verhalten | `git -C ~/.config/hypr/plugins/split-monitor-workspaces pull`, ggf. Branch wechseln |
| Workspaces wandern trotzdem | `enable_persistent_workspaces = true` gesetzt? |
