# Hermes Desktop

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

Nach dem Setup erscheint "Hermes" im App-Launcher.

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
