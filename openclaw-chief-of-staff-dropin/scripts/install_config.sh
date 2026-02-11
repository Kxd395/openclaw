#!/usr/bin/env bash
set -euo pipefail

SRC_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/config/openclaw.json5"
DEST_FILE="${OPENCLAW_CONFIG_DEST:-$HOME/.openclaw/openclaw.json}"

if [[ ! -f "$SRC_FILE" ]]; then
  echo "[install_config] missing source config: $SRC_FILE"
  exit 2
fi

mkdir -p "$(dirname "$DEST_FILE")"

if [[ -f "$DEST_FILE" ]]; then
  ts="$(date +"%Y-%m-%d_%H%M%S")"
  backup_file="${DEST_FILE}.bak.${ts}"
  echo "[install_config] existing config found. backing up to: $backup_file"
  cp "$DEST_FILE" "$backup_file"
fi

echo "[install_config] copying config to: $DEST_FILE"
cp "$SRC_FILE" "$DEST_FILE"

echo "[install_config] IMPORTANT: edit allowlists and channel settings before enabling channels."
echo "[install_config] done"
