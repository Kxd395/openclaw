#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${OPENCLAW_HOME:-$HOME/.openclaw}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE:-$BASE_DIR/workspace}"
SRC_DIR="$WORKSPACE_DIR/backups"

REMOTE="${RCLONE_REMOTE:-}"

if [[ -z "$REMOTE" ]]; then
  echo "[rclone_sync] RCLONE_REMOTE is not set"
  echo "[rclone_sync] set it to an rclone remote target like a crypt remote path."
  exit 2
fi

if ! command -v rclone >/dev/null 2>&1; then
  echo "[rclone_sync] rclone is not installed"
  echo "[rclone_sync] install via Homebrew:"
  echo "  brew install rclone"
  exit 2
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo "[rclone_sync] missing backups folder: $SRC_DIR"
  exit 2
fi

echo "[rclone_sync] syncing $SRC_DIR -> $REMOTE"
rclone sync "$SRC_DIR" "$REMOTE" --checksum --create-empty-src-dirs --verbose
echo "[rclone_sync] done"
