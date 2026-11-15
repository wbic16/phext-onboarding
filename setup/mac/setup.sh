#!/usr/bin/env bash
# Phext, Inc. workstation setup - macOS
# Idempotent: safe to re-run. Uses sudo for the System keychain CA step.
# Does: Tailscale install pointer, house CA trust, SSH key generation,
#       git identity check.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CA_CERT="$SCRIPT_DIR/../house-ca.crt"
CA_NAME="Bickford House CA"
SYSTEM_KEYCHAIN="/Library/Keychains/System.keychain"

# --- 1. Tailscale ---
if [ -d "/Applications/Tailscale.app" ] || command -v tailscale >/dev/null 2>&1; then
    echo "Tailscale already installed. Sign in to the tailnet from the app if you haven't yet."
elif command -v brew >/dev/null 2>&1; then
    echo "Installing Tailscale via Homebrew..."
    brew install --cask tailscale
    echo "Open the Tailscale app and sign in with your invited account."
else
    echo "Install Tailscale from https://tailscale.com/download, then sign in with your invited account."
fi

# --- 2. House CA trust ---
if security find-certificate -c "$CA_NAME" "$SYSTEM_KEYCHAIN" >/dev/null 2>&1; then
    echo "$CA_NAME already trusted in the System keychain."
else
    echo "Installing $CA_NAME into the System keychain as a trusted root (sudo)..."
    sudo security add-trusted-cert -d -r trustRoot -k "$SYSTEM_KEYCHAIN" "$CA_CERT"
fi

# --- 3. SSH key ---
KEY="$HOME/.ssh/id_ed25519"
if [ -f "$KEY" ]; then
    echo "SSH key already exists at $KEY"
else
    echo "Generating an ed25519 SSH key (you will be asked for a passphrase)..."
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -f "$KEY"
fi
echo "Your public key (register this with GitHub and Emise): $KEY.pub"

# --- 4. Git identity ---
if ! git config --global user.name >/dev/null 2>&1 || ! git config --global user.email >/dev/null 2>&1; then
    echo "Set your git identity with your own name and email:"
    echo '  git config --global user.name "Your Name"'
    echo '  git config --global user.email "you@example.com"'
else
    echo "Git identity: $(git config --global user.name) <$(git config --global user.email)>"
fi

echo
echo "Done. Verify: connect in the Tailscale app; then open the password portal and confirm no certificate warning."
