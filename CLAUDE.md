# CLAUDE.md

Chezmoi-managed dotfiles for the book **Tech Tools**, which teaches terminal, neovim, tmux, and related workflows.

## What this repo is

Config files that chezmoi deploys to `~/`. The target audience is readers of the book who are setting up their environment from scratch.

## Chezmoi conventions

- `dot_*` → `~/.` (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- `private_dot_config/` → `~/.config/` (neovim lives here)
- `executable_*` → deployed with executable permission
- `run_once_*` → scripts chezmoi runs once on first `chezmoi apply`
- `.tmpl` suffix → Go templates, processed by chezmoi before deployment
- Only template variable used is `.chezmoi.os` (`"linux"` or `"darwin"`)

## Key structure

- `private_dot_config/nvim/` — Neovim config (Lua, lazy.nvim plugin manager)
- `dot_tmux/` — Tmux scripts and helpers
- `bin/` — Utility scripts (session management, pomodoro timer)
- `notes/` — zk (Zettelkasten) note templates
- `run_once_install-packages.sh.tmpl` — First-run package installation (Homebrew)
- `config_manager.sh` — Backup/restore utility

## Design principles

- Vi keybindings everywhere (zsh, tmux, neovim, readline)
- Space is neovim leader key; Ctrl+Space is tmux prefix
- Ctrl+h/j/k/l for consistent pane navigation across tmux and neovim
- Prezto + zplug for zsh; Powerlevel10k theme
- Local override files (`.zshrc_local`, `.tmux.conf.local`, `.profile`) are sourced if present

## Common tasks

- **Test a config change**: `chezmoi apply` deploys from this repo to `~/`
- **Preview diff**: `chezmoi diff` shows what would change
- **Edit in place**: `chezmoi edit <file>` opens the source file for a managed target
