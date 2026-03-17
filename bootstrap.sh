#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/shell"
mkdir -p "$HOME/.config/op"
mkdir -p "$HOME/.local/bin"

ln -sfn "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
ln -sfn "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
ln -sfn "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

if [ -d "$DOTFILES_DIR/bin" ]; then
  for script in "$DOTFILES_DIR"/bin/*; do
    [ -f "$script" ] || continue
    ln -sfn "$script" "$HOME/.local/bin/$(basename "$script")"
  done
fi

cat > "$HOME/.gitconfig" <<EOF
[include]
    path = $DOTFILES_DIR/.gitconfig
EOF

if [ ! -f "$HOME/.zshrc.local" ]; then
  cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
fi

if [ ! -f "$HOME/.gitconfig.local" ]; then
  cp "$DOTFILES_DIR/.gitconfig.local.example" "$HOME/.gitconfig.local"
fi

if [ ! -f "$HOME/.config/shell/env.sh" ]; then
  cat > "$HOME/.config/shell/env.sh" <<'EOF'
# Local secrets and machine-specific environment variables.
EOF
fi

if [ ! -f "$HOME/.config/op/service-account.env" ]; then
  cat > "$HOME/.config/op/service-account.env" <<'EOF'
# export OP_SERVICE_ACCOUNT_TOKEN="replace-me"
EOF
fi

echo "Dotfiles bootstrapped from $DOTFILES_DIR"
