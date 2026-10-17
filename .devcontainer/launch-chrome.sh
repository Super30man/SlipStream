
#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE="ghcr.io/linuxserver/chrome:latest"
CONTAINER="chrome"
CONFIG_DIR="/home/vscode/.chrome-data"

echo "Starting Slipstream..."

# Create persistent configuration storage.
mkdir -p "$CONFIG_DIR"

# Reuse the container if it is already running.
if docker inspect "$CONTAINER" >/dev/null 2>&1; then
    if [ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER")" = "true" ]; then
        PORTS="$(docker port "$CONTAINER" 2>/dev/null || true)"

        if echo "$PORTS" | grep -q '3000/tcp.*8080'; then
            echo "Chrome is already running on port 8080."
            exit 0
        fi
    fi

    echo "Replacing the existing Chrome container..."
    docker rm -f "$CONTAINER"
fi

# Remove the temporary container used by the old workaround.
docker rm -f chrome-test 2>/dev/null || true

# Download the image if necessary.
docker image inspect "$IMAGE" >/dev/null 2>&1 || docker pull "$IMAGE"

# Start Chrome.
docker run -d \
    --name "$CONTAINER" \
    --restart unless-stopped \
    -p 8080:3000 \
    -v "$CONFIG_DIR:/config" \
    -e AUTO_LOGIN=true \
    -e SUBFOLDER=/ \
    --shm-size=2gb \
    "$IMAGE"

echo "Chrome container started."
echo "Local service: http://localhost:8080"
echo "Check startup logs with: docker logs chrome"
