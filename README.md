# dotfiles.omarchy

Personal dotfiles overlay for [Omarchy](https://github.com/basecamp/omarchy) — the omakase Arch Linux distribution by DHH.

## Philosophy

> Omarchy manages the base. This repo layers personal preferences on top — never replacing what Omarchy owns.

**What Omarchy handles** (don't touch): terminal themes, Hyprland, Waybar, Walker, Starship prompt, shell defaults (eza, fzf, zoxide, etc.), and base Neovim/LazyVim setup.

**What this repo adds**: git aliases, Neovim plugins for my workflow (Rails, AI, OSINT, Go), personal bash shortcuts, and GPG signing.

## Structure

```text
dotfiles.omarchy/
├── bash/
│   └── bashrc.local          # Personal bash aliases & functions
├── git/
│   └── config.local          # Git aliases, GPG signing, local overrides
├── nvim/
│   └── lua/
│       ├── config/
│       │   ├── lazy.lua      # LazyVim extras (languages, AI, tools)
│       │   ├── keymaps.lua   # Custom keymaps (indent, select all)
│       │   ├── options.lua   # Editor options (relative numbers, scroll)
│       │   └── autocmds.lua  # Autocmds (LSP error suppression)
│       └── plugins/
│           ├── user-ai.lua                    # AI (Copilot via extras)
│           ├── user-tools.lua                 # Oil, smart-splits, octo, Rails nav
│           ├── user-lang.lua                  # Neotest adapters, Bash LSP
│           ├── disable-news-alert.lua         # Disable LazyVim news popup
│           └── snacks-animated-scrolling-off.lua  # Disable scroll animation
├── scripts/
│   ├── import-gpg.sh         # Import GPG key from 1Password
│   └── setup-nvim.sh         # Symlink nvim configs into ~/.config/nvim/
└── install.sh                # One-command setup (idempotent)
```

## Quick Start

```bash
git clone git@github.com:flaviomilan/dotfiles.omarchy.git ~/Work/projects/dotfiles.omarchy
cd ~/Work/projects/dotfiles.omarchy
./install.sh
```

The installer will:

1. **Git** — Copy `config.local` to `~/.config/git/` and add the `[include]` directive
2. **Neovim** — Symlink personal plugins/config into `~/.config/nvim/`
3. **Bash** — Install `~/.bashrc.local` and source it from `~/.bashrc`
4. **GPG** — Optionally import signing key from 1Password

Run with `--all` for non-interactive mode.

## What's Included

### Git Aliases

Omarchy provides: `co`, `br`, `ci`, `st`, `pl`, `plr`. This overlay adds:

| Alias | Command | Purpose |
|-------|---------|---------|
| `sw` | `switch` | Switch branches |
| `undo` | `reset --soft HEAD~1` | Undo last commit (keep changes) |
| `amend` | `commit --amend --no-edit` | Amend last commit |
| `wip` | Add all + commit "wip [skip ci]" | Quick work-in-progress save |
| `unwip` | Reset HEAD~1 if last was wip | Undo wip commit |
| `lg` | `log --oneline --graph --all` | Visual branch graph |
| `ll` | `log --oneline -20` | Quick recent history |
| `bclean` | Delete merged branches | Branch cleanup |
| `gone` | List branches with deleted remotes | Find stale branches |

See `git/config.local` for the full list.

### Neovim Plugins

Built on top of Omarchy's LazyVim base:

- **AI**: GitHub Copilot + Copilot Chat (via LazyVim extras)
- **Navigation**: Oil.nvim (file browser), smart-splits (tmux-aware panes)
- **Rails**: vim-rails, vim-projectionist, vim-bundler, neotest-minitest, neotest-rspec
- **Go**: neotest-golang (auto-disabled if Go not in PATH)
- **Tools**: octo.nvim (GitHub in Neovim), Bash LSP

### Bash Overlay

Minimal additions that complement Omarchy's defaults:

- `be` — `bundle exec`
- `dc` — `docker compose`
- `mkcd` — Create directory and cd into it

### GPG Signing

```bash
bash scripts/import-gpg.sh
```

Imports GPG private key from 1Password and configures git for signed commits.

## Uninstall

To restore stock Omarchy configs:

```bash
# Remove neovim symlinks (originals backed up as *.bak.*)
cd ~/.config/nvim/lua
find . -type l -lname '*/dotfiles.omarchy/*' -delete

# Remove bash overlay
rm ~/.bashrc.local
# Edit ~/.bashrc to remove the source line for .bashrc.local

# Remove git overlay
rm ~/.config/git/config.local
# Edit ~/.config/git/config to remove the [include] section
```

## Related

- **[dotfiles](https://github.com/flaviomilan/dotfiles)** — Full development environment for macOS (GNU Stow, installer, multi-platform)
