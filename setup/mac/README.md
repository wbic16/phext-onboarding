# Workstation Setup — macOS

Sets up a Mac for house work: Tailscale (the tailnet carries every house
service), trust in the Bickford House CA (so house pages load without
certificate warnings), an SSH key, and a git identity.

Run `setup.sh` from this folder. It uses `sudo` for the CA step (the System
keychain) and says so when it does. The script is idempotent — safe to re-run.

## What the script does

1. **Tailscale** — if the Tailscale app isn't installed, installs it via
   Homebrew (`brew install --cask tailscale`) when brew is available, and
   otherwise points you at https://tailscale.com/download. Sign in to the
   tailnet (`pizzly-halfmoon.ts.net`) from the app with the account from your
   invite — that part is interactive and yours.
2. **House CA** — installs `../house-ca.crt` into the **System** keychain as
   a trusted root:
   `sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ../house-ca.crt`
   Skips it if a cert named "Bickford House CA" is already there. Verify the
   cert before trusting it (see below).
3. **SSH key** — if `~/.ssh/id_ed25519` doesn't exist, generates one with
   `ssh-keygen`. Your **public** key (`id_ed25519.pub`) is what you register
   — with GitHub (ACCESS.md step 4) and with Emise for ranch access. The
   private key never leaves this machine.
4. **Git identity** — if `user.name` / `user.email` are unset, prints the two
   `git config --global` commands for you to run with your own name and email.

## Verify the CA before you trust it

```bash
openssl x509 -in ../house-ca.crt -noout -subject -fingerprint -sha256
```

Expected certificate:

- Subject: `CN=Bickford House CA, O=Phext Inc`
- SHA-256 fingerprint: `AB:80:6A:93:CC:BC:9A:40:6E:15:C2:3D:4C:81:5C:05:FD:EC:F4:F2:FD:23:19:6F:F8:51:35:7B:63:33:18:10`
- Valid: 2026-11-15 → 2036-11-12

If your download shows anything else, stop and ask Emise.

## Verify you're done

- Tailscale's menu-bar icon shows you connected; `tailscale status` (if you
  installed the CLI) lists the tailnet's other nodes.
- https://aletheia-core.pizzly-halfmoon.ts.net/ (the password portal) loads
  **without** a certificate warning.
- You can sign in to Jenkins with your LDAP account (ACCESS.md step 6).
