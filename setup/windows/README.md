# Workstation Setup — Windows

Sets up a Windows machine for house work: Tailscale (the tailnet carries every
house service), trust in the Bickford House CA (so house pages load without
certificate warnings), an SSH key, and a git identity.

Run `setup.ps1` from this folder in an **elevated** PowerShell (the CA step
writes to the Local Machine store). The script is idempotent — safe to re-run.

## What the script does

1. **Tailscale** — installs it via `winget` if missing, then runs
   `tailscale up`. Signing in to the tailnet (`pizzly-halfmoon.ts.net`) is
   interactive: a browser window opens and *you* sign in with the account
   from your invite. The script can't and won't do that part for you.
2. **House CA** — installs `..\house-ca.crt` into the Local Machine
   `Root` store via `certutil`, after checking it isn't already there.
   Verify the cert before trusting it (see below).
3. **SSH key** — if `%USERPROFILE%\.ssh\id_ed25519` doesn't exist, generates
   one with `ssh-keygen`. Your **public** key (`id_ed25519.pub`) is what you
   register — with GitHub (ACCESS.md step 4) and with Emise for ranch access.
   The private key never leaves this machine.
4. **Git identity** — if `user.name` / `user.email` are unset, prints the two
   `git config --global` commands for you to run with your own name and email.

## Verify the CA before you trust it

The certificate in this repo must match the house CA exactly. Check its
SHA-256 fingerprint before (or right after) installing:

```powershell
(Get-PfxCertificate ..\house-ca.crt).Thumbprint   # SHA-1 thumbprint, for store lookups
certutil -hashfile ..\house-ca.crt SHA256
```

Expected certificate:

- Subject: `CN=Bickford House CA, O=Phext Inc`
- SHA-256 fingerprint: `AB:80:6A:93:CC:BC:9A:40:6E:15:C2:3D:4C:81:5C:05:FD:EC:F4:F2:FD:23:19:6F:F8:51:35:7B:63:33:18:10`
- Valid: 2026-11-15 → 2036-11-12

If your download shows anything else, stop and ask Emise.

## Verify you're done

- `tailscale status` lists your machine and shows the tailnet's other nodes.
- https://aletheia-core.pizzly-halfmoon.ts.net/ (the password portal) loads
  **without** a certificate warning.
- You can sign in to Jenkins with your LDAP account (ACCESS.md step 6).
