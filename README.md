# dotfiles.omarchy

Personal dotfiles and configuration overrides for [Omarchy](https://github.com/basecamp/omarchy) — an opinionated Arch Linux environment.

## Philosophy

Omarchy manages the base configuration. This repository layers personal preferences on top without touching what Omarchy owns, keeping updates safe and conflict-free.

## Structure

```
dotfiles.omarchy/
├── git/
│   └── config.local      # Git aliases, GPG signing key, local overrides
│                         # included via [include] in ~/.config/git/config
└── README.md
```

## Git

Omarchy manages `~/.config/git/config` (user identity, base settings).
Personal overrides live in `~/.config/git/config.local`, included at the end of omarchy's config:

```ini
[include]
    path = ~/.config/git/config.local
```

`config.local` contains:
- GPG commit signing (`commit.gpgsign = true`)
- Extra aliases (`ll`, `lg`, `wip`, `undo`, `amend`, `bclean`, etc.)

## Setup

```bash
git clone git@github.com:flaviomilan/dotfiles.omarchy.git ~/Work/projects/dotfiles.omarchy

# Git local overrides
cp git/config.local ~/.config/git/config.local

# Add include to omarchy's git config (if not already present)
echo -e '\n[include]\n\tpath = ~/.config/git/config.local' >> ~/.config/git/config
```

## GPG Signing

The private key is stored in 1Password. Run the setup script to import it and configure git automatically:

```bash
bash scripts/import-gpg.sh
```

The script will:
1. Sign in to 1Password CLI (`op`)
2. Ask for the item name (default: `GPG Key - private`)
3. Import the key into the local GPG keyring
4. Set ultimate trust
5. Configure `user.signingkey` and `commit.gpgsign = true` in global git config
