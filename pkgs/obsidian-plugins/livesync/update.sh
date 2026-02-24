#!/usr/bin/env bash

# --- Configuration ---
OWNER="vrtmrz"
REPO="obsidian-livesync"
TARGET_FILE=$(ls *.nix | head -n 1)

if [ -z "$TARGET_FILE" ]; then
	echo "Error: No .nix file found in the current directory."
	exit 1
fi

echo "Target file: $TARGET_FILE"
echo "Checking GitHub for the latest release of $OWNER/$REPO..."

# --- 1. Get Latest Version ---
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest")
VERSION=$(echo "$LATEST_RELEASE" | jq -r '.tag_name')

if [ "$VERSION" == "null" ] || [ -z "$VERSION" ]; then
	echo "Error: Could not fetch version from GitHub API."
	exit 1
fi

VERSION_CLEAN=$(echo "$VERSION" | sed 's/^v//')
echo "Latest version found: $VERSION_CLEAN"

# --- 2. Calculate Hashes ---
fetch_hash() {
	local filename=$1
	local url="https://github.com/$OWNER/$REPO/releases/download/$VERSION/$filename"
	echo "Prefetching $filename..." >&2
	local raw_hash=$(nix-prefetch-url "$url" 2>/dev/null)
	nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$raw_hash"
}

HASH_JS=$(fetch_hash "main.js")
HASH_JSON=$(fetch_hash "manifest.json")
HASH_CSS=$(fetch_hash "styles.css")

# --- 3. Update the Nix File ---
echo "Updating $TARGET_FILE..."

sed -i "s/version = \".*\";/version = \"$VERSION_CLEAN\";/" "$TARGET_FILE"
sed -i "/main.js\"/,/sha256 =/ s|sha256 = \".*\";|sha256 = \"$HASH_JS\";|" "$TARGET_FILE"
sed -i "/manifest.json\"/,/sha256 =/ s|sha256 = \".*\";|sha256 = \"$HASH_JSON\";|" "$TARGET_FILE"
sed -i "/styles.css\"/,/sha256 =/ s|sha256 = \".*\";|sha256 = \"$HASH_CSS\";|" "$TARGET_FILE"

echo "------------------------------------------"
echo "Update Complete!"
echo "New version: $VERSION_CLEAN"
