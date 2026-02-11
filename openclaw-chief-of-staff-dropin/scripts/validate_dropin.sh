#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0

echo "[validate] root=$ROOT_DIR"

validate_bash_syntax() {
  local file="$1"
  if /bin/bash -n "$file"; then
    echo "[validate] bash syntax ok: $file"
  else
    echo "[validate] bash syntax failed: $file"
    errors=1
  fi
}

validate_plist() {
  local file="$1"
  if plutil -lint "$file" >/dev/null; then
    echo "[validate] plist ok: $file"
  else
    echo "[validate] plist failed: $file"
    errors=1
  fi
}

check_mirror_match() {
  local src="$1"
  local mirror="$2"
  if cmp -s "$src" "$mirror"; then
    echo "[validate] mirror match: $(basename "$src")"
  else
    echo "[validate] mirror mismatch: $src != $mirror"
    errors=1
  fi
}

for file in "$ROOT_DIR"/scripts/*.sh "$ROOT_DIR"/workspace/ops/*.sh "$ROOT_DIR"/workspace/skills/backup-ops/scripts/*.sh; do
  validate_bash_syntax "$file"
done

for file in "$ROOT_DIR"/launchd/*.plist; do
  validate_plist "$file"
done

check_mirror_match "$ROOT_DIR/scripts/backup_sqlite.sh" "$ROOT_DIR/workspace/ops/backup_sqlite.sh"
check_mirror_match "$ROOT_DIR/scripts/git_sync.sh" "$ROOT_DIR/workspace/ops/git_sync.sh"
check_mirror_match "$ROOT_DIR/scripts/rclone_sync.sh" "$ROOT_DIR/workspace/ops/rclone_sync.sh"
check_mirror_match "$ROOT_DIR/scripts/backup_sqlite.sh" "$ROOT_DIR/workspace/skills/backup-ops/scripts/backup_sqlite.sh"
check_mirror_match "$ROOT_DIR/scripts/git_sync.sh" "$ROOT_DIR/workspace/skills/backup-ops/scripts/git_sync.sh"
check_mirror_match "$ROOT_DIR/scripts/rclone_sync.sh" "$ROOT_DIR/workspace/skills/backup-ops/scripts/rclone_sync.sh"

if [[ "$errors" -ne 0 ]]; then
  echo "[validate] failed"
  exit 1
fi

echo "[validate] passed"
