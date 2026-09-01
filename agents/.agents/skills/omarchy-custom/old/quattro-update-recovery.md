# Quattro-Update (3.8.2 → 4.0.2) – Recovery-Playbook

Update durchgeführt am **2026-09-01**. Diese Datei ist der Arbeitsplan für die Nacharbeiten. Sie enthält die vorher bekannten Bruchstellen, die Fixes und die Verifikations-Checkliste.

## Grundregeln für die Nacharbeit

- Immer zuerst den tatsächlichen Zustand prüfen, nicht annehmen: `hyprctl configerrors`, `hyprctl plugin list`, `git -C ~/dotfiles status`.
- Update-Log liegt unter `/tmp/omarchy-update.log` (wird bei jedem Update-Lauf überschrieben).
- Migrationen, die durch Symlinks ins dotfiles-Repo geschrieben haben, sichtbar machen: `git -C ~/dotfiles status` + `git -C ~/dotfiles diff`.
- **Keine Panik-Refactoren.** Erst System lauffähig machen, dann Aufräumen.

## Wenn der Desktop komplett kaputt ist

1. TTY: `Strg+Alt+F3` – dort funktioniert alles (Terminal, git, pacman, Editor).
2. Update fortsetzen/reparieren: `sudo pacman -Syu`, dann `omarchy migrate` für übersprungene Migrationen.
3. Notnagel: Snapper-Snapshot über das Limine-Bootmenü (`limine-snapper-restore`). Snapshot wurde vom Update automatisch erstellt (`omarchy-snapshot create` vor dem Update).
4. Der Agent (Kimi Code) braucht nur: Node via mise (`~/.local/share/mise/`), Config `~/.kimi-code/`, Skills `~/.agents/`. Läuft auch im TTY.

## Bekannte Bruchstellen und Fixes (Priorität)

### 1. `hyprland.conf` sourcet ins Leere (erwartet, kritisch)

Omarchy 4.0.2 hat alle Defaults auf Lua umgestellt (`~/.local/share/omarchy/default/hypr/*.lua`). Die `source =`-Zeilen auf `*.conf`-Defaults in `~/dotfiles/hyprland/.config/hypr/hyprland.conf` zeigen ins Nichts:

- `default/hypr/autostart.conf`, `bindings/media.conf`, `bindings/clipboard.conf`, `bindings/tiling-v2.conf`, `bindings/utilities.conf`, `envs.conf`, `looknfeel.conf`, `input.conf`, `windows.conf`

**Fix:** Prüfen, ob eine Migration die User-Config bereits konvertiert/ersetzt hat (`git -C ~/dotfiles diff`, `cat ~/.config/hypr/hyprland.conf`, ggf. neue Dateien wie `hyprland.lua`). Sonst `hyprland.conf` auf die neue Struktur umbauen: Defaults kommen aus den Lua-Dateien, eigene Overrides bleiben möglichst in den eigenen Dateien. Danach `hyprctl reload` + `hyprctl configerrors` bis sauber.

### 2. split-monitor-workspaces (erwartet, kritisch)

- Das `.so` (`~/.config/hypr/plugins/libsplit-monitor-workspaces.so`) war gegen Hyprland **0.56.2** (Pin `b28df0d`) gebaut und überlebt ein Hyprland-Update nicht (ABI).
- **Symptom:** `hyprctl plugin list` zeigt es nicht; Config-Errors `Invalid dispatcher "split-workspace"`; Workspace-Bindings tot.
- **Fix:** Neu bauen – Vorgehen steht in [split-monitor-workspaces.md](./split-monitor-workspaces.md) (Pin für die neue Hyprland-Version aus `hyprpm.toml` im Plugin-Repo nachschlagen). Version vorher prüfen: `pacman -Q hyprland`.
- **Zusätzlich prüfen:** Ob das Plugin mit der Lua-Config-Ära noch kompatibel ist und wie `plugin =` / `plugin {}`-Block in 4.0 eingebunden werden (Defaults sind jetzt Lua; eigene conf-Dateien werden evtl. nicht mehr gesourcet).
- **Fallback:** Wenn es keinen kompatiblen Pin gibt: `split-workspace`-Bindings in `bindings.conf` auf Standard-`workspace`/`movetoworkspace` zurückstellen und die `unbind`-Zeilen der Omarchy-Defaults entfernen.

### 3. Bindings mit toten Kommandos

In `~/dotfiles/hyprland/.config/hypr/bindings.conf`:

| Binding | Problem | Fix |
|---------|---------|-----|
| `SUPER + Q` | `walker -m clipboard` – Walker ist entfernt | Natives Clipboard in 4.0: `SUPER + CTRL + V`. Binding entfernen oder auf neue CLI mappen |
| `SUPER SHIFT + S` | `omarchy capture screenshot smart copy` | Prüfen, ob die CLI-Signatur in 4.0 noch stimmt (`omarchy capture --help`) |
| `SUPER SHIFT + I` | `omarchy-toggle-fingerprint` | Existenz prüfen: `omarchy commands` / `which omarchy-toggle-fingerprint` |
| `SUPER + M/O/A/E/C/Y/...` | `omarchy-launch-webapp`, `omarchy-launch-or-focus*` | Namen in 4.0 prüfen (`omarchy commands`), ggf. umbiegen |
| `SUPER + Return` etc. | `omarchy-cmd-terminal-cwd`, `xdg-terminal-exec`, `uwsm-app` | Existenz prüfen |

### 4. Waybar ist weg (erwartet)

- Waybar/Walker/Mako/SwayOSD/hyprlock/hypridle existieren in 4.0 nicht mehr; die Shell ist Quickshell.
- Die Custom-Waybar-Config (`~/dotfiles/waybar/`) bleibt als Referenz erhalten, hat aber keine Wirkung.
- **Fix:** Gewünschte Anpassungen über `~/.config/omarchy/shell.toml` (machine-level Override, wird live beobachtet) und ggf. Bar-Plugins nachbauen. Besonders: Workspace-Anzeige pro Monitor (bisher `all-outputs: false` + Icons 1–100), Wetter, Update-Indikator.
- `omarchy restart waybar`-Aufrufe in `workspace-setup.sh` laufen ins Leere → entfernen.

### 5. workspace-setup.sh / monitor-watch.sh

- `workspace-setup.sh` schreibt `monitors.conf` und nutzt `hyprctl keyword monitor` + `hyprctl reload` – sollte weiter funktionieren, solange Hyprland `monitors.conf` parst. Nach dem Update mit `workspace-setup.sh work` bzw. `home` verifizieren (`hyprctl monitors` gegen die dokumentierten Positionen in [hyprmon.md](./hyprmon.md)).
- Achtung: 4.0 bringt „much-improved clamshell operations" und `workspace-layouts.lua` in den Defaults – prüfen, ob Omarchy die Monitor-Verwaltung jetzt selbst übernimmt und mit dem Skript kollidiert.
- `monitor-watch.sh` war vor dem Update deaktiviert (auskommentiert in `autostart.conf`) – bleibt so, bis geklärt ist, ob es unter 4.0 noch nötig ist.
- Waybar-Restart-Block im Skript entfernen (siehe Punkt 4); Race-Condition-Fix aus [workspace-setup.md](./workspace-setup.md#waybar-restart-race-condition) ist damit hinfällig.

### 6. Themes

- Aktiv vor dem Update: **vantablack** (Stock) – geringes Risiko.
- Eigene Themes (azure-glow, monochrome, monochrome-round) sind im alten Format (waybar.css, mako.ini, walker.css, hyprlock.conf, swayosd.css). 4.0 nutzt semantische Farben (24 statt 8) und generiert btop/nvim/vscode aus dem Theme.
- **Fix:** Erst wenn gewünscht – aus `colors.toml` ein Theme im neuen Format bauen; Referenz: Stock-Themes unter `~/.local/share/omarchy/themes/`.
- Prüfen: `~/.config/omarchy/current/theme` und `background`-Symlink zeigen noch auf Existierendes.

### 7. Symlink-/Migrations-Seiteneffekte

- Migrationen können durch die Symlinks in `~/.config/hypr/` und `~/.config/waybar/` ins dotfiles-Repo geschrieben oder Symlinks durch echte Dateien ersetzt haben.
- **Fix:** `git -C ~/dotfiles status`; ersetzte Symlinks neu setzen; durchgeschriebene Änderungen reviewen (`git diff`) und ggf. committen oder verwerfen.

### 8. Was voraussichtlich einfach weiter funktioniert

- `focus_on_activate = false` (looknfeel.conf) – Hyprland-Setting.
- Keyboard: `wtype @` Binding, `lv3:rwin_switch` für Keychron K4 (input.conf).
- Hermes / Voicermoyzer `.desktop`-Einträge (neuer Launcher indexiert .desktop-Dateien).
- `.bashrc` (Z_AI_API_KEY) – kein Symlink, kein Migrations-Ziel erwartet.
- Kanshi, OpenDeck, netbird-autostart.

## Verifikations-Checkliste (nach dem Update, in Reihenfolge)

1. `omarchy version` – ist 4.0.2 installiert?
2. `hyprctl configerrors` – leer?
3. `hyprctl plugin list` – split-monitor-workspaces geladen?
4. `hyprctl monitors` – Layout stimmt (Positionen lt. hyprmon.md)?
5. `git -C ~/dotfiles status` – Symlinks intakt, keine unerwarteten Änderungen?
6. `omarchy commands | wc -l` – CLI lebt; toten Binding-Kommandos aus Punkt 3 gegenprüfen.
7. Workspace-Wechsel `SUPER + 1..0` und `SUPER SHIFT + 1..0` auf allen Monitoren testen.
8. `SUPER + F7` / `SUPER + F8` (work/home-Layout) testen.
9. Bar: läuft die neue Quickshell-Bar? Workspace-Anzeige pro Monitor korrekt?
10. `@` via `ALT + L` und `[`/`]` via rechter Command testen.
11. Lockscreen / Idle-Verhalten einmal testen (4.0 ersetzt hyprlock/hypridle durch die Shell).
12. Snapshot-Einträge im Limine-Bootmenü prüfen (nächster Reboot).

## Stand vor dem Update (Referenzwerte)

- Omarchy 3.8.2, Hyprland 0.56.2-1, hyprutils 0.14.1-1
- Plugin: `libsplit-monitor-workspaces.so` vom 2026-08-20, Pin `b28df0d`
- Aktives Theme: vantablack; aktives Layout: work (3 Monitore + Laptop)
- Migrationen lokal gelaufen: 326 (Stand: `~/.local/state/omarchy/migrations/`)
- pacman-Sync-DB zuletzt: 2026-08-14; letztes Full-Upgrade: 2026-08-19
