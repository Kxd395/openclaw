# TOOLS.md

This file is for operator notes about the machine and safe operations.

## Mac baseline

- Keep the machine awake (clamshell ok).
- Keep the gateway bound to loopback unless you are using a VPN like Tailscale.
- Prefer FileVault on.

## OpenClaw key paths

- Config: ~/.openclaw/openclaw.json
- Workspace: ~/.openclaw/workspace
- Skills (managed): ~/.openclaw/skills
- Credentials: ~/.openclaw/credentials
- Sessions: ~/.openclaw/agents/ (per agent: sessions/)

## Must run checks after changes

- Security audit:
  - openclaw security audit --deep
  - openclaw security audit --fix

- Gateway status:
  - openclaw gateway status

- Restart:
  - openclaw gateway restart

## Backup strategy (safe for SQLite)

Do not copy live SQLite files.
Use the Online Backup API via sqlite3 ".backup" to produce consistent snapshots.

This pack includes:
- scripts/backup_sqlite.sh
- scripts/git_sync.sh
- scripts/rclone_sync.sh

Read root README for install guidance.
