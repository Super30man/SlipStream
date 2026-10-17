
#!/usr/bin/env bash
set -u

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

if ! grep -q 'alias update-version=' "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# Update Slipstream from the main branch.
alias update-version='git pull --ff-only origin main'
EOF
fi

echo "Checking for Slipstream updates..."

if ! git fetch origin main; then
    echo "Could not check for updates."
    exit 0
fi

LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"

if [ "$LOCAL" != "$REMOTE" ]; then
    echo
    echo "UPDATE AVAILABLE"
    echo "Run update-version to pull the latest changes."
else
    echo "Slipstream is up to date."
fi
