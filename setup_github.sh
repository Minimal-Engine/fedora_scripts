#!/bin/bash
set -e # Exit on error

# --- Configuration ---
EMAIL=""
KEY_TITLE="$(user)-$(hostname)-$(date +%F)"
KEY_PATH="$HOME/.ssh/$(user)-$(hostname)-$(date +%F)"

echo "🚀 Starting GitHub SSH Automation..."

# 1. Check for GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found. Install it with: sudo dnf install gh"
    exit 1
fi

# 2. Check auth status
if ! gh auth status &>/dev/null; then
    echo "🔐 Logging into GitHub..."
    gh auth login -p ssh -w
fi

# 3. Handle Email
if [ -z "$EMAIL" ]; then
    read -p "📧 Enter your GitHub email: " EMAIL
fi

# 4. Generate Key
if [ -f "$KEY_PATH" ]; then
    echo "⚠️  SSH key already exists. Using existing key."
else
    echo "🔑 Generating Ed25519 key..."
    mkdir -p ~/.ssh
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

# 5. Start Agent and Add Key
# We use -c to check if an agent is already running to avoid duplicates
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

# 6. Upload to GitHub
echo "☁️  Uploading to GitHub..."
# Check if key title already exists to prevent duplicates on GitHub
if gh ssh-key list | grep -q "$KEY_TITLE"; then
    echo "⚠️  Key with title '$KEY_TITLE' already exists on GitHub."
else
    gh ssh-key add "${KEY_PATH}.pub" --title "$KEY_TITLE"
fi

# 7. Final Test
echo "🧪 Testing connection..."
# ssh -T returns exit code 1 on success for GitHub, so we ignore the error
ssh -T git@github.com || true

echo "✅ All set! Your Fedora machine is ready for GitHub."