# New Terminal Tools Guide

Here is a quick guide on how to use the new productivity tools installed in your terminal.

## 1. eza (Modern `ls`)
**What it is**: A colorful, feature-rich replacement for `ls`.
**Aliases**: I've already aliased `ls`, `ll`, and `la` to use `eza`.

*   **List files**: `ls` or `ll` (long format)
*   **Tree view**: `eza --tree` (shows directory structure)
*   **Tree with depth**: `eza --tree --level=2`

## 2. bat (Better `cat`)
**What it is**: A `cat` clone with syntax highlighting and git integration.
**Aliases**: `cat` is aliased to `bat`.

*   **View file**: `cat filename.py` (shows syntax highlighting)
*   **View file with paging**: `bat filename.py` (automatically pages long files)

## 3. zoxide (Smarter `cd`)
**What it is**: Remembers which directories you use most frequently, so you can "jump" to them in a few keystrokes.

*   **Jump to directory**: `z dot` (might jump to `~/gh/dotfiles`)
*   **Interactive selection**: `zi` (opens fzf to select a directory from history)
*   **Go back**: `z -`

## 4. delta (Better Git Diffs)
**What it is**: A syntax-highlighting pager for git.
**Usage**: Just use `git diff`, `git show`, or `git log -p` as usual. You will see:
*   Side-by-side diffs (if configured)
*   Syntax highlighting within the diffs
*   Line numbers

## 5. ripgrep (Faster `grep`)
**What it is**: A line-oriented search tool that recursively searches your current directory.

*   **Search for text**: `rg "search_term"`
*   **Search specific file types**: `rg "search_term" -t py` (only python files)
*   **Search ignoring case**: `rg -i "search_term"`
*   **Filenames only**: `rg -l "search_term"`

## 6. tldr (Simplified Man Pages)
**What it is**: Community-driven man pages that give you practical examples.

*   **Get examples**: `tldr tar`
*   **Get examples for git**: `tldr git checkout`

## 7. fzf (Fuzzy Finder)
**What it is**: A general-purpose command-line fuzzy finder.
**Keybindings** (now enabled in zsh):
*   **Ctrl+R**: Search command history
*   **Ctrl+T**: Search for files and paste selected path onto command line
*   **Alt+C**: Search for directories and `cd` into them

## 8. Atuin (Magical Shell History)
**What it is**: A complete replacement for your shell history. It stores every command you run in a database, recording the time, duration, and directory.

*   **Search History**: Press `Ctrl+R` (replaces the default reverse search).
*   **Filter by Directory**: In the search UI, press `Ctrl+R` again to toggle between "Global" history and "Current Directory" history.
*   **Sync**: If you want to sync history between machines, run `atuin register` and `atuin login`.

### Migrating History to a New Machine
The easiest way to migrate is to use Atuin's built-in sync.

1.  **On old machine**:
    *   `atuin register -u <username> -e <email>` (if you haven't already)
    *   `atuin import auto` (to import your old shell history)
    *   `atuin sync`

2.  **On new machine**:
    *   `atuin login -u <username>`
    *   `atuin sync`

Your history will automatically download. You can also export manually with `atuin history list --format json > history.json` and import with `atuin history import --format json history.json`.

## 9. histgrep
**What it is**: A custom function to search your history (and archived history if available).

*   **Usage**: `histgrep "command"`
*   **Note**: This searches both your active Zsh history AND your archived history in `~/.history`.

## 10. History Archiving
I've enabled a script that automatically archives every command you run to `~/.history/YYYY/MM/YYYY-MM-DD.history`. This ensures you have an infinite backup of your commands, which `histgrep` uses.
