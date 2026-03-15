#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap script currently supports apt-based Linux systems only."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y \
  zsh \
  git \
  curl \
  wget \
  unzip \
  ca-certificates \
  jq \
  ripgrep \
  fd-find \
  fzf \
  bat \
  eza \
  direnv \
  zoxide \
  atuin \
  starship \
  gh \
  nodejs \
  npm \
  python3 \
  python3-venv \
  python3-pip \
  python3-dev \
  pipx \
  python-is-python3 \
  tmux \
  docker.io \
  docker-compose \
  rsync \
  unattended-upgrades

mkdir -p "$HOME/.local/bin"

if command -v batcat >/dev/null 2>&1; then
  ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

if command -v fdfind >/dev/null 2>&1; then
  ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if ! command -v uv >/dev/null 2>&1; then
  pipx install uv
fi

sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo systemctl enable --now unattended-upgrades

echo "Linux package bootstrap complete."
