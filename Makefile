.PHONY: build smoke

IMAGE ?= ghcr.io/nightwhite/ai-devbox-codex-runtime:0.1.0

build:
	docker build -t $(IMAGE) .

smoke:
	docker run --rm --entrypoint /opt/ai-devbox/tests/smoke.sh $(IMAGE)
