# Workspaces-Widget (Bar) – rin.workspaces

## Problem mit dem Stock-Widget

Das Omarchy-4-Stock-Widget `omarchy.workspaces` passt nicht zu [split-monitor-workspaces](./split-monitor-workspaces.md):

- Es zeigt nur Workspace-IDs **1–10** an (hardcodiert) – die Workspaces des zweiten Monitors (11–20) fehlen komplett.
- Highlight nur über `Hyprland.focusedWorkspace` (global) – auf dem anderen Monitor wird nichts markiert.
- Alle Bars zeigen dieselbe Liste, egal auf welchem Monitor.

## Lösung: geklontes Widget

Das Widget wurde mit `omarchy plugin clone omarchy.workspaces` geklont und umgebaut. Es liegt im dotfiles-Repo:

| Symlink | Ziel in `~/dotfiles/` |
|---------|----------------------|
| `~/.config/omarchy/plugins/rin.workspaces` | `omarchy/.config/omarchy/plugins/rin.workspaces` |

Die Bar nutzt es automatisch – `omarchy plugin clone` hat in `~/.config/omarchy/shell.json` die ID `omarchy.workspaces` durch `rin.workspaces` ersetzt (shell.json selbst ist **nicht** im dotfiles-Repo).

## Was das Widget anders macht (`Workspaces.qml`)

- **Monitor-Bezug:** über die attached Property `root.QsWindow.window.screen.name` erkennt jede Bar-Instanz ihren Monitor (es gibt eine Bar pro Monitor, das Widget selbst bekommt keinen screen-Parameter injiziert).
- **Pro Monitor nur eigene Workspaces:** Filter über `ws.monitor.name === screenName`. Da split-monitor-workspaces alle Workspaces persistent anlegt, sind immer genau die 10 des jeweiligen Monitors sichtbar.
- **Labels 1–0 pro Monitor:** Workspace 11–20 werden als 1–0 dargestellt (`((id - 1) % 10) + 1`).
- **Highlight pro Monitor:** Vergleich mit `monitor.activeWorkspace` (aus `Hyprland.monitors`) statt `Hyprland.focusedWorkspace` – jede Bar markiert den auf *ihrem* Monitor aktiven Workspace.
- **Klick:** fokussiert die absolute Workspace-ID via `hl.dsp.focus({ workspace = "<id>" })` – funktioniert monitorübergreifend.
- **Fallback:** Solange `screenName` leer ist (Bar noch nicht attached), zeigt es wie das Stock-Widget 1–10.

## Hinweise

- Änderungen an der `.qml`-Datei hot-reloaden automatisch; falls nicht: `omarchy-shell shell rescanPlugins`.
- Nie das Stock-Widget unter `/usr/share/omarchy/shell/plugins/` bearbeiten – wird bei Updates überschrieben.
- Verifizieren per Screenshot: `omarchy capture screenshot fullscreen save`, dann die Bar oben links prüfen.
