#!/usr/bin/env bash

# Config
BRANCH="nixos-unstable"
TARGET_FILE=$(ls *.nix | head -n 1)

if [ -z "$TARGET_FILE" ]; then
  echo "Error: No .nix file found in the current directory."
  exit 1
fi

echo "Target file: $TARGET_FILE"
echo "Syncing from Nixpkgs branch: $BRANCH"

# Step 1: Fetch rime-ice metadata
echo "Fetching rime-ice metadata..."
RICE_URL="https://raw.githubusercontent.com/NixOS/nixpkgs/$BRANCH/pkgs/by-name/ri/rime-ice/package.nix"
RICE_CONTENT=$(curl -s "$RICE_URL")

if [ -z "$RICE_CONTENT" ]; then
  echo "Error: Could not fetch rime-ice data from Nixpkgs."
  exit 1
fi

RICE_VER=$(echo "$RICE_CONTENT" | grep -oP 'version = "\K[^"]+')
RICE_HASH=$(echo "$RICE_CONTENT" | grep -oP 'hash = "\K[^"]+')

echo "Found rime-ice: $RICE_VER"

# Step 2: Fetch fcitx5-rime metadata
echo "Fetching fcitx5-rime metadata..."
FCITX_URL="https://raw.githubusercontent.com/NixOS/nixpkgs/$BRANCH/pkgs/by-name/fc/fcitx5-rime/package.nix"
FCITX_CONTENT=$(curl -s "$FCITX_URL")

if [ -z "$FCITX_CONTENT" ]; then
  echo "Error: Could not fetch fcitx5-rime data from Nixpkgs."
  exit 1
fi

FCITX_VER=$(echo "$FCITX_CONTENT" | grep -oP 'version = "\K[^"]+')
FCITX_HASH=$(echo "$FCITX_CONTENT" | grep -oP 'hash = "\K[^"]+')

echo "Found fcitx5-rime: $FCITX_VER"

# Step 3: Update local nix file
echo "Updating $TARGET_FILE..."

sed -i "/pname = \"rime-ice\";/,/hash =/ { 
    s/version = \".*\";/version = \"$RICE_VER\";/
    s|hash = \".*\";|hash = \"$RICE_HASH\";| 
}" "$TARGET_FILE"

sed -i "/pname = \"fcitx5-rime\";/,/hash =/ { 
    s/version = \".*\";/version = \"$FCITX_VER\";/
    s|hash = \".*\";|hash = \"$FCITX_HASH\";| 
}" "$TARGET_FILE"

echo "Sync complete: rime-ice=$RICE_VER fcitx5-rime=$FCITX_VER"
