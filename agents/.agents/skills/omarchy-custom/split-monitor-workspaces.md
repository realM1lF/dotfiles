# split-monitor-workspaces – Hyprland Plugin

## Quelle

`https://github.com/zjeffer/split-monitor-workspaces`

## Was macht es?

Das Plugin erzeugt pro physischem Monitor eigene Workspace-Gruppen. Mit 3 Monitoren und `count = 10` bekommt jeder Monitor 10 Workspaces (1–10, 11–20, 21–30). Das verhindert, dass Workspaces beim Monitor-Wechsel automatisch mitwandern.

## Installation

| Komponente | Pfad |
|------------|------|
| Plugin-Binary | `~/.config/hypr/plugins/libsplit-monitor-workspaces.so` |
| Hyprland-Config | `~/dotfiles/hyprland/.config/hypr/hyprland.conf` (via Symlink) |

### Plugin laden (in `hyprland.conf` + Autostart-Fallback)

**Primär** — ganz oben in `hyprland.conf`, mit **absolutem Pfad** (kein `~`):

```conf
plugin = /home/rin/.config/hypr/plugins/libsplit-monitor-workspaces.so
```

**Fallback** — in `autostart.conf`, weil `plugin =` beim Kaltstart manchmal nicht greift:

```conf
exec-once = ~/.config/hypr/scripts/load-split-monitor-workspaces.sh
```

Das Script prüft, ob das Plugin geladen ist; falls nicht: laden + `hyprctl reload`.

**Nicht** `exec-once = hyprctl plugin load …` allein und **nicht** `hyprpm reload -n` ohne eingerichtetes hyprpm (schlägt sonst still fehl).

### Plugin-Binary (lokal, nicht in dotfiles)

Das `.so` liegt nur unter `~/.config/hypr/plugins/` und wird **nicht** ins dotfiles-Repo committed. Nach jedem Hyprland-Update ggf. neu bauen (siehe Troubleshooting).

## Konfiguration (in `hyprland.conf`)

```conf
plugin {
    split-monitor-workspaces {
        count = 10                       # Workspaces pro Monitor
        keep_focused = 0                 # Fokus nach Reload beibehalten
        enable_notifications = 1         # Popup-Notifications an
        enable_persistent_workspaces = 1 # Workspaces immer erstellen
        enable_wrapping = 0              # Kein Wrap-around
    }
}
```

### Was die Optionen bedeuten

| Option | Wert | Bedeutung |
|--------|------|-----------|
| `count` | `10` | Jeder Monitor bekommt 10 Workspaces |
| `keep_focused` | `0` | Nach `hyprctl reload` wird der Fokus nicht explizit gesetzt |
| `enable_notifications` | `1` | Zeigt Benachrichtigungen bei Workspace-Wechsel |
| `enable_persistent_workspaces` | `1` | Workspaces werden sofort beim Start erstellt, nicht erst bei Bedarf |
| `enable_wrapping` | `0` | Beim Erreichen des letzten Workspaces wird nicht wieder beim ersten angefangen |

## Wichtige Hinweise

- Die `libsplit-monitor-workspaces.so` muss zur installierten Hyprland-Version passen (ABI-Kompatibilität, z. B. `libhyprutils.so.12` vs `.13`)
- Nach einem Hyprland-Update: Plugin neu bauen (siehe unten)
- Stand Aug 2026: Hyprland **0.56.2**, Plugin-Commit `b28df0d` (hyprpm-Pin für 0.56.2)

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| Config error: `Invalid dispatcher "split-workspace"` | Plugin nicht geladen → `hyprctl plugin list` prüfen, Binary neu bauen |
| Plugin lädt nicht: `libhyprutils.so.12: cannot open shared object file` | Binary veraltet (ABI-Mismatch nach hyprutils-Update) → neu bauen |
| Plugin lädt nicht (sonst) | `hyprctl plugin list` – ggf. neu bauen |
| Workspaces wandern trotzdem | `enable_persistent_workspaces = 1` setzen |
| Crash nach Update | Plugin-Version muss zur Hyprland-Version passen |

### Plugin neu bauen (manuell)

Hyprland-Version und passenden Commit aus `hyprpm.toml` im Plugin-Repo nachschlagen (Pin für 0.56.2: `b28df0d`):

```bash
cd /tmp
git clone https://github.com/zjeffer/split-monitor-workspaces
cd split-monitor-workspaces
git fetch --depth 1 origin b28df0d0df6bc8b07389552c38f645bbba13008b
git checkout b28df0d0df6bc8b07389552c38f645bbba13008b
meson setup build --wipe && meson compile -C build
cp build/libsplit-monitor-workspaces.so ~/.config/hypr/plugins/
hyprctl reload
```

Alternativ: `sudo hyprpm purge-cache && hyprpm update && hyprpm add … && hyprpm enable split-monitor-workspaces && hyprpm reload -n`
