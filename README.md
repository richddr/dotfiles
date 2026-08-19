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
- helper scripts under `bin/`
- a config backup script
- a user-level `systemd` timer template for daily config backups

## Pi Codex Session

The Pi is the canonical long-lived dev host. For mobile continuity, keep `codex`
running inside a tmux session on the Pi and reattach from other devices instead
of starting a new local session elsewhere.

Helpers installed by `bootstrap.sh`:

- `codex-session`: attach to `tmux` session `codex`, or create it in `~/gh/project-alpha`
- `codex-detach`: detach the current tmux client, or detach the `codex` session from another shell
- `codex-status`: show whether the `codex` tmux session exists and whether it is attached

Typical flow on the Pi:

```bash
codex-session
cd ~/gh/project-alpha
codex
```

From another device later:

```bash
ssh rgarcia-pi5-remote
codex-session
```

### Termius Snippets

Mobile keyboards make `Ctrl-b d` awkward. In Termius, prefer snippets:

- `Attach Codex`

```bash
codex-session
```

- `Detach Codex`

```bash
tmux detach-client
```

- `Steal/reattach Codex`

```bash
codex-session
```

- `List tmux`

```bash
tmux ls
```

- `Codex status`

```bash
codex-status
```

Use `tmux detach-client` when you are already inside tmux. Use `codex-session`
when you want to take the session back from another device.

## Pi Infrastructure & Home Operations

For Docker stacks (Home Assistant, AdGuard Home), network topology (Tailscale Subnet Routing & Exit Node), systemd backup units, and UPS runbooks, see the dedicated infrastructure repository:

- [home-ops](https://github.com/richddr/home-ops)

## Pi SSH Access

The current Pi setup uses key-only SSH.

Applied settings:

- `PasswordAuthentication no`
- `KbdInteractiveAuthentication no`
- `ChallengeResponseAuthentication no`
- `PermitRootLogin no`
- `PubkeyAuthentication yes`

The override file lives at:

- `/etc/ssh/sshd_config.d/99-hardening.conf`

### Verify Current SSH Settings

```bash
sudo /usr/sbin/sshd -T | rg 'passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication'
```

### OpenClaw UI From Another Machine

The Pi OpenClaw gateway is intentionally bound to loopback only.

To access the Pi-hosted web UI from a Mac, use an SSH tunnel:

```bash
ssh -N rgarcia-pi5-remote-openclaw
```

Then open:

```text
http://openclaw-pi.localhost:18789/
```

Recommended convenience setup:

- SSH host alias: `rgarcia-pi5-remote-openclaw`
- shell alias: `openclaw-pi-tunnel`

With that in place:

```bash
openclaw-pi-tunnel
```

Then browse to:

```text
http://openclaw-pi.localhost:18789/
```

The older `rgarcia-pi5-openclaw` alias still works for local-network `.local` access, but the remote/Tailscale alias above is the preferred default.

Equivalent URLs that also work:

- `http://localhost:18789/`
- `http://127.0.0.1:18789/`

If the dashboard shows `unauthorized: gateway token missing`, paste the
gateway token into the UI once. In this setup the token is SecretRef-managed,
so `openclaw dashboard` intentionally does not print a tokenized URL.

The token lives in 1Password at:

- `OpenClaw` -> `gateway_auth_token` -> `credential`

### Add a New Machine

From the new machine:

```bash
ssh-keygen -t ed25519
ssh-copy-id richddr@rgarcia-pi5.local
```

Or manually append the new public key on the Pi:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
printf '%s\n' 'ssh-ed25519 AAAA... new-machine' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### If You Lose Access to the Current SSH Key

Use one of these recovery paths:

1. Use another already-authorized machine and add a new key to `~/.ssh/authorized_keys`.
2. Use local console access on the Pi with keyboard/monitor and add a new key manually.
3. Temporarily re-enable password SSH from the local console, log in once from the new machine, add the new key, then disable password SSH again.

### Re-enable Password SSH

From local console access on the Pi:

```bash
sudo rm /etc/ssh/sshd_config.d/99-hardening.conf
sudo systemctl restart ssh
```

Or edit the override file directly:

```bash
sudoedit /etc/ssh/sshd_config.d/99-hardening.conf
sudo systemctl restart ssh
```

To explicitly allow passwords again, use:

```conf
PasswordAuthentication yes
KbdInteractiveAuthentication yes
ChallengeResponseAuthentication yes
```

### Disable Password SSH Again

Recreate the hardening override:

```bash
cat <<'EOF' | sudo tee /etc/ssh/sshd_config.d/99-hardening.conf >/dev/null
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
X11Forwarding no
AllowTcpForwarding local
EOF
sudo /usr/sbin/sshd -t
sudo systemctl restart ssh
```

### Recommended Practice

- Keep at least two authorized machines/keys for the Pi.
- Keep one recovery path available: local console, a second admin machine, or both.
- Prefer adding a new key over re-enabling password SSH.

### Re-enable Bluetooth or ModemManager on the Pi

If you previously hardened the Pi by disabling these services, re-enable them with:

```bash
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now ModemManager.service
```

To disable them again:

```bash
sudo systemctl disable --now bluetooth.service
sudo systemctl disable --now ModemManager.service
```

Use this only if you actually need Bluetooth peripherals or modem/cellular support on the Pi.

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

## New Machine Checklist

### macOS

1. Install base tooling:
   - Homebrew
   - `git`
   - `zsh`
   - `starship`
   - `gh`
   - `op`
   - `tmux`
   - `node`
   - `pipx`
2. Clone this repo to `~/gh/dotfiles`.
3. Run:

```bash
~/gh/dotfiles/bootstrap.sh
```

4. Create local-only files as needed:
   - `~/.zshrc.local`
   - `~/.gitconfig.local`
   - `~/.config/shell/env.sh`
   - `~/.config/op/service-account.env`
5. Configure GitHub auth:

```bash
gh auth login
```

6. Verify:

```bash
zsh -lic 'echo shell_ok'
git config user.email
starship --version
```

### Raspberry Pi / Linux

1. Install Raspberry Pi OS or Debian and enable:
   - Wi-Fi
   - SSH
2. Clone this repo to `~/gh/dotfiles`.
3. Run:

```bash
~/gh/dotfiles/bootstrap-linux-packages.sh
~/gh/dotfiles/bootstrap.sh
```

4. Create local-only files:
   - `~/.zshrc.local`
   - `~/.gitconfig.local`
   - `~/.config/shell/env.sh`
   - `~/.config/op/service-account.env`
5. Configure auth as needed:
   - `gh auth login`
   - add SSH key to GitHub
   - set `GEMINI_API_KEY`
   - set `OP_SERVICE_ACCOUNT_TOKEN`
6. Optional Pi follow-up:
   - migrate root to NVMe
   - enable config backup timer
   - harden SSH to key-only auth
7. Verify:

```bash
findmnt -no SOURCE /
gh auth status
docker ps
tmux -V
uv --version
```
