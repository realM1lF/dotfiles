# Monitor-Konfiguration (ehemals hyprmon)

## Aktueller Stand

`hyprmon` wird **nicht mehr verwendet**. Stattdessen übernimmt [`workspace-setup.sh`](./workspace-setup.md) das Umschalten zwischen `work` und `home`.

Die historischen Anpassungen an `hyprmon` sind weiter unten dokumentiert, falls sie später noch einmal relevant werden.

## Aktive Monitor-Positionen

Die Positionen werden jetzt von `workspace-setup.sh` in `~/dotfiles/hyprland/.config/hypr/monitors.conf` geschrieben.

### `work` (3-Monitor-Setup)

| Monitor | Auflösung | Refresh | Scale | Transform | Position | Logische Größe |
|---------|-----------|---------|-------|-----------|----------|----------------|
| LG HDR 4K links (`0x0003E9A7`) | 3840×2160 | 60Hz | 1.5 | 1 (Portrait Left) | 0×0 | 1440×2560 |
| Xiaomi Mi Monitor | 3440×1440 | 50Hz | 1.0 | 0 (Normal) | 1440×0 | 3440×1440 |
| LG HDR 4K rechts (`0x00030432`) | 3840×2160 | 60Hz | 1.5 | 1 (Portrait Left) | 4880×0 | 1440×2560 |
| eDP-1 (Laptop) | 1920×1200 | 60Hz | 1.0 | 0 (Normal) | 6320×0 | 1920×1200 |

Berechnung:
- LG links logisch: 2160px (native Höhe) / 1.5 = **1440px breit**
- Xiaomi: 3440px breit → endet bei 1440 + 3440 = **4880**
- LG rechts logisch: 2160px / 1.5 = **1440px breit** → endet bei 4880 + 1440 = **6320**

### `home` (Laptop + Xiaomi)

| Monitor | Auflösung | Refresh | Scale | Transform | Position | Logische Größe |
|---------|-----------|---------|-------|-----------|----------|----------------|
| eDP-1 (Laptop) | 1920×1200 | 60Hz | 1.0 | 0 (Normal) | 0×0 | 1920×1200 |
| Xiaomi Mi Monitor | 3440×1440 | 50Hz | 1.0 | 0 (Normal) | 1920×0 | 3440×1440 |

## Wichtige Dateien

| Datei | Pfad | Rolle |
|-------|------|-------|
| `monitors.conf` | `~/dotfiles/hyprland/.config/hypr/monitors.conf` (via Symlink) | Aktive Monitor-Konfiguration |
| `monitors.json` | `~/.config/hypr/monitors.json` | Noch vorhanden, aber nicht mehr aktiv genutzt |
| `workspace-setup.sh` | `~/dotfiles/hyprland/.config/hypr/scripts/workspace-setup.sh` | Schreibt `monitors.conf` |

> ⚠️ `~/.config/hypr/monitors.conf` ist ein Symlink zu `~/dotfiles/hyprland/.config/hypr/monitors.conf`. Änderungen müssen im dotfiles-Repo erfolgen!

## hyprmon-Reste entfernen

Für die vollständige Deinstallation von `hyprmon` müssen folgende Befehle ausgeführt werden (erfordert `sudo`):

```bash
sudo rm -f /usr/local/bin/hyprmon
sudo rm -f /usr/bin/hyprmon.original.*
sudo pacman -R hyprmon
rm -rf ~/.cache/hyprmon-src
```

## Historie: hyprmon-Patch

> ⚠️ Nicht mehr aktiv. Nur zu Dokumentationszwecken.

`hyprmon` (AUR-Paket `hyprmon 1.0.1-1`) berechnete bei der automatischen Monitor-Anordnung die Positionen falsch, wenn Monitore im Portrait-Modus (`transform: 1` oder `3`) mit Scale genutzt werden. Das Tool verwendete immer `width / scale`, drehte aber nicht `width` und `height` bei gedrehten Monitoren um.

### Gepatchte Datei

`src/app.rs` – Funktion `recalculate_positions()`

```rust
pub fn recalculate_positions(&mut self) {
    let mut x = 0i32;
    for monitor in &mut self.monitors {
        monitor.position_x = x;
        monitor.position_y = 0;

        if let Some((w, h)) = monitor.resolution.split_once('x') {
            if let (Ok(width), Ok(height)) = (w.parse::<i32>(), h.parse::<i32>()) {
                let logical_width = match monitor.rotation {
                    Rotation::Left | Rotation::Right => {
                        (height as f64 / monitor.scale) as i32
                    }
                    Rotation::Normal | Rotation::Inverted => {
                        (width as f64 / monitor.scale) as i32
                    }
                };
                x += logical_width;
            }
        }
    }
}
```

### Warum hyprmon trotz Patch nicht mehr genutzt wird

`hyprmon` schrieb im Hintergrund bei bestimmten Ereignissen (Lock/Unlock, Monitor-Events) `monitors.json` und `monitors.conf` neu und berücksichtigte dabei nicht die workspace-spezifische Unterscheidung zwischen `work` und `home`. Das führte regelmäßig dazu, dass der Xiaomi-Monitor in `home` fälschlicherweise auf `1440x0` gesetzt wurde.

Dauerhafte Lösung: [`workspace-setup.sh`](./workspace-setup.md) ersetzt `hyprmon`.
