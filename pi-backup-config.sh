#!/usr/bin/env bash
set -euo pipefail

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP_ROOT="${HOME}/backups/pi-config"
TARGET_DIR="${BACKUP_ROOT}/${STAMP}"

mkdir -p "${TARGET_DIR}"

tar -czf "${TARGET_DIR}/home-config.tgz" \
  -C "${HOME}" \
  .zshrc \
  .zshrc.local \
  .aliases \
  .gitconfig \
  .gitconfig.local \
  .tmux.conf \
  .ssh \
  .config/shell \
  .config/op \
  .config/gh \
  .config/starship.toml \
  .codex \
  .gemini

dpkg --get-selections > "${TARGET_DIR}/dpkg-selections.txt"
systemctl list-unit-files > "${TARGET_DIR}/systemd-unit-files.txt"
git -C "${HOME}/gh/dotfiles" rev-parse HEAD > "${TARGET_DIR}/dotfiles-rev.txt"

find "${BACKUP_ROOT}" -mindepth 1 -maxdepth 1 -type d | sort | head -n -7 | xargs -r rm -rf

echo "Backup created at ${TARGET_DIR}"
