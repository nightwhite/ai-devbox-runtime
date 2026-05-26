#!/usr/bin/env bash
set -euo pipefail

workspace="${AI_DEVBOX_WORKSPACE_PATH:-/workspace}"
port="${AI_DEVBOX_APP_SERVER_PORT:-1455}"
token_key="${AI_DEVBOX_APP_SERVER_TOKEN_KEY:-codex-app-server-token}"
token_file="/run/secrets/${token_key}"
codex_home="${CODEX_HOME:-${workspace}/.codex}"

mkdir -p "$workspace" "$codex_home"
cd "$workspace"

if [[ ! -d .git ]]; then
  git init --initial-branch=main
fi

/opt/ai-devbox/scripts/install-codex-version.sh
/opt/ai-devbox/scripts/write-codex-config.sh

if [[ ! -s "$token_file" ]]; then
  if [[ -n "${AI_DEVBOX_APP_SERVER_TOKEN:-}" ]]; then
    mkdir -p "$(dirname "$token_file")"
    printf '%s' "$AI_DEVBOX_APP_SERVER_TOKEN" > "$token_file"
    chmod 600 "$token_file"
  else
    echo "missing app-server token file: ${token_file}" >&2
    exit 22
  fi
fi

exec codex app-server \
  --listen "ws://0.0.0.0:${port}" \
  --ws-auth capability-token \
  --ws-token-file "$token_file"
