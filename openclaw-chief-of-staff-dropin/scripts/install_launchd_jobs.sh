#!/usr/bin/env bash
set -euo pipefail

PLIST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/launchd"
DEST_DIR="$HOME/Library/LaunchAgents"

mkdir -p "$DEST_DIR"

uid="$(id -u)"
domain="gui/$uid"

install_one() {
  local plist="$1"
  local base
  base="$(basename "$plist")"
  local dest="$DEST_DIR/$base"

  echo "[launchd] installing $base"
  cp "$plist" "$dest"

  # Unload if already loaded
  launchctl bootout "$domain" "$dest" >/dev/null 2>&1 || true
  launchctl bootstrap "$domain" "$dest"
}

install_one "$PLIST_DIR/ai.openclaw.chief-of-staff.git-sync.plist"
install_one "$PLIST_DIR/ai.openclaw.chief-of-staff.backup-sqlite.plist"

echo "[launchd] installed. check status:"
echo "  launchctl print $domain/ai.openclaw.chief-of-staff.git-sync"
echo "  launchctl print $domain/ai.openclaw.chief-of-staff.backup-sqlite"
