#!/usr/bin/env bash
# import-gpg.sh — Import a GPG private key from 1Password and configure git signing
set -euo pipefail

command -v op  &>/dev/null || { echo "Error: 1Password CLI (op) not found"; exit 1; }
command -v gpg &>/dev/null || { echo "Error: gpg not found"; exit 1; }

# --- Sign in to 1Password if needed ---
if ! op whoami &>/dev/null; then
  echo "Signing in to 1Password..."
  eval "$(op signin)"
fi

# --- Ask for the item name ---
read -rp "1Password item name [GPG Key - private]: " ITEM_NAME
ITEM_NAME="${ITEM_NAME:-GPG Key - private}"

echo "Fetching \"$ITEM_NAME\" from 1Password..."

RAW="$(op item get "$ITEM_NAME" --fields notesPlain)"

# Strip surrounding quotes and unescape newlines
KEY="$(python3 -c "
import sys
c = sys.stdin.read().strip()
if c.startswith('\"') and c.endswith('\"'):
    c = c[1:-1]
c = c.replace('\\\\n', '\n')
print(c)
" <<< "$RAW")"

if ! grep -q "BEGIN PGP PRIVATE KEY BLOCK" <<< "$KEY"; then
  echo "Error: content does not look like a PGP private key."
  exit 1
fi

# --- Import key ---
echo "Importing GPG key..."
IMPORT_OUTPUT="$(gpg --import <<< "$KEY" 2>&1)"
echo "$IMPORT_OUTPUT"

# --- Extract key ID and fingerprint ---
KEY_ID="$(gpg --list-secret-keys --keyid-format=long 2>/dev/null \
  | grep -E '^sec' | head -1 | awk '{print $2}' | cut -d'/' -f2)"
FINGERPRINT="$(gpg --list-secret-keys --with-colons 2>/dev/null \
  | grep '^fpr' | head -1 | cut -d':' -f10)"

if [[ -z "$KEY_ID" || -z "$FINGERPRINT" ]]; then
  echo "Error: could not determine key ID or fingerprint after import."
  exit 1
fi

# --- Set ultimate trust ---
echo "${FINGERPRINT}:6:" | gpg --import-ownertrust
echo "Trust set to ultimate for $FINGERPRINT"

# --- Configure git signing ---
git config --global user.signingkey "$KEY_ID"
git config --global commit.gpgsign true
echo "Git configured to sign commits with key $KEY_ID"

echo ""
echo "Done! All future commits will be signed automatically."
echo "Key ID: $KEY_ID"
