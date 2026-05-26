#!/usr/bin/env bash
set -euo pipefail

desired_version="${AI_DEVBOX_CODEX_DESIRED_VERSION:?AI_DEVBOX_CODEX_DESIRED_VERSION is required}"
platform_package=""
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) platform_package="@openai/codex-linux-x64@npm:@openai/codex@${desired_version}-linux-x64" ;;
  Linux-aarch64|Linux-arm64) platform_package="@openai/codex-linux-arm64@npm:@openai/codex@${desired_version}-linux-arm64" ;;
esac

current_version=""
if command -v codex >/dev/null 2>&1; then
  current_version="$(codex --version 2>/dev/null | awk '{print $NF}' || true)"
fi

if [[ "$current_version" == "$desired_version" ]]; then
  echo "codex version ${desired_version} is ready"
  exit 0
fi

echo "installing codex ${desired_version}"
if [[ -n "$platform_package" ]]; then
  npm install -g "@openai/codex@${desired_version}" "$platform_package"
else
  npm install -g "@openai/codex@${desired_version}"
fi

installed_version="$(codex --version | awk '{print $NF}')"
if [[ "$installed_version" != "$desired_version" ]]; then
  echo "codex version mismatch: expected ${desired_version}, got ${installed_version}" >&2
  exit 21
fi
