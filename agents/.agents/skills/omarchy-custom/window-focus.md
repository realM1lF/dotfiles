# Window Focus Behavior

## Änderung

`focus_on_activate` global auf `false` gesetzt, damit Fenster nicht automatisch den Fokus stehlen können (z. B. bei Chat-Benachrichtigungen, Dialogen oder Pop-ups auf anderen Monitoren/Workspaces).

## Datei

`~/.config/hypr/looknfeel.conf`

## Hintergrund

Omarchy setzt im Default (`~/.local/share/omarchy/default/hypr/looknfeel.conf`) `focus_on_activate = true`. Das führt dazu, dass der Fokus auf andere Monitore oder Workspaces springt, sobald eine Anwendung sich selbst aktiviert. Für manche Apps (z. B. Telegram) gibt es bereits app-spezifische Ausnahmen in den Defaults; hier wurde es global deaktiviert.

## Revert

Entferne oder kommentiere den Block in `~/.config/hypr/looknfeel.conf` aus, damit der Omarchy-Default wieder greift:

```conf
#misc {
#    focus_on_activate = false
#}
```
