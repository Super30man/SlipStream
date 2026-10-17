
#!/usr/bin/env bash
set -u

# Only run repository checks inside a Git repository.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    exit 0
fi

# Add the update command once.
if ! grep -q 'alias update-version=' "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" <<'EOF'

# Update Slipstream from the main branch.
alias update-version='git pull --ff-only origin main'
EOF
fi

# Check whether a newer version exists.
echo "Checking for Slipstream updates..."

if ! git fetch origin main; then
    echo "Could not check for updates. Check your Git connection."
    exit 0
fi

LOCAL="$(git rev-parse HEAD)"
REMOTE="$(git rev-parse origin/main)"

if [ "$LOCAL" != "$REMOTE" ]; then
    echo
    echo "========================================="
    echo "UPDATE AVAILABLE"
    echo "Run: update-version"
    echo "Then rebuild the Codespace if configuration changed."
    echo "========================================="
    echo
else
    echo "Slipstream repository is up to date."
fi
