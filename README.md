# Phext, Inc. — New Hire Orientation

Welcome. This repo is the front door for everyone joining Phext, Inc. Work
through it in order; by the end you will have your accounts, your workstation,
and your first week mapped. If anything here is stale or missing, open a PR —
orientation is a living document, and we add items as we go.

## What Phext, Inc. is

Phext, Inc. is building the Exocortex: a shared, addressable memory for humans
and agents. Its foundation is **phext** — a plain-text format that gives every
piece of text an address in an 11-dimensional lattice (9 addressing dimensions,
plus each scroll as a 2D page of text). Around it we build the tooling: SQ (the
phext host), phext-lattice, edit.phext.io, QEXO (the orchestrator), and the
ranch — a fleet of small machines that run the builds.

The company is organized into six divisions:

- **Research & Technology** — truth and canon: what we know, and how we know it.
- **R&D** — the core tooling: phext implementations, SQ, the lattice.
- **Revenue** — the boundary with the outside world: integrations and sales.
- **Evolution** — becoming: hiring, growth, agent pairing.
- **Judgement** — choosing: decisions, review, and their provenance.
- **DevSecOps** — the immune system: infrastructure, security, releases.

Two design rules shape everything here:

- **There is no HR department and no management hierarchy.** Both are obsolete
  by design. You report to the work; questions that would go to a manager go
  to Will, or to Emise.
- **Every employee is paired with an agent.** Your agent can interlink with
  everyone else's at scale. Working with your agent is not a perk — it is the
  job's basic shape.

## The orientation path, in order

1. **[ACCESS.md](ACCESS.md)** — accounts & access checklist. Do these in the
   order listed; each step unlocks the next.
2. **Workstation setup** for your OS — installs Tailscale, trusts the house
   CA, and sets up your SSH key and git identity:
   - [setup/windows](setup/windows/README.md)
   - [setup/linux](setup/linux/README.md)
   - [setup/mac](setup/mac/README.md)
3. **[FIRST-WEEK.md](FIRST-WEEK.md)** — what your first week looks like.
4. **[WHO-TO-ASK.md](WHO-TO-ASK.md)** — who to ask for what.

## Index

| Path | What it is |
|---|---|
| `README.md` | This file — the orientation front door. |
| `ACCESS.md` | Accounts & access checklist, in order, with who acts on each step. |
| `FIRST-WEEK.md` | The first-week path. |
| `WHO-TO-ASK.md` | Who to ask for what. |
| `setup/house-ca.crt` | The Bickford House CA certificate (public cert; verify its fingerprint in your OS guide before trusting it). |
| `setup/windows/` | Windows workstation guide + `setup.ps1`. |
| `setup/linux/` | Linux workstation guide + `setup.sh`. |
| `setup/mac/` | macOS workstation guide + `setup.sh`. |

## Adding to this repo

New orientation material lands by pull request against the primary branch.
When you add a file, add a row to the index above in the same PR. If you found
a gap while onboarding, fixing it for the next hire *is* part of onboarding.
