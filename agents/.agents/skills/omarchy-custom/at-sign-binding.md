# Cmd+Q tippt @ (Keychron K4 im Mac-Modus)

Binding in `bindings.lua` (Dotfiles: `~/dotfiles/hyprland/.config/hypr/bindings.lua`):

```lua
local function send_at_once()
  hl.dispatch(hl.dsp.send_key_state({ mods = "MOD5", key = "Q", state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = "MOD5", key = "Q", state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end
hl.bind("SUPER + Q", send_at_once, { description = "Type @" })
```

## Hintergrund: Keychron K4 Mac/Win-Schalter

Die K4 hat einen Hardware-Schalter, der die Firmware-Belegung ändert:

- **Win-Modus:** Taste rechts neben Leertaste = AltGr (`RALT`, im de-Layout
  `ISO_Level3_Shift`) → `AltGr+Q` = `@` funktioniert nativ.
- **Mac-Modus:** rechts neben der Leertaste liegen nur **Command (Super/Mod4)**,
  **fn**, **Control** — es gibt rechts **keine** Option/AltGr-Taste mehr,
  `AltGr+Q` ist dort prinzipiell unmöglich. Links gibt es eine Option-Taste (= Alt/Mod1).

Diagnose damals per Capture-Fenster (foot, `stty raw`, Bytes mitschneiden):
Cmd+Q lieferte nackiges `q` (Super wird im Terminal ignoriert), Cmd+L löste
Omarchys `SUPER+L` (Toggle workspace layout) aus → rechte Command-Taste = Super.

## Warum send_key_state statt wtype

- Erster Ansatz `wtype -m alt @` (damals auf ALT+L) **funktioniert nicht**:
  der physisch gehaltene Modifier mergt am Seat in die injizierte Taste, Apps
  empfangen `Alt+@` statt `@` (Terminal: `ESC @`, GUI-Felder: nichts).
- Omarchy begründet das selbst in `default/hypr/bindings/clipboard.lua`
  ("the physically held SUPER merges into the injected chord at the seat").
  Deren Muster ist übernommen: `send_key_state` mit expliziten Mods +
  down/up-Split via Timer (sonst klemmt der synthetische Key-State,
  s. hyprwm/Hyprland Discussion #14099).
- `@` liegt auf de-Layout auf AltGr+Q, daher `mods = "MOD5"` + `key = "Q"`.
  Fallstricke: Key-Namen sind case-sensitiv (`"Q"`, nicht `"q"`), AltGr heißt
  `MOD5` (nicht `ALTGR`), und Keysym-Namen wie `"at"` werden nicht akzeptiert.
- **Layout-abhängig:** funktioniert nur mit de-Layout.

## Hinweise

- `SUPER+Q` war vorher unbelegt (nur `SUPER CTRL+Q` = Taschenrechner).
- Bindings unterscheiden nicht links/rechts → gilt auch für linke Command-Taste.
- Gilt in beiden Schalter-Stellungen; im Win-Modus zusätzlich zum nativen AltGr+Q.
- Kein echtes Tastatur-Remapping: greift nur in Hyprland-Sessions, nicht im
  Lockscreen/TTY.
- End-to-end verifiziert: `@` kommt sauber im Client an (Capture-Test, foot raw mode).
