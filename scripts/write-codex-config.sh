#!/usr/bin/env bash
set -euo pipefail

codex_home="${CODEX_HOME:-/workspace/.codex}"
mkdir -p "$codex_home"
config_file="$codex_home/config.toml"

model="${AI_DEVBOX_MODEL:-gpt-5.3-codex}"
base_url="${OPENAI_BASE_URL:-}"

cat > "$config_file" <<EOF
model = "${model}"
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[shell_environment_policy]
inherit = "all"
EOF

if [[ -n "$base_url" ]]; then
  cat >> "$config_file" <<EOF

[model_providers.openai]
base_url = "${base_url}"
EOF
fi
