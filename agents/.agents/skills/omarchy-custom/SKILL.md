---
name: omarchy-custom
description: >
  Dokumentation aller manuellen Omarchy-Anpassungen und Customizations.
  Use when the user asks about custom dotfiles, monitor setup, bindings, or workspace behavior on this system.
  Use together with the omarchy skill for end-user customization tasks.
user-invokable: true
---

# Omarchy Custom Edits Tracker

Dieser Skill dokumentiert alle manuellen Anpassungen am Omarchy-System (aktuell: **Omarchy 4**, Lua-Config), die über die Standardkonfiguration hinausgehen. Er dient als zentrale Quelle, um bei zukünftigen Updates oder Troubleshooting zu wissen, was wo angepasst wurde.

## Struktur

Jedes Thema hat eine eigene Datei im selben Verzeichnis:

| Datei | Thema |
|-------|-------|
| [workspace-setup.md](./workspace-setup.md) | Auto-Switch zwischen work- und home-Monitor-Layout (schreibt `monitors.lua`), F7/F8-Bindings |
| [split-monitor-workspaces.md](./split-monitor-workspaces.md) | Lua-Package für getrennte Workspaces pro Monitor + Workspace-Bindings |
| [workspaces-widget.md](./workspaces-widget.md) | Bar-Widget `rin.workspaces`: Workspaces pro Monitor + aktives Highlight |
| [at-sign-binding.md](./at-sign-binding.md) | Cmd+Q tippt `@` via `send_key_state` (Keychron K4 Mac-Modus hat kein AltGr) |
| [dotfiles.md](./dotfiles.md) | Stow-Symlinks von `~/.config/` zum `~/dotfiles/`-Repo |
| [rins-theme.md](./rins-theme.md) | User-Theme `Rins`: 1:1-Fork von Stock-Theme Solitude |
| [hermes.md](./hermes.md) | Hermes Desktop (Nous): User-Space unter `~/.hermes/`, XDG-Launcher |
| [rin-companion.md](./rin-companion.md) | Haus-Agent: Bar-Widget `rin.companion`, rules/soul/user/memory, Chat + Float |

## Archiv (`old/`)

Alte Dokumentation aus der Omarchy-3-Ära (Waybar, alte Themes, Keyboard-Hacks, Window-Focus, Hermes, Voicermoyzer, Recovery-Playbook für das 3.8.2→4.0.2-Update etc.) liegt im Unterverzeichnis [old/](./old/). Dort ist nichts mehr aktiv – nur Referenz.

## Grundregel

Wenn eine Datei in `~/.config/` ein Symlink zu `~/dotfiles/` ist, **muss die bearbeitete Quelle** in `~/dotfiles/` liegen, sonst geht der Link kaputt oder die Änderung wird nicht persistiert.

## Erweitern

Neue Themen einfach als separate `.md`-Datei im selben Verzeichnis anlegen und oben in die Tabelle eintragen.
