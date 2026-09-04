#!/usr/bin/env bash
# One companion turn. User text in pending-prompt.txt.
# rules.md is prepended every turn so --resume cannot drop standing MUST.
set -euo pipefail

DATA="${HOME}/.local/share/rin-companion"
PLUGIN="$(cd "$(dirname "$0")" && pwd)"
ID_FILE="${DATA}/chat-id"
PROMPT_FILE="${DATA}/pending-prompt.txt"
RULES_FILE="${DATA}/rules.md"

mkdir -p "${DATA}"

if [[ ! -f "${RULES_FILE}" && -f "${PLUGIN}/templates/rules.md" ]]; then
  cp "${PLUGIN}/templates/rules.md" "${RULES_FILE}"
fi

if ! command -v agent >/dev/null; then
  echo "rin.companion: agent missing" >&2
  exit 1
fi

if [[ ! -s "${PROMPT_FILE}" ]]; then
  echo "rin.companion: empty prompt" >&2
  exit 1
fi

if [[ ! -s "${ID_FILE}" ]]; then
  agent create-chat | tr -d '\r[:space:]' > "${ID_FILE}"
fi

ID="$(tr -d '\r[:space:]' < "${ID_FILE}")"
if [[ -z "${ID}" ]]; then
  echo "rin.companion: empty chat-id" >&2
  exit 1
fi

PROMPT="$(
  if [[ -f "${RULES_FILE}" ]]; then
    printf '%s\n\n' "PFLICHT — rules.md gilt für diesen Turn. Nicht verhandeln."
    cat "${RULES_FILE}"
    printf '\n%s\n' "---"
    printf '%s\n' "User:"
  fi
  cat "${PROMPT_FILE}"
)"

exec agent --print --trust \
  --workspace "${DATA}" \
  --add-dir "${HOME}" \
  --resume "${ID}" \
  -- "${PROMPT}"
