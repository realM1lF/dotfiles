# Voicermoyzer als Omarchy-App

Voicermoyzer erscheint im Walker-Launcher (SUPER + Space) wie Hermes oder ChatGPT. Kein Hyprland-Binding. Keine Änderung an `~/.config/hypr/` oder `~/.local/share/omarchy/`.

## Lebenszyklus

| Aktion | Verhalten |
|--------|-----------|
| Öffnen | Startet API (`:8000`) und Vite (`:5180`) falls nötig, dann Chromium `--app` |
| Nochmal öffnen | Fokussiert das bestehende Fenster. Startet nichts zweites |
| Fenster schließen | Beendet API und Vite. Nichts bleibt auf 8000/5180 |

Chromium läuft mit eigenem `--user-data-dir` unter `data/chromium-profile`. Der Prozess bleibt bis das Fenster zu ist. Danach enden API und Vite. Ohne eigenes Profil gibt Chromium `--app` sofort ab; der Dateidialog (Nautilus) ließ das Skript die Server killen, Upload wirkte tot.

Mikrofon: `--app` zeigt oft keinen Permission-Dialog. Das Skript setzt `media_stream_mic` auf Allow für `http://127.0.0.1:5180`. Kein `--use-fake-ui-for-media-stream`: Chromium zeigt sonst die Infobar „unsupported command-line flag“.

Start-Hänger: Totes `SingletonLock` im Profil plus Chromium-Crash. Nächster Start war sofort wieder tot, Skript killte API/Vite. `omarchy-open.sh` löscht tote Locks und wartet auf Fenster, nicht nur auf den Wrapper-PID.

Aufnahme sitzt im dritten Schritt. Zuschnitt → Weiter zur Tonspur → nach der Analyse die Kabine. Der Stepper ist nicht klickbar.

Nicht parallel zu `./dev.sh` nutzen. Schließen der App beendet dieselben Ports.

## Start: worauf achten

- Einmal Setup aus dem README (`venv`, `npm install`, `ffmpeg`)
- Erster Start kann ein paar Sekunden dauern (Vite)
- Erstes Analysieren lädt Modelle, das dauert und braucht RAM
- Standardbrowser ist Zen. Die App läuft trotzdem in Chromium `--app` (Omarchy-Webapp-Weg)

## Wie es läuft

Walker startet `scripts/omarchy-open.sh`:

1. Prüft `backend/.venv` und `frontend/node_modules`
2. Hängt `mise bin-paths` an `PATH`
3. Existiert das App-Fenster: nur fokus, Exit
4. Sonst Server starten, auf HTTP warten, Chromium `--app` öffnen
5. Fenster weg: `uvicorn` / `vite` / `npm run dev` aus diesem Repo beenden

Port belegt ohne Health-Antwort: Abbruch, kein Kill fremder Prozesse.

Logs: `~/Work/_private/voicermoyzer/data/omarchy-backend.log` und `omarchy-frontend.log` (`data/` ist gitignored).

## Dateien

| Datei | Pfad |
|-------|------|
| Launcher-Skript | `~/Work/_private/voicermoyzer/scripts/omarchy-open.sh` |
| Desktop-Eintrag | `~/.local/share/applications/Voicermoyzer.desktop` |
| Icon | `~/.local/share/applications/icons/Voicermoyzer.png` (aus `frontend/public/favicon.svg`) |

Kein Symlink nach `~/dotfiles/`. Wie Hermes: `.desktop` liegt direkt unter `~/.local/share/applications/`.

## Entfernen

```bash
rm -f ~/.local/share/applications/Voicermoyzer.desktop
rm -f ~/.local/share/applications/icons/Voicermoyzer.png
update-desktop-database ~/.local/share/applications/
```

Skript im Repo kann bleiben.

## Nicht anfassen

- `~/.local/share/omarchy/`
- `~/dotfiles/hyprland/.config/hypr/bindings.conf` (kein Hotkey)
- Bestehende Web-App-`.desktop`-Dateien
