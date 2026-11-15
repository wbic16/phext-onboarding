# Phext, Inc. workstation setup - Windows
# Idempotent: safe to re-run. Run from an ELEVATED PowerShell.
# Does: Tailscale install/join, house CA trust (Local Machine Root),
#       SSH key generation, git identity check.
$ErrorActionPreference = 'Stop'

$CaCert = Join-Path $PSScriptRoot '..\house-ca.crt'
$CaName = 'Bickford House CA'

# --- Admin check (CA install writes to the Local Machine store) ---
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host 'Please re-run this script from an elevated PowerShell (Run as Administrator).' -ForegroundColor Yellow
    exit 1
}

# --- 1. Tailscale ---
if (-not (Get-Command tailscale -ErrorAction SilentlyContinue)) {
    Write-Host 'Installing Tailscale via winget...'
    winget install -e --id Tailscale.Tailscale --accept-source-agreements --accept-package-agreements
} else {
    Write-Host 'Tailscale already installed.'
}
Write-Host 'Joining the tailnet - a browser window will open; sign in with your invited account.'
tailscale up

# --- 2. House CA trust ---
$cert = Get-PfxCertificate $CaCert
$existing = Get-ChildItem Cert:\LocalMachine\Root | Where-Object { $_.Thumbprint -eq $cert.Thumbprint }
if ($existing) {
    Write-Host "$CaName already trusted."
} else {
    Write-Host "Installing $CaName into the Local Machine Root store..."
    certutil -addstore -f Root $CaCert | Out-Null
    Write-Host 'House CA installed.'
}

# --- 3. SSH key ---
$key = Join-Path $env:USERPROFILE '.ssh\id_ed25519'
if (Test-Path $key) {
    Write-Host "SSH key already exists at $key"
} else {
    Write-Host 'Generating an ed25519 SSH key (you will be asked for a passphrase)...'
    ssh-keygen -t ed25519 -f $key
}
Write-Host "Your public key (register this with GitHub and Emise): $key.pub"

# --- 4. Git identity ---
$name = git config --global user.name 2>$null
$email = git config --global user.email 2>$null
if (-not $name -or -not $email) {
    Write-Host 'Set your git identity with your own name and email:' -ForegroundColor Yellow
    Write-Host '  git config --global user.name "Your Name"'
    Write-Host '  git config --global user.email "you@example.com"'
} else {
    Write-Host "Git identity: $name <$email>"
}

Write-Host ''
Write-Host 'Done. Verify: tailscale status; then open the password portal and confirm no certificate warning.'
