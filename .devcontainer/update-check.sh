#!/bin/bash

# Set up update-version alias
if ! grep -q "alias update-version=" ~/.bashrc 2>/dev/null; then
  echo 'alias update-version="git pull origin main && devcontainer-cli rebuild --workspace-folder . 2>/dev/null || echo -e \"\n✅ Local repository updated to latest commit! Please press F1 -> Codespaces: Full Rebuild Container to reload Docker cleanly.\n\""' >> ~/.bashrc
fi

# Set up terminal version banner
if ! grep -q "git fetch origin main" ~/.bashrc 2>/dev/null; then
  echo 'git fetch origin main >/dev/null 2>&1 && LOCAL=$(git rev-parse HEAD) && REMOTE=$(git rev-parse origin/main) && if [ "$LOCAL" != "$REMOTE" ]; then NEW_VER=$(git show origin/main:.devcontainer/devcontainer.json | grep -oP "(?<=\"name\": \")[^\"]*"); echo -e "\n=========================================\n🚀 UPDATE AVAILABLE: $NEW_VER\nType: update-version (or press F1 -> Rebuild)\n=========================================\n"; fi' >> ~/.bashrc
fi
