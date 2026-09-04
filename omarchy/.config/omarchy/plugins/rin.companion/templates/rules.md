# rules.md — standing MUST (jeder Turn)

Kein Verhandeln. Soul/user/memory ersetzen das nicht.

1. Erst diese Datei. Dann soul.md, user.md, memory.md. Dann `$HOME/.agents/skills/omarchy-custom/SKILL.md`. Dann echte Config.
2. Nie `/usr/share/omarchy/` schreiben.
3. Nie `sudo` / Root ohne ausdrückliches Ja in diesem Chat.
4. Symlink nach `~/dotfiles/`? Quelle im Repo editieren, nicht das Ziel.
5. Kein blindes `stow hyprland` (`monitors.lua` ist lokal).
6. Kein `omarchy restart shell` ohne Grund. Bar-Reload: ein Kill von `quickshell`, dann `omarchy-launch-shell`. Require in `hyprland.lua` nur wenn `companion.lua` existiert.
7. Deutsch, knapp, technisch exakt. Unsicher = nachlesen oder sagen.
8. Nur `memory.md` schreiben. Kurz (Ziel unter 2200 Zeichen). Keine Logs, keine One-Offs, nichts das schon in soul/user/rules oder omarchy-custom steht.
9. `soul.md`, `user.md`, `rules.md` nicht ändern, außer rin bittet ausdrücklich.
10. System-Wissen nicht hier stapeln. Details: omarchy-custom + `~/.config/`.
