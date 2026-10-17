
#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE="ghcr.io/linuxserver/chrome:latest"
CONFIG_DIR="/home/vscode/.chrome-data"
WORKSPACE="${PWD}"

echo "=================================="
echo "       SLIPSTREAM STARTUP"
echo "=================================="

# Verify Docker is available.
docker info >/dev/null

# Ensure the persistent configuration directory exists.
mkdir -p "$CONFIG_DIR"

# Start the homepage server if it is not already running.
if ! curl -fsS http://127.0.0.1:8081/slipstream.html >/dev/null 2>&1; then
    nohup python3 -m http.server 8081 \
        --bind 0.0.0.0 \
        --directory "$WORKSPACE/.devcontainer" \
        >/tmp/slipstream-homepage.log 2>&1 </dev/null &

    for i in {1..20}; do
        if curl -fsS http://127.0.0.1:8081/slipstream.html >/dev/null 2>&1; then
            break
        fi
        sleep 1
    done
fi

if ! curl -fsS http://127.0.0.1:8081/slipstream.html >/dev/null; then
    echo "ERROR: Slipstream homepage server failed."
    cat /tmp/slipstream-homepage.log || true
    exit 1
fi

# Pull the image if necessary.
docker image inspect "$IMAGE" >/dev/null 2>&1 || docker pull "$IMAGE"

# Reuse a healthy Chrome container.
if docker inspect chrome >/dev/null 2>&1; then
    if [ "$(docker inspect -f '{{.State.Running}}' chrome)" = "true" ] &&
       docker port chrome 3000/tcp 2>/dev/null | grep -q '8080'; then
        echo "Chrome is already running on port 8080."
        exit 0
    fi

    docker rm -f chrome
fi

# Remove the previous workaround container.
docker rm -f chrome-test 2>/dev/null || true

# Start Chrome with the Slipstream homepage.
docker run -d \
    --name chrome \
    --restart unless-stopped \
    --add-host=host.docker.internal:host-gateway \
    -p 8080:3000 \
    -v "$CONFIG_DIR:/config" \
    -e AUTO_LOGIN=true \
    -e SUBFOLDER=/ \
    -e 'CHROME_CLI=http://host.docker.internal:8081/slipstream.html --no-sandbox --disable-dev-shm-usage --no-first-run --no-default-browser-check' \
    --security-opt seccomp=unconfined \
    --shm-size=2gb \
    "$IMAGE"

echo "Slipstream is starting."
echo "Chrome interface: port 8080"
echo "Homepage server: port 8081 (internal)"
echo "Check Chrome logs with: docker logs chrome"
