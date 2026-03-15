# dotfiles

Shared shell and Git defaults for personal machines.

## Goal

This repo is the portable baseline:

- shared `zsh` behavior
- shared aliases
- shared Git defaults
- shared prompt config

This repo is not the place for:

- secrets
- API keys
- service account tokens
- machine-specific app paths
- laptop-only signing config

Those belong in local-only files outside git.

## Layout

- [`.zshrc`](/Users/rgarcia/gh/dotfiles/.zshrc): shared shell config
- [`.aliases`](/Users/rgarcia/gh/dotfiles/.aliases): shared aliases
- [`.gitconfig`](/Users/rgarcia/gh/dotfiles/.gitconfig): shared Git config
- [`.gitignore_global`](/Users/rgarcia/gh/dotfiles/.gitignore_global): shared global Git ignore
- [starship.toml](/Users/rgarcia/gh/dotfiles/starship.toml): shared prompt config
- [`.tmux.conf`](/Users/rgarcia/gh/dotfiles/.tmux.conf): shared tmux defaults
- [`.zshrc.local.example`](/Users/rgarcia/gh/dotfiles/.zshrc.local.example): example machine-local shell overlay
- [`.gitconfig.local.example`](/Users/rgarcia/gh/dotfiles/.gitconfig.local.example): example machine-local Git overlay
- [bootstrap.sh](/Users/rgarcia/gh/dotfiles/bootstrap.sh): idempotent machine bootstrap helper
- [bootstrap-linux-packages.sh](/Users/rgarcia/gh/dotfiles/bootstrap-linux-packages.sh): install the Linux package/tool baseline
- [pi-backup-config.sh](/Users/rgarcia/gh/dotfiles/pi-backup-config.sh): Pi config backup script

## Local Files

Expected local-only files:

- `~/.zshrc.local`
- `~/.gitconfig.local`
- `~/.config/shell/env.sh`
- `~/.config/op/service-account.env`

Examples:

```zsh
# ~/.zshrc.local
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
[ -f "$HOME/.openclaw/completions/openclaw.zsh" ] && source "$HOME/.openclaw/completions/openclaw.zsh"
```

```zsh
# ~/.config/shell/env.sh
export GEMINI_API_KEY="..."
export TELEGRAM_BOT_TOKEN="..."
```

```zsh
# ~/.config/op/service-account.env
export OP_SERVICE_ACCOUNT_TOKEN="..."
```

```gitconfig
# ~/.gitconfig.local
[gpg]
    format = ssh
[gpg "ssh"]
    program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
[commit]
    gpgsign = true
[user]
    signingkey = ssh-ed25519 AAAA_replace_me
```

## Mac Setup

Typical layout on macOS:

```bash
ln -sfn ~/gh/dotfiles/.zshrc ~/.zshrc
ln -sfn ~/gh/dotfiles/.aliases ~/.aliases
ln -sfn ~/gh/dotfiles/.gitignore_global ~/.gitignore_global
ln -sfn ~/gh/dotfiles/starship.toml ~/.config/starship.toml
```

Use a small top-level Git config that includes the repo config:

```gitconfig
[include]
    path = /Users/you/gh/dotfiles/.gitconfig
```

Then keep machine-specific overrides in `~/.gitconfig.local`.

Bootstrap option:

```bash
~/gh/dotfiles/bootstrap.sh
```

If you are bringing up a Linux dev box or Raspberry Pi, run:

```bash
~/gh/dotfiles/bootstrap-linux-packages.sh
~/gh/dotfiles/bootstrap.sh
```

## Linux / Pi Setup

For Linux or Raspberry Pi:

- clone the repo to `~/gh/dotfiles`
- install the needed tools separately (`zsh`, `git`, `starship`, etc.)
- point low-risk shared files at the repo
- keep secrets and host-specific paths in local files

Example:

```bash
ln -sfn ~/gh/dotfiles/.gitignore_global ~/.gitignore_global
ln -sfn ~/gh/dotfiles/starship.toml ~/.config/starship.toml
```

Bootstrap option:

```bash
~/gh/dotfiles/bootstrap.sh
```

Whether `~/.zshrc` itself should symlink to the repo depends on how much host-specific customization that machine needs. If a machine has heavier local differences, keep a small host-specific `~/.zshrc` that sources the shared pieces.

For Raspberry Pi, this repo also includes:

- a package bootstrap script
- a tmux config
- a config backup script
- a user-level `systemd` timer template for daily config backups

## Rules

- Never commit secrets.
- Never commit tokens copied from a live shell.
- Prefer local includes/overlays over editing shared files for one machine.
- If a config path contains `/Users/...` or another host-specific absolute path, it probably belongs in a local file.

## Updating

When changing config:

1. Put shared behavior in this repo.
2. Put machine-specific behavior in local files.
3. Verify the change on the current machine.
4. Commit only the shared files.

That keeps future laptop or Pi setup straightforward and avoids leaking credentials.
