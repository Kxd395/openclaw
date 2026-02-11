#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="$HOME/Library/LaunchAgents"
uid="$(id -u)"
domain="gui/$uid"

remove_one() {
  local base="$1"
  local dest="$DEST_DIR/$base"
  if [[ -f "$dest" ]]; then
    echo "[launchd] removing $base"
    launchctl bootout "$domain" "$dest" >/dev/null 2>&1 || true
    rm -f "$dest"
  else
    echo "[launchd] not found: $base"
  fi
}

remove_one "ai.openclaw.chief-of-staff.git-sync.plist"
remove_one "ai.openclaw.chief-of-staff.backup-sqlite.plist"

echo "[launchd] done"
