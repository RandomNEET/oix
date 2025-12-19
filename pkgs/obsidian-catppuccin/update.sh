#!/usr/bin/env bash

# --- Configuration ---
OWNER="catppuccin"
REPO="obsidian"
TARGET_FILE=$(ls *.nix | head -n 1)

if [ -z "$TARGET_FILE" ]; then
	echo "Error: No .nix file found in the current directory."
	exit 1
fi

echo "Target file: $TARGET_FILE"
echo "Checking GitHub for the latest release of $OWNER/$REPO..."

# --- 1. Get Latest Version from GitHub API ---
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest")
VERSION=$(echo "$LATEST_RELEASE" | jq -r '.tag_name')

VERSION_CLEAN=$(echo "$VERSION" | sed 's/^v//')

if [ "$VERSION" == "null" ] || [ -z "$VERSION" ]; then
	echo "Error: Could not fetch version from GitHub API."
	exit 1
fi

echo "Latest version found: $VERSION_CLEAN"

# --- 2. Calculate Hash for the Source ---
echo "Calculating hash for version $VERSION..."
URL="https://github.com/$OWNER/$REPO/archive/refs/tags/$VERSION.tar.gz"
HASH_RAW=$(nix-prefetch-url --unpack "$URL")

if [ -z "$HASH_RAW" ]; then
	echo "Error: Failed to prefetch the URL."
	exit 1
fi

HASH=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$HASH_RAW")

# --- 3. Update the Nix File ---
echo "Updating $TARGET_FILE..."

sed -i "/pname = \"obsidian-catppuccin\";/,/sha256 =/ { 
    s/version = \".*\";/version = \"$VERSION_CLEAN\";/
    s|sha256 = \".*\";|sha256 = \"$HASH\";| 
}" "$TARGET_FILE"

echo "------------------------------------------"
echo "Update Complete!"
echo "New version: $VERSION_CLEAN"
echo "New hash:    $HASH"
