FROM node:22-bookworm

ARG CODEX_VERSION=0.133.0
ARG TARGETARCH

ENV AI_DEVBOX_WORKSPACE_PATH=/workspace \
    AI_DEVBOX_APP_SERVER_PORT=1455 \
    AI_DEVBOX_CODEX_DESIRED_VERSION=${CODEX_VERSION} \
    CODEX_HOME=/workspace/.codex

RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates bash curl iproute2 python3 bubblewrap \
  && rm -rf /var/lib/apt/lists/* \
  && case "${TARGETARCH:-$(dpkg --print-architecture)}" in \
    amd64|x64) codex_platform="@openai/codex-linux-x64@npm:@openai/codex@${CODEX_VERSION}-linux-x64" ;; \
    arm64|aarch64) codex_platform="@openai/codex-linux-arm64@npm:@openai/codex@${CODEX_VERSION}-linux-arm64" ;; \
    *) codex_platform="" ;; \
  esac \
  && if [ -n "$codex_platform" ]; then npm install -g "@openai/codex@${CODEX_VERSION}" "$codex_platform"; else npm install -g "@openai/codex@${CODEX_VERSION}"; fi

COPY scripts/ /opt/ai-devbox/scripts/
COPY tests/ /opt/ai-devbox/tests/
RUN chmod +x /opt/ai-devbox/scripts/*.sh /opt/ai-devbox/tests/*.sh \
  && mkdir -p /workspace/.codex /run/secrets \
  && codex --version

WORKDIR /workspace

ENTRYPOINT ["/opt/ai-devbox/scripts/start.sh"]
