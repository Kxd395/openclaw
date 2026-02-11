#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${OPENCLAW_HOME:-$HOME/.openclaw}"
WORKSPACE_DIR="${OPENCLAW_WORKSPACE:-$BASE_DIR/workspace}"
OUT_DIR="$WORKSPACE_DIR/backups/sqlite"

mkdir -p "$OUT_DIR"

ts="$(date +"%Y-%m-%d_%H%M%S")"

echo "[backup_sqlite] base=$BASE_DIR"
echo "[backup_sqlite] workspace=$WORKSPACE_DIR"
echo "[backup_sqlite] out=$OUT_DIR"
echo "[backup_sqlite] ts=$ts"

if ! command -v sqlite3 >/dev/null 2>&1; then
  echo "[backup_sqlite] sqlite3 is not installed"
  echo "[backup_sqlite] install sqlite3 before running backups"
  exit 2
fi

# Find likely SQLite files. We avoid backups and node_modules if present.
# Use a Bash 3-compatible loop because launchd typically runs /bin/bash on macOS.
dbs=()
while IFS= read -r -d '' db; do
  dbs+=("$db")
done < <(
  find "$BASE_DIR" \
    -type f \
    \( -name "*.db" -o -name "*.sqlite" -o -name "*.sqlite3" \) \
    ! -path "*/backups/*" \
    ! -path "*/node_modules/*" \
    -print0 \
    2>/dev/null
)

if [[ "${#dbs[@]}" -eq 0 ]]; then
  echo "[backup_sqlite] no sqlite files found under $BASE_DIR"
  exit 0
fi

failed=0
for src in "${dbs[@]}"; do
  rel="$src"
  if [[ "$src" == "$BASE_DIR/"* ]]; then
    rel="${src#$BASE_DIR/}"
  fi

  # Encode relative path to avoid filename collisions for same basename in different folders.
  safe_rel="${rel//\//__}"
  safe_rel="${safe_rel// /_}"
  safe_rel="${safe_rel//:/_}"
  safe_rel="${safe_rel//[^A-Za-z0-9._-]/_}"

  dest="$OUT_DIR/${safe_rel}.${ts}.bak.sqlite"
  echo "[backup_sqlite] sqlite3 .backup: $src -> $dest"
  if ! sqlite3 "$src" ".backup '$dest'"; then
    echo "[backup_sqlite] failed backup for: $src"
    failed=1
  fi
done

if [[ "$failed" -ne 0 ]]; then
  echo "[backup_sqlite] completed with errors"
  exit 1
fi

echo "[backup_sqlite] done"
