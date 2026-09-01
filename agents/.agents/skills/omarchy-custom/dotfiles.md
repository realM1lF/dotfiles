# Dotfiles – Symlinks & Custom Edits

Das `~/dotfiles/`-Repo ist die Quelle für diverse Konfigurationen in `~/.config/`. Änderungen an diesen Dateien **müssen** im `dotfiles/`-Repo erfolgen, da die Dateien in `~/.config/` nur Symlinks sind.

## Hyprland (`~/dotfiles/hyprland/.config/hypr/`)

| Symlink in `~/.config/hypr/` | Ziel in `~/dotfiles/` |
|------------------------------|----------------------|
| `autostart.conf` | `hyprland/.config/hypr/autostart.conf` |
| `bindings.conf` | `hyprland/.config/hypr/bindings.conf` |
| `hyprland.conf` | `hyprland/.config/hypr/hyprland.conf` |
| `input.conf` | `hyprland/.config/hypr/input.conf` |
| `monitors.conf` | `hyprland/.config/hypr/monitors.conf` |
| `netbird-autostart.sh` | `hyprland/.config/hypr/netbird-autostart.sh` |
| `scripts` | `hyprland/.config/hypr/scripts` |

### Wichtige Edits in dieser Dateien

- **monitors.conf** → siehe [hyprmon.md](./hyprmon.md) und [workspace-setup.md](./workspace-setup.md)
- **autostart.conf** → Auto-Start von `workspace-setup.sh auto` – siehe [workspace-setup.md](./workspace-setup.md)
- **bindings.conf** → Tastenkürzel für Work/Home-Layout – siehe [bindings.md](./bindings.md)
- **scripts/workspace-setup.sh** → Monitor-Layout-Umschaltung – siehe [workspace-setup.md](./workspace-setup.md)

## Kanshi (`~/dotfiles/kanshi/.config/kanshi/`)

| Symlink in `~/.config/` | Ziel in `~/dotfiles/` |
|-------------------------|----------------------|
| `kanshi` | `kanshi/.config/kanshi` |

## Omarchy Themes (`~/dotfiles/omarchy/.config/omarchy/themes/`)

| Symlink in `~/.config/omarchy/themes/` | Ziel in `~/dotfiles/` |
|----------------------------------------|----------------------|
| `azure-glow` | `omarchy/.config/omarchy/themes/azure-glow` |
| `monochrome` | `omarchy/.config/omarchy/themes/monochrome` |
| `monochrome-round` | `omarchy/.config/omarchy/themes/monochrome-round` |

## OpenDeck (`~/dotfiles/opendeck/.config/opendeck/`)

| Symlink in `~/.config/` | Ziel in `~/dotfiles/` |
|-------------------------|----------------------|
| `opendeck` | `opendeck/.config/opendeck` |

## Waybar (`~/dotfiles/waybar/.config/waybar/`)

| Symlink in `~/.config/waybar/` | Ziel in `~/dotfiles/` |
|--------------------------------|----------------------|
| `config.jsonc` | `waybar/.config/waybar/config.jsonc` |
| `style.css` | `waybar/.config/waybar/style.css` |

### Backup-Dateien (können gelöscht werden)

- `config.jsonc.bak.1767866080`
- `config.jsonc.bak.1767867357`
- `config.jsonc.bak.1767867400`
- `style.css.bak.1767866080`

## Hermes Desktop

| Datei | Pfad |
|-------|------|
| Hermes.desktop | `~/.local/share/applications/Hermes.desktop` (nicht via Symlink — `.desktop` Datei direkt) |
| Icon | `~/.local/share/icons/hermes.png` (kopiert aus `~/.hermes/hermes-agent/apps/desktop/assets/icon.png`) |
| Binary | `~/.hermes/hermes-agent/apps/desktop/release/linux-unpacked/Hermes` |

### Setup

```bash
# .desktop Datei anlegen
mkdir -p ~/.local/share/applications ~/.local/share/icons
cp ~/.hermes/hermes-agent/apps/desktop/assets/icon.png ~/.local/share/icons/hermes.png
# Inhalt von Hermes.desktop siehe unten
update-desktop-database ~/.local/share/applications/
```

**Inhalt `~/.local/share/applications/Hermes.desktop`:**

```ini
[Desktop Entry]
Name=Hermes
Comment=Native desktop shell for Hermes Agent
Exec=/home/rin/.hermes/hermes-agent/apps/desktop/release/linux-unpacked/Hermes
Icon=/home/rin/.local/share/icons/hermes.png
Type=Application
Categories=Utility;Development;AI;
Terminal=false
StartupNotify=true
StartupWMClass=Hermes
```

Nach dem Setup erscheint "Hermes" im Walker-App-Launcher (SUPER+Space bzw. Omarchy-Standard-Binding).

## Hermes Agent Source-Code Workarounds

Diese Änderungen liegen **nicht** in `~/dotfiles/`, sondern direkt im Hermes-Installationsverzeichnis unter `~/.hermes/hermes-agent/`. Sie sind Workarounds für Upstream-Bugs, die noch nicht offiziell gefixt sind.

### Z.AI / GLM Coding Plan – false HTTP 429 (#47685)

**Problem:** Der Z.AI-Endpunkt `https://api.z.ai/api/coding/paas/v4` (Modell `glm-5.2`) liefert fälschlich HTTP 429 / Code `1305`, wenn der System-Prompt den exakten Text `"Hermes Agent"` enthält. Hermes’ Default-System-Prompt enthält diesen Text zweimal.

**Workaround:** Vor dem Senden an Z.AI wird `"Hermes Agent"` durch `"Hermes framework"` ersetzt.

**Geänderte Dateien:**

| Datei | Änderung |
|-------|----------|
| `~/.hermes/hermes-agent/agent/message_sanitization.py` | Neue Funktion `_sanitize_system_prompt_for_provider()` |
| `~/.hermes/hermes-agent/agent/conversation_loop.py` | Sanitizer im Haupt-Chat-Pfad aufrufen |
| `~/.hermes/hermes-agent/agent/chat_completion_helpers.py` | Sanitizer im Summary-Pfad aufrufen |

**Konfiguration:**

| Datei | Änderung |
|-------|----------|
| `~/.hermes/.env` | `GLM_BASE_URL=https://api.z.ai/api/coding/paas/v4` gesetzt, um die langsame Z.AI-Endpoint-Auto-Detection zu überspringen |
| `~/.hermes/auth.json` | Credential-Pool-Status für `zai` zurückgesetzt, nachdem er durch 429/401 als `exhausted` markiert war |

### Was passiert beim Hermes-Update?

Hermes-Updates überschreiben Dateien unter `~/.hermes/hermes-agent/`. Das betrifft auch die drei geänderten `.py`-Dateien. Konkret:

- **Wenn der Upstream-Fix für Issue #47685 im Update enthalten ist:** Alles bleibt funktional, der Workaround wird durch den offiziellen Fix ersetzt.
- **Wenn der Fix noch nicht enthalten ist:** Überschreibt das Update die drei Dateien und der 429-Fehler kommt bei Verwendung von `zai/glm-5.2` zurück.
- **`.env` und `auth.json` bleiben in der Regel erhalten**, solange nicht explizit migriert wird. `GLM_BASE_URL` sollte also bestehen bleiben.

**Empfehlung:** Nach einem Hermes-Update kurz mit `glm-5.2` testen. Falls der 429 wieder auftritt, muss der Workaround neu eingespielt werden (oder auf Kimi wechseln, bis Upstream fixt).

## Regel für zukünftige Edits

> Wenn eine Datei in `~/.config/` ein Symlink auf `~/dotfiles/` ist: **Immer die Quelle in `~/dotfiles/` bearbeiten.**

Neue Symlinks können mit `ls -la ~/.config/` geprüft werden.
