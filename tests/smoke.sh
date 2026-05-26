#!/usr/bin/env bash
set -euo pipefail

test -x /opt/ai-devbox/scripts/start.sh
test -x /opt/ai-devbox/scripts/install-codex-version.sh
test -x /opt/ai-devbox/scripts/write-codex-config.sh
test -n "${AI_DEVBOX_CODEX_DESIRED_VERSION:-}"

mkdir -p "${CODEX_HOME:-/workspace/.codex}"
codex --version

export AI_DEVBOX_APP_SERVER_TOKEN="smoke-token"
export AI_DEVBOX_WORKSPACE_PATH="${AI_DEVBOX_WORKSPACE_PATH:-/workspace}"

timeout 8s /opt/ai-devbox/scripts/start.sh &
pid="$!"

for _ in $(seq 1 20); do
  if ss -ltn | grep -q ':1455 '; then
    kill "$pid" >/dev/null 2>&1 || true
    wait "$pid" >/dev/null 2>&1 || true
    exit 0
  fi
  sleep 0.2
done

kill "$pid" >/dev/null 2>&1 || true
wait "$pid" >/dev/null 2>&1 || true
echo "codex app-server did not listen on 1455" >&2
exit 1
