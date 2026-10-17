#!/usr/bin/env bash
set -euo pipefail

docker rm -f chrome 2>/dev/null || true

docker run -d --name chrome \
  -p 8080:3000 \
  --shm-size=2gb \
  --security-opt seccomp=unconfined \
  -e CHROME_CLI="https://google.com --no-sandbox --disable-dev-shm-usage --no-first-run --no-default-browser-check --hide-crash-restore-bubble" \
  ghcr.io/linuxserver/chrome:latest
