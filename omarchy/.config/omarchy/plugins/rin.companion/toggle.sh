#!/usr/bin/env bash
# Show/hide the household agent TUI.
# Process stays alive on special:companion. Visibility = move to the
# focused workspace. togglespecialworkspace alone fails across monitors
# (window sits on DP-9 while rin is on DP-12).
set -euo pipefail

DATA="${HOME}/.local/share/rin-companion"
PLUGIN="$(cd "$(dirname "$0")" && pwd)"
CLASS="rin-companion"

mkdir -p "${DATA}"
for f in soul.md user.md memory.md AGENTS.md rules.md; do
  if [[ ! -f "${DATA}/${f}" && -f "${PLUGIN}/templates/${f}" ]]; then
    cp "${PLUGIN}/templates/${f}" "${DATA}/${f}"
  fi
done

if ! command -v foot >/dev/null; then
  echo "rin.companion: foot missing" >&2
  exit 1
fi
if ! command -v agent >/dev/null; then
  echo "rin.companion: agent missing" >&2
  exit 1
fi

current_ws() { hyprctl activeworkspace -j | jq -r .name; }

client_json() {
  hyprctl clients -j | jq --arg c "${CLASS}" '.[] | select(.class == $c)'
}

client_exists() {
  [[ -n "$(client_json)" ]]
}

on_current_ws() {
  local ws
  ws="$(current_ws)"
  hyprctl clients -j | jq -e --arg c "${CLASS}" --arg ws "${ws}" \
    '.[] | select(.class == $c and .workspace.name == $ws)' >/dev/null
}

# Hyprland 0.55+ Lua dispatch. Old "movetoworkspace 21,class:..." is invalid.
show_here() {
  local ws
  ws="$(current_ws)"
  hyprctl dispatch "hl.dsp.window.move({ workspace = \"${ws}\", window = \"class:${CLASS}\" })"
  hyprctl dispatch "hl.dsp.focus({ window = \"class:${CLASS}\" })"
}

hide_away() {
  hyprctl dispatch "hl.dsp.window.move({ workspace = \"special:companion\", follow = false, window = \"class:${CLASS}\" })"
}

if client_exists; then
  if on_current_ws; then
    hide_away
  else
    show_here
  fi
  exit 0
fi

foot --app-id="${CLASS}" --title="${CLASS}" -D "${DATA}" -e "${PLUGIN}/run.sh" &

for _ in $(seq 1 30); do
  if client_exists; then
    show_here
    exit 0
  fi
  sleep 0.1
done

echo "rin.companion: foot started but window not seen" >&2
exit 1
