# Dotfiles – Symlinks & Custom Edits

Das `~/dotfiles/`-Repo ist die Quelle für diverse Konfigurationen in `~/` (GNU Stow). Änderungen an diesen Dateien **müssen** im `dotfiles/`-Repo erfolgen, da die Ziele nur Symlinks sind.

## Hyprland (`~/dotfiles/hyprland/.config/hypr/`) — Omarchy 4, Lua-Format

| Symlink in `~/.config/hypr/` | Ziel in `~/dotfiles/` |
|------------------------------|----------------------|
| `bindings.lua` | `hyprland/.config/hypr/bindings.lua` |
| `monitors.lua` | Quelle im Repo; **aktuell lokal** (`~/.config/hypr/monitors.lua` ist kein Symlink, workspace-setup schreibt lokal) |
| `autostart.lua` | `hyprland/.config/hypr/autostart.lua` |
| `companion.lua` | `hyprland/.config/hypr/companion.lua` |
| `scripts` | `hyprland/.config/hypr/scripts` |

Nicht gesymlinkt (bleiben lokale Omarchy-Dateien): `hyprland.lua`, `input.lua`, `looknfeel.lua`, `hyprsunset.conf`, `xdph.conf`.

`hyprland.lua` braucht eine Zeile `require("hypr.companion")` (Haus-Agent-Float). Siehe [rin-companion.md](./rin-companion.md).

### Wichtige Edits in diesen Dateien

- **monitors.lua** → wird von `workspace-setup.sh` generiert, siehe [workspace-setup.md](./workspace-setup.md)
- **autostart.lua** → Auto-Start von `workspace-setup.sh auto`
- **bindings.lua** → split-monitor-workspaces Setup + Workspace-Bindings + F7/F8 + `SUPER+SHIFT+A` Companion (statt ChatGPT), siehe [split-monitor-workspaces.md](./split-monitor-workspaces.md), [workspace-setup.md](./workspace-setup.md) und [rin-companion.md](./rin-companion.md)
- **scripts/workspace-setup.sh** → Monitor-Layout-Umschaltung, siehe [workspace-setup.md](./workspace-setup.md)

## SSH (`~/dotfiles/ssh/`)

| Symlink | Ziel in `~/dotfiles/` |
|---------|----------------------|
| `~/.ssh/config` | `ssh/.ssh/config` |

## Omarchy Shell-Plugins (`~/dotfiles/omarchy/`)

| Symlink | Ziel in `~/dotfiles/` |
|---------|----------------------|
| `~/.config/omarchy/plugins/rin.workspaces` | `omarchy/.config/omarchy/plugins/rin.workspaces` |
| `~/.config/omarchy/plugins/rin.companion` | `omarchy/.config/omarchy/plugins/rin.companion` |

Details: [workspaces-widget.md](./workspaces-widget.md), [rin-companion.md](./rin-companion.md). Hinweis: `~/.config/omarchy/shell.json` ist **kein** Symlink und nicht im Repo.

## Agent-Skills (`~/dotfiles/agents/`)

| Symlink | Ziel in `~/dotfiles/` |
|---------|----------------------|
| `~/.agents/skills/omarchy-custom` | `agents/.agents/skills/omarchy-custom` |

## Nicht installiert / Referenz

| Paket | Status |
|-------|--------|
| `opendeck/` | Paket vorhanden, derzeit nicht gestowt |
| `kanshi/` | Paket vorhanden, derzeit nicht gestowt (kanshi nicht installiert) |
| `scripts/` | Fingerprint-Toggle; derzeit nicht gestowt (braucht zusätzlich `system/install.sh` mit sudo) |
| `_old/` | Omarchy-3-Reste (alte `.conf`-Hyprland-Config, Waybar, Themes im alten Format) – **niemals stowen** |

## Regel für zukünftige Edits

> Wenn eine Datei in `~/.config/` ein Symlink auf `~/dotfiles/` ist: **Immer die Quelle in `~/dotfiles/` bearbeiten.**

Ausnahme `monitors.lua`: wird von `workspace-setup.sh` durch den Symlink hindurch beschrieben – Layout-Änderungen gehören ins Skript.

Neue Symlinks können mit `ls -la ~/.config/` geprüft werden.
