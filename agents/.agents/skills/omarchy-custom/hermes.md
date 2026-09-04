# Hermes Desktop (Nous Research)

User-Space-Install. Kein `/usr/share/omarchy/`, kein pacman, kein Hyprland-Edit.

| Was | Pfad |
|-----|------|
| Agent + Data | `~/.hermes/` |
| Source / venv | `~/.hermes/hermes-agent/` |
| CLI | `~/.local/bin/hermes` |
| Desktop binary | `~/.hermes/hermes-agent/apps/desktop/release/linux-unpacked/Hermes` |
| Launcher | `~/.local/share/applications/hermes.desktop` (offiziell via `hermes desktop`) |
| Icons | `~/.local/share/icons/hicolor/*/apps/hermes.png` |

Version beim Setup: Hermes Agent v0.21.0 (2026.8.31), Install-Methode `git`.

## Install (so gemacht)

Offizielle `install.sh` zuerst gelesen, dann lokal ausgeführt. Nicht `curl | bash`.

```bash
# 1. CLI, nur Home, kein Setup-Wizard
bash /tmp/hermes-install.sh --skip-setup --non-interactive

# 2. Desktop packen + XDG-Entry (kein Launch)
hermes desktop --build-only
```

Flags bewusst **nicht** genutzt:

- `--include-desktop` im Installer: würde `sudo chown` auf `chrome-sandbox` versuchen
- `--skip-browser`: Playwright-Chromium liegt in `~/.cache/ms-playwright/` (User-Cache)

Sandbox: User-Namespaces funktionieren. `chrome-sandbox` bleibt user-owned, **kein** setuid. `hermes desktop` nutzt userns (`--disable-setuid-sandbox`). Kein sudo.

## Start

```bash
hermes desktop          # baut nur wenn Stamp mismatch
hermes desktop --skip-build
```

Oder App-Launcher: **Hermes**.

Erstkonfig (API-Key / Nous Portal): in der App oder `hermes setup`.

## Update / Uninstall

```bash
hermes update                 # Agent (überschreibt ~/.hermes/hermes-agent)
hermes desktop --build-only   # Desktop neu packen nach Update
hermes uninstall --gui        # nur Desktop-Entry + App
hermes uninstall              # Agent, Config bleibt
hermes uninstall --full       # alles inkl. ~/.hermes
```

## Nicht angefasst

- `/usr/share/omarchy/`
- `~/.config/hypr/`
- `~/.config/omarchy/`
- `~/.bashrc` (`~/.local/bin` war schon auf PATH)
- System-Python / System-Node (Python 3.11 via uv unter `~/.hermes`)

HUD auf Hyprland/Omarchy: Upstream floater via Hypr-IPC. Keine extra Window-Rule.

Alte Omarchy-3-Notes + Source-Workarounds: [old/hermes.md](./old/hermes.md).
