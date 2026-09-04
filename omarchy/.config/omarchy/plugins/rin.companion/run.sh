#!/usr/bin/env bash
# Interactive TUI. Same chat every spawn via --resume.
# Closing foot kills this process; the conversation stays. Next open resumes.
set -euo pipefail

DATA="${HOME}/.local/share/rin-companion"
PLUGIN="$(cd "$(dirname "$0")" && pwd)"
ID_FILE="${DATA}/chat-id"

mkdir -p "${DATA}"
for f in soul.md user.md memory.md AGENTS.md rules.md; do
  if [[ ! -f "${DATA}/${f}" && -f "${PLUGIN}/templates/${f}" ]]; then
    cp "${PLUGIN}/templates/${f}" "${DATA}/${f}"
  fi
done

if [[ ! -s "${ID_FILE}" ]]; then
  agent create-chat | tr -d '\r[:space:]' > "${ID_FILE}"
fi

ID="$(tr -d '\r[:space:]' < "${ID_FILE}")"
if [[ -z "${ID}" ]]; then
  echo "rin.companion: empty chat-id" >&2
  exit 1
fi

cd "${DATA}"
exec agent --workspace "${DATA}" --add-dir "${HOME}" --trust --mode ask --resume "${ID}"
