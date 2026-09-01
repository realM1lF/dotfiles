---
name: omarchy-custom
description: >
  Dokumentation aller manuellen Omarchy-Anpassungen und Customizations.
  Use when the user asks about custom dotfiles, monitor setup, bindings, waybar, themes, keyboard, or workspace behavior on this system.
  Use together with the omarchy skill for end-user customization tasks.
user-invokable: true
---

# Omarchy Custom Edits Tracker

Dieser Skill dokumentiert alle manuellen Anpassungen am Omarchy-System, die über die Standardkonfiguration hinausgehen. Er dient als zentrale Quelle, um bei zukünftigen Updates oder Troubleshooting zu wissen, was wo angepasst wurde.

## Struktur

Jedes Thema hat eine eigene Datei im selben Verzeichnis:

| Datei | Thema |
|-------|-------|
| [hyprmon.md](./hyprmon.md) | Monitor-Konfiguration (ersetzt gepatchtes hyprmon) |
| [workspace-setup.md](./workspace-setup.md) | Auto-Switch zwischen work- und home-Monitor-Layout |
| [split-monitor-workspaces.md](./split-monitor-workspaces.md) | Hyprland-Plugin für getrennte Workspaces pro Monitor |
| [dotfiles.md](./dotfiles.md) | Symlinks von `~/.config/` zum `~/dotfiles/`-Repo + Hermes Desktop `.desktop` Eintrag |
| [shell-env.md](./shell-env.md) | Umgebungsvariablen und API-Keys in `~/.bashrc` |
| [keyboard.md](./keyboard.md) | Mac-Tastatur-Anpassungen (`@` auf `Option + L`, eckige Klammern auf rechter Command) |
| [window-focus.md](./window-focus.md) | Globales Deaktivieren von `focus_on_activate` (kein Fokus-Klau durch Fenster) |
| [bindings.md](./bindings.md) | Benutzerdefinierte Hyprland-Bindings für Apps, Web-Apps und Workspaces |
| [waybar.md](./waybar.md) | Custom Waybar-Config für 3-Monitor-Setup und split-monitor-workspaces |
| [monitor-watch.md](./monitor-watch.md) | Script zum Fixen von Workspaces nach Docking-Station-Reconnect |
| [themes.md](./themes.md) | Eigene Omarchy-Themes (azure-glow, monochrome, monochrome-round) |
| [voicermoyzer.md](./voicermoyzer.md) | Walker-App für das lokale Dub-Studio (Desktop-Eintrag, kein Binding) |
| [quattro-update-recovery.md](./quattro-update-recovery.md) | Recovery-Playbook für das Update 3.8.2 → 4.0.2: Bruchstellen, Fixes, Checkliste |

## Grundregel

Wenn eine Datei in `~/.config/` ein Symlink zu `~/dotfiles/` ist, **muss die bearbeitete Quelle** in `~/dotfiles/` liegen, sonst geht der Link kaputt oder die Änderung wird nicht persistiert.

## Erweitern

Neue Themen einfach als separate `.md`-Datei im selben Verzeichnis anlegen und oben in die Tabelle eintragen.
