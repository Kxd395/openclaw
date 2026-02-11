# Runbook

This is a practical operator runbook for the headless Chief of Staff setup.

## Day 0 checklist

1. Install OpenClaw and onboard with daemon

- openclaw onboard --install-daemon

2. Install workspace and config from this zip

- ./scripts/install_workspace.sh
- ./scripts/install_config.sh

3. Validate scripts and launchd files

- /bin/bash ./scripts/validate_dropin.sh

4. Lock down permissions

- chmod 700 ~/.openclaw
- chmod 600 ~/.openclaw/openclaw.json

5. Run security audit

- openclaw security audit --deep
- openclaw security audit --fix

6. Only then enable channels and add allowlists

## Daily operations

- Check gateway health:
  - openclaw gateway status
- Review logs:
  - /tmp/openclaw/openclaw.log

## Backup operations

- Local SQLite safe snapshots:
  - ~/.openclaw/workspace/ops/backup_sqlite.sh

- Git sync (workspace prompts only):
  - ~/.openclaw/workspace/ops/git_sync.sh

- Encrypted cloud sync (optional):
  - Set RCLONE_REMOTE, then run ~/.openclaw/workspace/ops/rclone_sync.sh

## Incident response (short)

If the agent does something unsafe:

1. Stop the gateway
2. Bind to loopback and disable channels
3. Rotate tokens and API keys
4. Run openclaw security audit --deep
