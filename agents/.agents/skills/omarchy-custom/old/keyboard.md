# Keyboard Layout – Mac-Tastatur @-Zeichen

## Problem

Mit `kb_layout = de` (deutsches PC-Layout) liegt das `@`-Zeichen auf `AltGr + Q`. Bei einer Keychron-Mac-Tastatur gibt es aber **keine rechte Option/AltGr-Taste** — rechts kommt Command, Fn, Control, Pfeile. Dadurch ist `@` mit dem deutschen Layout praktisch unerreichbar.

## Erfolgreiche Lösung ✅

Da das Tastatur-Layout selbst keine AltGr-Taste bietet, wurde ein Hyprland-Binding mit `wtype` eingerichtet.

### Installiertes Tool

| Tool | Paket | Zweck |
|------|-------|-------|
| `wtype` | `extra/wtype` | Tippt Zeichen unter Wayland in die aktive App |

### Binding

```conf
bindd = ALT, L, At-Zeichen, exec, wtype @
```

### Geänderte Dateien

| Datei | Pfad |
|-------|------|
| input.conf | `~/dotfiles/hyprland/.config/hypr/input.conf` (via Symlink) |
| bindings.conf | `~/dotfiles/hyprland/.config/hypr/bindings.conf` (via Symlink) |

### Diff input.conf

```diff
-   kb_layout = de
-   kb_variant = mac
-   kb_options = compose:caps,apple:alupckeys
+   kb_layout = de
+   kb_options = compose:caps
```

### Diff bindings.conf

```diff
+# Mac keyboard: Option + L produces @
+bindd = ALT, L, At-Zeichen, exec, wtype @
```

## Fehlgeschlagene Versuche (zur Dokumentation)

| Versuch | Config | Ergebnis |
|---------|--------|----------|
| `de_mac` Layout | `kb_layout = de_mac` | Hyprland: "invalid layout passed" |
| `de` + `mac` Variante | `kb_layout = de` + `kb_variant = mac` | Config akzeptiert, aber `Option + L` produziert kein `@` (erwartet `AltGr + L`, aber Keychron hat keine AltGr) |
| `apple:alupckeys` | `kb_options = compose:caps,apple:alupckeys` | Keine Wirkung auf das AltGr-Verhalten |
| `lv3:ralt_switch` | `kb_options = compose:caps,lv3:ralt_switch` | Nutzlos, da keine rechte Alt-Taste vorhanden |

## Eckige Klammern auf Keychron K4 (2026-06-16)

### Problem

Mit deutschem Layout (`kb_layout = de`) liegen eckige Klammern auf `AltGr + 8` (`[`) und `AltGr + 9` (`]`). Die Keychron K4 im Mac-Layout hat aber **keine AltGr-Taste** — rechts neben der Leertaste kommen Command, Fn, Control.

### Lösung

Die **rechte Command-Taste** wird auf der Keychron K4 als `AltGr` (Level-3-Shift) konfiguriert. Dann produziert:

- Rechte Command + 8 → `[`
- Rechte Command + 9 → `]`
- Rechte Command + 7 → `{`
- Rechte Command + 0 → `}`

### Geänderte Datei

| Datei | Pfad |
|-------|------|
| input.conf | `~/dotfiles/hyprland/.config/hypr/input.conf` (via Symlink) |

### Diff input.conf

```diff
+ device {
+   name = keychron-k4-keychron-k4
+   kb_layout = de
+   kb_options = compose:caps,lv3:rwin_switch
+ }
+
+ device {
+   name = keychron-k4-keychron-k4-2
+   kb_layout = de
+   kb_options = compose:caps,lv3:rwin_switch
+ }
```

> `lv3:rwin_switch` legt AltGr auf die rechte Windows/Command/Super-Taste. Es gibt zwei `device`-Einträge, weil Hyprland die Tastatur je nach Verbindungsart (USB/Bluetooth) unter leicht unterschiedlichen Namen meldet.

### Anmerkung

Diese Lösung ist spezifisch für die Keychron K4. Andere Tastaturen (z. B. das ThinkPad-Keyboard) behalten das normale deutsche Layout bei (`compose:caps`).

## Wichtige Hinweise

- `wtype` nutzt das Wayland `virtual-keyboard`-Protokoll und funktioniert in den meisten Apps
- Das `@`-Binding erfordert **keinen Neustart** — `hyprctl reload` reicht
- `Alt + L` wird nun von Hyprland abgefangen und kann nicht mehr als normaler Shortcut in Apps genutzt werden
