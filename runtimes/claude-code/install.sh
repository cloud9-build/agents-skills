#!/bin/bash

# Claude Code specific installer

set -e

REPO_URL="https://github.com/cloud9-build/agents-skills.git"
TMP_DIR=$(mktemp -d)

# Default to global install
INSTALL_PATH="$HOME/.claude/skills"

# Check for local flag
if [ "$1" = "--local" ]; then
    INSTALL_PATH="./.claude/skills"
fi

echo "Installing Cloud9 Skills for Claude Code..."
echo "Target: $INSTALL_PATH"

# Clone repo
git clone --quiet --depth 1 "$REPO_URL" "$TMP_DIR"

# Create directory and copy skills
mkdir -p "$INSTALL_PATH"
cp -r "$TMP_DIR/skills/"* "$INSTALL_PATH/"

# Cleanup
rm -rf "$TMP_DIR"

# Verify
if [ -f "$INSTALL_PATH/god-mode/SKILL.md" ]; then
    echo "Installation complete."
    echo "Run /gm to get started!"
else
    echo "Installation failed."
    exit 1
fi
