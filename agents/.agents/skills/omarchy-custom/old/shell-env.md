# Shell-Umgebung – Umgebungsvariablen & API-Keys

Diese Datei dokumentiert manuelle Änderungen an der Shell-Konfiguration, die über die Omarchy-Standardkonfiguration hinausgehen.

## `~/.bashrc`

**Wichtig:** `~/.bashrc` ist auf diesem System **kein Symlink** zu `~/dotfiles/`. Änderungen müssen direkt in `~/.bashrc` erfolgen und werden nicht automatisch vom `dotfiles/`-Repo erfasst.

### Z AI API-Key für GLM-Modell

- **Datei:** `~/.bashrc`
- **Änderung:** Export der Umgebungsvariable für den Z AI API-Key, der für das GLM-Modell verwendet wird.
- **Format in `.bashrc` (Beispiel):**

```bash
export Z_AI_API_KEY="<key>"
```

> **Hinweis:** Der tatsächliche Key wird hier nicht dokumentiert. Er befindet sich nur in der lokalen `~/.bashrc`.

### Regel für zukünftige Edits

- Umgebungsvariablen für API-Keys oder Tools gehören in die `~/.bashrc`.
- Keys niemals in Git-Repos oder Skill-Dokumentationen speichern.
- Nach Änderungen an `~/.bashrc` entweder neu einloggen oder `source ~/.bashrc` ausführen.
