#!/usr/bin/env bash
# install.sh — Setup personal dotfiles overlay for Omarchy
# Safe to run multiple times (idempotent).
#
# Usage:
#   ./install.sh           # Interactive setup
#   ./install.sh --all     # Non-interactive, install everything
#   ./install.sh --help    # Show usage

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colour helpers ───────────────────────────────────────────────────
info()  { printf "\033[34m[dotfiles]\033[0m %s\n" "$1"; }
ok()    { printf "\033[32m[dotfiles]\033[0m %s\n" "$1"; }
warn()  { printf "\033[33m[dotfiles]\033[0m %s\n" "$1"; }
err()   { printf "\033[31m[dotfiles]\033[0m %s\n" "$1" >&2; }
ask()   { printf "\033[35m[dotfiles]\033[0m %s " "$1"; }

ALL=false
if [[ "${1:-}" == "--all" ]]; then ALL=true; fi
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: ./install.sh [--all|--help]"
  echo "  --all   Non-interactive, install everything"
  echo "  --help  Show this help"
  exit 0
fi

confirm() {
  if $ALL; then return 0; fi
  ask "$1 [Y/n]"
  read -r reply
  [[ -z "$reply" || "$reply" =~ ^[Yy] ]]
}

# ── Verify Omarchy ──────────────────────────────────────────────────
if [ ! -d "$HOME/.local/share/omarchy" ]; then
  err "Omarchy not detected. This overlay is designed for Omarchy systems."
  err "See: https://omarchy.org"
  exit 1
fi

ok "Omarchy detected"
echo ""

# ── 1. Git config ───────────────────────────────────────────────────
info "── Git Configuration ──"

GIT_SRC="$SCRIPT_DIR/git/config.local"
GIT_DST="$HOME/.config/git/config.local"
GIT_MAIN="$HOME/.config/git/config"

if [ -f "$GIT_SRC" ]; then
  if [ -f "$GIT_DST" ] && diff -q "$GIT_SRC" "$GIT_DST" > /dev/null 2>&1; then
    ok "Git config.local already up to date"
  elif [ -f "$GIT_DST" ] && grep -q '\[alias\]' "$GIT_DST" 2>/dev/null; then
    # Existing config.local has aliases — likely already set up (may have signing key we shouldn't overwrite)
    ok "Git config.local already exists with aliases (keeping your signing key intact)"
  elif confirm "Install git aliases and config.local?"; then
    if [ -f "$GIT_DST" ]; then
      backup="${GIT_DST}.bak.$(date +%Y%m%d%H%M%S)"
      warn "Backing up existing: config.local → $(basename "$backup")"
      cp "$GIT_DST" "$backup"
    fi
    mkdir -p "$(dirname "$GIT_DST")"
    cp "$GIT_SRC" "$GIT_DST"
    ok "Installed git config.local"
  fi

  # Ensure the include directive exists in the main config
  if ! grep -q 'path = ~/.config/git/config.local' "$GIT_MAIN" 2>/dev/null; then
    printf '\n[include]\n\tpath = ~/.config/git/config.local\n' >> "$GIT_MAIN"
    ok "Added [include] directive to git config"
  fi
fi
echo ""

# ── 2. Neovim ───────────────────────────────────────────────────────
info "── Neovim Configuration ──"

if confirm "Setup Neovim personal plugins and config?"; then
  bash "$SCRIPT_DIR/scripts/setup-nvim.sh"
fi
echo ""

# ── 3. Bash overlay ─────────────────────────────────────────────────
info "── Bash Configuration ──"

BASH_SRC="$SCRIPT_DIR/bash/bashrc.local"
BASHRC="$HOME/.bashrc"
SOURCE_LINE="# Personal overlay (dotfiles.omarchy)"
SOURCE_CMD="[ -f \"$BASH_SRC\" ] && source \"$BASH_SRC\""

if [ -f "$BASH_SRC" ]; then
  if grep -qF "$BASH_SRC" "$BASHRC" 2>/dev/null; then
    ok "Bash overlay already sourced from repo"
  elif confirm "Add personal bash overlay (aliases & functions)?"; then
    # Remove old copy-based approach if present
    if [ -f "$HOME/.bashrc.local" ] && grep -q 'bashrc.local' "$BASHRC" 2>/dev/null; then
      warn "Migrating from copy-based to direct-source approach"
      # Remove old source line (points to ~/.bashrc.local copy)
      sed -i '/bashrc\.local/d' "$BASHRC"
      sed -i '/Personal overlay/d' "$BASHRC"
      rm -f "$HOME/.bashrc.local"
      ok "Removed old ~/.bashrc.local copy"
    fi

    printf '\n%s\n%s\n' "$SOURCE_LINE" "$SOURCE_CMD" >> "$BASHRC"
    ok "~/.bashrc now sources directly from repo: bash/bashrc.local"
  fi
fi
echo ""

# ── 4. GPG signing (optional) ───────────────────────────────────────
info "── GPG Signing (optional) ──"

if command -v op &> /dev/null && command -v gpg &> /dev/null; then
  if confirm "Import GPG key from 1Password for commit signing?"; then
    bash "$SCRIPT_DIR/scripts/import-gpg.sh"
  else
    info "Skipped GPG setup"
  fi
else
  info "Skipped GPG setup (requires: op, gpg)"
fi
echo ""

# ── Done ─────────────────────────────────────────────────────────────
echo ""
ok "╔══════════════════════════════════════╗"
ok "║  Dotfiles overlay setup complete! 🎉 ║"
ok "╚══════════════════════════════════════╝"
echo ""
info "Next steps:"
info "  1. Open a new terminal to load bash changes"
info "  2. Open Neovim and run :Lazy sync"
info "  3. Verify: git aliases → git wip / git lg"
info ""
info "After Omarchy updates that reset ~/.bashrc, re-run:"
info "  ./install.sh       (to restore the bash source line)"
