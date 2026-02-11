---
name: backup-ops
description: Create consistent local backups (SQLite safe snapshots) and optionally sync encrypted archives to cloud storage. Includes git sync of workspace prompts only.
---

## What this skill manages

- Workspace versioning (prompts and skills only)
- SQLite safe backups using sqlite3 .backup
- Encrypted sync using rclone crypt (optional)

## Safety rules

- Never sync live SQLite files by copying them directly.
- Never include credentials in git.
- Never run backups that upload to cloud unless Kevin explicitly enabled and approved the remote.

## Scripts

This workspace includes these helper scripts:

- scripts/backup_sqlite.sh
  Creates consistent snapshots from any SQLite files under ~/.openclaw into workspace/backups/sqlite/

- scripts/git_sync.sh
  Commits and pushes workspace prompts and skills only (daily logs excluded by .gitignore)

- scripts/rclone_sync.sh
  Syncs the backup folder to an rclone crypt remote (requires prior rclone config)

## Approval Gate

Any action that pushes to a remote (git push or rclone sync) requires explicit approval unless Kevin has explicitly approved a standing policy.
