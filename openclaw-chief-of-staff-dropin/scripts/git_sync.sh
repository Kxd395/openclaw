#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${OPENCLAW_WORKSPACE_GIT_REPO:-$HOME/.openclaw/workspace}"

cd "$REPO_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[git_sync] not a git repo: $REPO_DIR"
  echo "[git_sync] initialize a repo in this folder and set an origin remote, then re-run."
  exit 2
fi

branch="$(git symbolic-ref --quiet --short HEAD || true)"
if [[ "$branch" == "HEAD" ]]; then
  echo "[git_sync] detached HEAD detected; checkout a branch before syncing"
  exit 2
fi
if [[ -z "$branch" ]]; then
  echo "[git_sync] unable to determine current branch"
  exit 2
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "[git_sync] missing origin remote for repo: $REPO_DIR"
  echo "[git_sync] add origin remote, then re-run"
  exit 2
fi

if [[ -z "$(git config --get user.name || true)" ]] || [[ -z "$(git config --get user.email || true)" ]]; then
  echo "[git_sync] git user.name/user.email are not configured"
  echo "[git_sync] set identity, for example:"
  echo "  git config user.name 'OpenClaw Bot'"
  echo "  git config user.email 'openclaw@example.com'"
  exit 2
fi

# Stage everything that is not ignored.
git add -A

if git diff --cached --quiet; then
  echo "[git_sync] no changes to commit"
  exit 0
fi

ts="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"
git commit -m "sync: $ts" >/dev/null

echo "[git_sync] pushing branch $branch"
git push origin "$branch"
echo "[git_sync] done"
