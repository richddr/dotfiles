# Dotfiles Agent Guide

This repo is a personal shell/editor/bootstrap/tooling repo. Treat it as
high-leverage infrastructure: small changes here can affect every terminal
session, bootstrap flow, and helper command.

## Read This First

Before editing, read:

1. [README.md](/Users/rgarcia/gh/dotfiles/README.md)
2. [tools_guide.md](/Users/rgarcia/gh/dotfiles/tools_guide.md)

If a change touches Pi/Codex session helpers, also inspect:

- [bin/codex-session](/Users/rgarcia/gh/dotfiles/bin/codex-session)
- [bin/codex-status](/Users/rgarcia/gh/dotfiles/bin/codex-status)
- [bin/codex-detach](/Users/rgarcia/gh/dotfiles/bin/codex-detach)

## Safe Editing Rules

- Prefer small, reversible changes.
- Do not casually reorder `PATH`, shell init flow, or login-shell behavior.
- Assume shell startup files are user-critical and can break daily workflows.
- Preserve existing comments and user-facing ergonomics where possible.
- Avoid adding machine-specific assumptions unless the repo already uses that
  pattern intentionally.

## Repo Structure

Key files:

- [.zshrc](/Users/rgarcia/gh/dotfiles/.zshrc)
- [.aliases](/Users/rgarcia/gh/dotfiles/.aliases)
- [.bashrc](/Users/rgarcia/gh/dotfiles/.bashrc)
- [.bash_profile](/Users/rgarcia/gh/dotfiles/.bash_profile)
- [.profile](/Users/rgarcia/gh/dotfiles/.profile)
- [.gitconfig](/Users/rgarcia/gh/dotfiles/.gitconfig)
- [.tmux.conf](/Users/rgarcia/gh/dotfiles/.tmux.conf)
- [bootstrap.sh](/Users/rgarcia/gh/dotfiles/bootstrap.sh)
- [bootstrap-linux-packages.sh](/Users/rgarcia/gh/dotfiles/bootstrap-linux-packages.sh)
- [bin/](/Users/rgarcia/gh/dotfiles/bin)

Example/local override files are intentional:

- [.gitconfig.local.example](/Users/rgarcia/gh/dotfiles/.gitconfig.local.example)
- [.zshrc.local.example](/Users/rgarcia/gh/dotfiles/.zshrc.local.example)

Use those patterns instead of hardcoding host- or user-specific secrets.

For server-level Docker compose stacks, network topologies, DNS (AdGuard Home), and homelab infrastructure, see the separate [richddr/home-ops](https://github.com/richddr/home-ops) repository.

## Validation Expectations

After editing shell or bootstrap files, run the smallest relevant checks.

Examples:

- shell syntax:
  - `zsh -n .zshrc`
  - `bash -n .bashrc`
  - `bash -n bootstrap.sh`
- quick helper smoke tests:
  - invoke or dry-run the changed helper if safe
- formatting/sanity:
  - `git diff --check`

Do not claim a shell/bootstrap change is safe without at least syntax-checking
the touched scripts.

## Secrets And Local State

- Never commit secrets, tokens, or machine-local credentials.
- Prefer `.example` files, local overrides, or external secret managers.
- Be careful with files like:
  - [.env](/Users/rgarcia/gh/dotfiles/.env)
  - local git config includes
  - shell-local override files

If a change needs host-specific data, document the pattern without committing
the real value.

## Pi / Codex Helper Guidance

This repo contains operational helpers for the Pi/Codex workflow. Changes here
can affect agent attachment/detach behavior and day-to-day remote workflows.

If modifying those helpers:

- preserve backward-compatible behavior when possible
- avoid destructive `tmux` or SSH logic
- test carefully before assuming the remote workflow is safe

## What To Avoid

- silent prompt/theme overhauls unless explicitly requested
- destructive cleanup in bootstrap scripts
- broad refactors of shell init files without a clear reason
- changing default aliases or helper semantics without noting it clearly

## Goal

Help future agents make safe, comprehensible changes to personal environment
infrastructure without breaking the user’s shell, editor, bootstrap, or remote
session workflows.
