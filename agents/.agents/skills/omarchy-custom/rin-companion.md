# rin.companion — Haus-Agent

Bar-Widget + Float-Terminal für den System-Agenten auf **dieser** Omarchy-Box. Kein Hermes-Backend.

| | |
|---|---|
| Plugin-Quelle | `~/dotfiles/omarchy/.config/omarchy/plugins/rin.companion/` |
| Symlink | `~/.config/omarchy/plugins/rin.companion` → diese Quelle |
| Daten (nicht git) | `~/.local/share/rin-companion/` |
| Hypr-Regel | `~/dotfiles/hyprland/.config/hypr/companion.lua` |
| Hypr-Require (lokal) | `~/.config/hypr/hyprland.lua` → `require("hypr.companion")` |
| Bar-Slot | `~/.config/omarchy/shell.json` left, nach `rin.workspaces` (shell.json **nicht** im Repo) |

`omarchy plugin validate` verbietet Symlinks **im** Plugin-Ordner. Der Ordner selbst darf Symlink sein (wie `rin.workspaces`).

## Klicks

| Klick / Taste | Aktion |
|---|---|
| Links | Echte `agent`-TUI in foot. Zeigt auf **aktiven** Workspace (nicht special-toggle, Monitor-Falle). Hide = `special:companion` |
| Rechts | Panel: rules / soul / user / memory |
| Mitte | Dateien neu laden |
| `SUPER+SHIFT+A` | Gleicher Toggle wie Linksklick (`toggle.sh`). War Omarchy-Default ChatGPT-Webapp. |

Binding in `~/dotfiles/hyprland/.config/hypr/bindings.lua`: erst `hl.unbind("SUPER + SHIFT + A")`, dann `o.bind` auf Plugin-`toggle.sh`.

Icon: `Monkey.qml` 16x16, Bar + Chat-Hero. Mood `idle` / `think` solange `agent --print` läuft.

## Chat

Chat ist die interaktive CLI (`run.sh` → `agent`), nicht das QML-`--print`-Panel. Slash-Commands (`/`, Skills) nur dort. `chat.sh` bleibt im Plugin, Panel nutzt ihn nicht mehr. `rules.md` gilt über `AGENTS.md` + Workspace. TUI-Denken: `~/.config/cursor/cli-config.json` → `display.showThinkingBlocks`.

Kein `--force`. `--trust` nur Workspace-Prompt. Rechtsklick-TUI bleibt Extra.

## Dateien im Daten-Ordner

| Datei | Wer schreibt | Widget |
|---|---|---|
| `rules.md` | rin (standing MUST, wie shared-agents Rules) | ansehen + speichern |
| `soul.md` | rin (Agent nur auf ausdrückliche Bitte) | ansehen + speichern |
| `user.md` | rin | ansehen + speichern |
| `memory.md` | nur Agent | nur ansehen |
| `AGENTS.md` | Bootstrap aus Plugin-`templates/` | Agent-CLI liest das als Workspace-Root |

Muster: rules = hart immer an, soul = Haltung, user = Profil, memory = kurze Fakten (Ziel ~2200 Zeichen). **Nicht** nach `~/.cursor/rules/` linken (sonst alle Cursor-Chats). System-Wissen bleibt in `omarchy-custom/` + `~/.config/`.

`toggle.sh` kopiert fehlende Dateien aus `templates/`. Existierende Dateien bleiben.

## Agent-Float

`toggle.sh` startet einmal:

```bash
foot --app-id=rin-companion --title=rin-companion -D ~/.local/share/rin-companion -e run.sh
```

`run.sh`:

```bash
agent --workspace ~/.local/share/rin-companion --add-dir "$HOME" --trust --mode ask --resume "$(cat chat-id)"
```

Start immer `--mode ask` (nur lesen). Für Edits in der TUI auf Agent wechseln.

Fenster zu (kill) beendet nur den TUI-Prozess. Chat-ID bleibt. Nächster Start = derselbe Chat. Links-Toggle hide lässt den Prozess leben. Ohne `--resume` war jeder Spawn ein neuer Chat → wirkte inkonsistent.

Fenster-Regel (`companion.lua`): float, center, `900x620`, `workspace = "special:companion silent"`.

Rechtsklick danach: `hyprctl dispatch togglespecialworkspace companion`. Terminal zu = Session weg. Special hide = Session bleibt.

## Enable / Reload

```bash
omarchy plugin validate ~/dotfiles/omarchy/.config/omarchy/plugins/rin.companion
omarchy plugin enable rin.companion --section left --after rin.workspaces
# QML-Save hot-reloadt. Sonst:
omarchy-shell shell rescanPlugins
```

Nach Hypr-Edit: `hyprctl reload` + `hyprctl configerrors`.

`omarchy refresh hyprland` kann `hyprland.lua` zurücksetzen. Dann Require-Zeile wieder einfügen:

```lua
require("hypr.companion")
```

**Reihenfolge:** erst `companion.lua` linken, dann Require. Require ohne Datei = Hypr-Config-Fehler (ganze Datei).

**Nicht** `stow hyprland` blind. `~/.config/hypr/monitors.lua` ist lokal (kein Symlink). Stow würde konfliktieren. `companion.lua` einzeln linken.

## Nicht hier

- `soul.md` / `user.md` / `memory.md` / Sessions: nicht ins dotfiles-Repo
- Proaktiv-Daemon: später
- Pixel-Affe + Panel-Chat: da (`Monkey.qml`, `chat.sh`)
- `/usr/share/omarchy/`: nie schreiben
