#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/workspace"
DEST_DIR="${OPENCLAW_WORKSPACE_DEST:-$HOME/.openclaw/workspace}"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "[install_workspace] missing source workspace: $SRC_DIR"
  exit 2
fi

mkdir -p "$(dirname "$DEST_DIR")"

if [[ -d "$DEST_DIR" ]]; then
  ts="$(date +"%Y-%m-%d_%H%M%S")"
  backup_dir="${DEST_DIR}.bak.${ts}"
  echo "[install_workspace] existing workspace found. backing up to: $backup_dir"
  mv "$DEST_DIR" "$backup_dir"
fi

echo "[install_workspace] copying workspace to: $DEST_DIR"
cp -R "$SRC_DIR" "$DEST_DIR"

echo "[install_workspace] done"
