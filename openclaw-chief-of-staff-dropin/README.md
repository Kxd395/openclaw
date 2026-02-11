# OpenClaw AI Chief of Staff (Drop In Workspace)

This zip is a local-first workspace and skill pack for running an "AI Chief of Staff" on OpenClaw as an always-on headless agent.

Design goals:

- Reliable: serial-by-default, fast acknowledgements, and controlled background work.
- Safe: two-step approval for any external side effects (email send, calendar writes, file writes outside workspace, shell).
- Auditable: every decision produces a short plan and leaves an artifact trail in your workspace logs.

## Target environment (what this pack assumes)

- macOS (tested design target: Apple Silicon Macs, clamshell ok)
- Node.js 22+
- OpenClaw CLI installed
- Optional: Docker Desktop (only if you choose to sandbox OpenClaw itself)

## Quick install

1. Install OpenClaw (official installer)

   curl -fsSL https://openclaw.ai/install.sh | bash

2. Run onboarding and install the daemon (launchd on macOS)

   openclaw onboard --install-daemon

3. Install this workspace

- Copy the folder `workspace/` from this zip to:

  ~/.openclaw/workspace

If you already have a workspace, back it up first.

4. Put the config in place (review before copying)

- Copy `config/openclaw.json5` to:

  ~/.openclaw/openclaw.json

Then edit it to add your real allowlists and channel config.

5. Validate this drop-in pack

   /bin/bash ./scripts/validate_dropin.sh

6. Security check (do this before you expose any channels)

   openclaw security audit --deep
   openclaw security audit --fix

7. Restart the gateway (so config + workspace changes load)

   openclaw gateway restart

## What is included

- workspace/SOUL.md: master identity plus hard constraints
- workspace/HEARTBEAT.md: periodic operations checklist
- workspace/AGENTS.md: the multi-persona council spec (evidence-bound)
- workspace/skills/\*: custom skills for approvals, security guardrails, council briefings, knowledge ingest, relational intelligence, and backup ops
- scripts/: local helper scripts (safe defaults, no remote downloads)
- launchd/: optional macOS scheduled jobs for git sync + encrypted backups

## Strong warnings (because agent skills are spicy)

- Do not install random third-party skills. The OpenClaw ecosystem has had real skill supply chain incidents.
- Treat every skill like executable code.
- Keep your gateway bound to loopback unless you are using a VPN like Tailscale.
- Prefer allowlists over open DM policies.
- Keep elevated tools (shell, file write outside workspace, browser control) disabled until you have a stable setup.

## Next steps

- Edit `~/.openclaw/openclaw.json` allowlists for Telegram and Slack.
- Decide if you will connect Google Workspace. If yes, use an official integration skill and separate credentials for the agent.
- Enable heartbeats and (optional) install the launchd scheduled backups in `launchd/`.

See `workspace/TOOLS.md` for operational notes and `workspace/SOUL.md` for the rules the assistant will follow.
