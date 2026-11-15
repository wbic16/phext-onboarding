# Accounts & Access Checklist

Do these in order — each step unlocks the next. "Who acts" names the person
responsible for that step; everything marked **You** is yours to complete.

| # | Step | Who acts | Notes |
|---|------|----------|-------|
| 1 | **Join the tailnet (Tailscale)** | You, from Will or Emise's invite | Every house service lives on the tailnet (`pizzly-halfmoon.ts.net`) and is unreachable without it. The workstation setup for your OS installs Tailscale if you don't have it yet. |
| 2 | **Workstation setup** | You | Run the guide + script for your OS: [Windows](setup/windows/README.md), [Linux](setup/linux/README.md), [macOS](setup/mac/README.md). This trusts the house CA, generates your SSH key, and sets your git identity. Do it before step 3 so the password portal loads without a certificate warning. |
| 3 | **House LDAP account** | Emise creates it; **you** set the password | One account for all house services (directory: `dc=mirrorborn,dc=us`). Emise creates your `uid`; you set your own password at the self-service portal: https://aletheia-core.pizzly-halfmoon.ts.net/ — Emise never sees or sets your password. |
| 4 | **GitHub** | Will invites; you accept | Code lives in the `wbic16` GitHub org. Accept Will's invite, then add the SSH public key your workstation setup generated (GitHub → Settings → SSH and GPG keys). House repos target the `exo` branch; every branch gets a PR. |
| 5 | **Discord — Tessera** | Will or Emise invites; you join | Tessera is the team server — it's where the humans and agents talk day to day. Join, set your display name to your real name, and say hello. |
| 6 | **Jenkins** | You (verification) | No separate account: Jenkins takes the same LDAP login from step 3, via the `svc:jenkins` Tailscale service. Sign in and confirm you can see the build list — that proves your directory account, the tailnet, and your browser's CA trust all work at once. If the service address doesn't resolve yet, your orientation contact will give you the current one. |

## When something doesn't work

- Can't reach a house service at all → check Tailscale first (`tailscale status`); almost everything house-internal is tailnet-only.
- Certificate warning on a house page → your workstation doesn't trust the house CA yet; re-run your OS setup guide's CA step and check the fingerprint.
- Locked out of your LDAP account → Emise can reset it; your new password is still set by you, at the portal.
- Anything else → [WHO-TO-ASK.md](WHO-TO-ASK.md).
