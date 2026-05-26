# AI Devbox Runtime

Runtime image for AI Devbox projects on Sealos Devbox.

The image includes:

- Codex CLI `0.133.0`
- `codex app-server` startup entrypoint
- Python 3, Git, curl, bash, and basic networking tools
- `/workspace` as the persistent project workspace

## Image

```text
ghcr.io/nightwhite/ai-devbox-runtime:0.1.0
```

## Local Build

```bash
make build
make smoke
```

## Runtime Contract

Required by the platform:

- `AI_DEVBOX_APP_SERVER_TOKEN` or `/run/secrets/codex-app-server-token`

Common environment variables:

- `AI_DEVBOX_WORKSPACE_PATH`, default `/workspace`
- `AI_DEVBOX_APP_SERVER_PORT`, default `1455`
- `AI_DEVBOX_CODEX_DESIRED_VERSION`, default `0.133.0`
- `CODEX_HOME`, default `/workspace/.codex`

The entrypoint initializes git in `/workspace` when needed, writes Codex config, then starts:

```bash
codex app-server --listen ws://0.0.0.0:1455 --ws-auth capability-token
```
