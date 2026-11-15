# Workstation Setup — Linux

Sets up a Linux machine for house work: Tailscale (the tailnet carries every
house service), trust in the Bickford House CA (so house pages load without
certificate warnings), an SSH key, and a git identity.

Run `setup.sh` from this folder. It uses `sudo` for the Tailscale and CA
steps and says so when it does. The script is idempotent — safe to re-run.

## What the script does

1. **Tailscale** — installs it with the official installer if missing, then
   runs `sudo tailscale up`. Joining the tailnet (`pizzly-halfmoon.ts.net`)
   prints a sign-in URL: open it and sign in with the account from your
   invite. That part is yours; no script can do it for you.
2. **House CA** — copies `../house-ca.crt` to
   `/usr/local/share/ca-certificates/bickford-house-ca.crt` and runs
   `update-ca-certificates` (Debian/Ubuntu family). On RHEL/Fedora family
   systems the equivalent is `trust anchor` / `update-ca-trust` — the script
   detects the family and uses the right one. Skips the copy if the
   installed cert is already identical.
3. **SSH key** — if `~/.ssh/id_ed25519` doesn't exist, generates one with
   `ssh-keygen`. Your **public** key (`id_ed25519.pub`) is what you register
   — with GitHub (ACCESS.md step 4) and with Emise for ranch access. The
   private key never leaves this machine.
4. **Git identity** — if `user.name` / `user.email` are unset, prints the two
   `git config --global` commands for you to run with your own name and email.

## The Firefox caveat

Firefox keeps its **own** trust store and ignores the system one by default,
so house pages can still warn in Firefox after this setup. Two fixes, pick one:

- In Firefox: `about:config` → set `security.enterprise_roots.enabled` to
  `true` (Firefox then reads the OS store), **or**
- Import the cert into your Firefox profile's NSS database:
  `certutil -d sql:$HOME/.mozilla/firefox/*.default-release -A -t CT,C,c -n "Bickford House CA" -i ../house-ca.crt`
  (certutil ships in the `libnss3-tools` package on Debian/Ubuntu.)

Chromium/Chrome on Linux use the system store and need nothing extra.

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

- `tailscale status` lists your machine and shows the tailnet's other nodes.
- https://aletheia-core.pizzly-halfmoon.ts.net/ (the password portal) loads
  **without** a certificate warning.
- You can sign in to Jenkins with your LDAP account (ACCESS.md step 6).
