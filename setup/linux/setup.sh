#!/usr/bin/env bash
# Phext, Inc. workstation setup - Linux
# Idempotent: safe to re-run. Uses sudo for the Tailscale and CA steps.
# Does: Tailscale install/join, house CA trust, SSH key generation,
#       git identity check.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CA_CERT="$SCRIPT_DIR/../house-ca.crt"
CA_NAME="Bickford House CA"

# --- 1. Tailscale ---
if ! command -v tailscale >/dev/null 2>&1; then
    echo "Installing Tailscale (official installer; runs with sudo)..."
    curl -fsSL https://tailscale.com/install.sh | sh
else
    echo "Tailscale already installed."
fi
echo "Joining the tailnet - open the sign-in URL it prints and use your invited account."
sudo tailscale up

# --- 2. House CA trust ---
if [ -d /usr/local/share/ca-certificates ] || command -v update-ca-certificates >/dev/null 2>&1; then
    DEST="/usr/local/share/ca-certificates/bickford-house-ca.crt"
    if [ -f "$DEST" ] && cmp -s "$CA_CERT" "$DEST"; then
        echo "$CA_NAME already trusted (system store up to date)."
    else
        echo "Installing $CA_NAME into the system trust store (sudo)..."
        sudo cp "$CA_CERT" "$DEST"
        sudo update-ca-certificates
    fi
elif command -v update-ca-trust >/dev/null 2>&1; then
    DEST="/etc/pki/ca-trust/source/anchors/bickford-house-ca.crt"
    if [ -f "$DEST" ] && cmp -s "$CA_CERT" "$DEST"; then
        echo "$CA_NAME already trusted (system store up to date)."
    else
        echo "Installing $CA_NAME into the system trust store (sudo)..."
        sudo cp "$CA_CERT" "$DEST"
        sudo update-ca-trust
    fi
else
    echo "WARNING: no known CA trust tooling found - install $CA_CERT manually for your distro." >&2
fi
echo "Note: Firefox uses its own trust store - see the README's Firefox caveat."

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
echo "Done. Verify: tailscale status; then open the password portal and confirm no certificate warning."
