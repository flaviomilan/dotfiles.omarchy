#!/usr/bin/env bash
# setup-nvim.sh — Symlink personal Neovim config into ~/.config/nvim/
# Safe to run multiple times (skips existing symlinks, warns on conflicts)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
NVIM_SRC="$REPO_ROOT/nvim"
NVIM_DST="$HOME/.config/nvim"

# Colour helpers
info() { printf "\033[34m[nvim]\033[0m %s\n" "$1"; }
ok()   { printf "\033[32m[nvim]\033[0m %s\n" "$1"; }
warn() { printf "\033[33m[nvim]\033[0m %s\n" "$1"; }
err()  { printf "\033[31m[nvim]\033[0m %s\n" "$1" >&2; }

# Files to symlink: source path (relative to nvim/) → destination path (relative to ~/.config/nvim/)
declare -A FILES=(
  ["lua/config/lazy.lua"]="lua/config/lazy.lua"
  ["lua/config/options.lua"]="lua/config/options.lua"
  ["lua/config/keymaps.lua"]="lua/config/keymaps.lua"
  ["lua/config/autocmds.lua"]="lua/config/autocmds.lua"
  ["lua/plugins/user-ai.lua"]="lua/plugins/user-ai.lua"
  ["lua/plugins/user-tools.lua"]="lua/plugins/user-tools.lua"
  ["lua/plugins/user-lang.lua"]="lua/plugins/user-lang.lua"
  ["lua/plugins/disable-news-alert.lua"]="lua/plugins/disable-news-alert.lua"
  ["lua/plugins/snacks-animated-scrolling-off.lua"]="lua/plugins/snacks-animated-scrolling-off.lua"
)

if [ ! -d "$NVIM_DST" ]; then
  err "Neovim config directory not found: $NVIM_DST"
  err "Install Omarchy first, then run this script."
  exit 1
fi

for src_rel in "${!FILES[@]}"; do
  dst_rel="${FILES[$src_rel]}"
  src="$NVIM_SRC/$src_rel"
  dst="$NVIM_DST/$dst_rel"

  if [ ! -f "$src" ]; then
    warn "Source not found, skipping: $src"
    continue
  fi

  # If it's already our symlink, skip
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "Already linked: $dst_rel"
    continue
  fi

  # If a real file exists (not our symlink), back it up
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    warn "Backing up existing file: $dst_rel → ${backup##*/}"
    mv "$dst" "$backup"
  fi

  # Remove stale symlink pointing elsewhere
  if [ -L "$dst" ]; then
    rm "$dst"
  fi

  ln -s "$src" "$dst"
  ok "Linked: $dst_rel"
done

ok "Neovim setup complete!"
info "Open Neovim and run :Lazy sync to install new plugins."
