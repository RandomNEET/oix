#!/usr/bin/env bash
set -euo pipefail

NIX_FILE="${NIX_FILE:-./default.nix}"
PACKAGE="obsidian-headless"
REGISTRY="https://registry.npmjs.org"

# Step 1: Get the latest version from npm registry
echo "Fetching latest version of $PACKAGE from npm registry..."
RAW=$(curl -s "$REGISTRY/$PACKAGE/latest")
LATEST_VERSION=$(echo "$RAW" | sed -n 's/.*"version":"\([^"]*\)".*/\1/p')
if [ -z "$LATEST_VERSION" ]; then
  echo "Error: Failed to extract version from registry response"
  exit 1
fi
echo "Latest version on npm: $LATEST_VERSION"

# Step 2: Read the current version from default.nix
CURRENT_VERSION=$(grep -oE 'version\s*=\s*"[^"]*"' "$NIX_FILE" | sed 's/.*"\(.*\)"/\1/')
echo "Current version in $NIX_FILE: $CURRENT_VERSION"

# Step 3: Check if update is needed
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "Already up-to-date (version $CURRENT_VERSION). Nothing to do."
  exit 0
fi

echo "Updating from $CURRENT_VERSION to $LATEST_VERSION..."

# Step 4: Update version in default.nix
sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$NIX_FILE"
echo "Version updated: $CURRENT_VERSION -> $LATEST_VERSION"

# Step 5: Compute the correct tarball URL
URL="https://registry.npmjs.org/$PACKAGE/-/$PACKAGE-$LATEST_VERSION.tgz"
echo "Tarball URL: $URL"

# Step 6: Prefetch the tarball to get the fetchurl hash
echo "Prefetching tarball to compute fetchurl hash..."
HASH1=$(nix store prefetch-file "$URL" --json 2>/dev/null | grep -oE '"hash":"[^"]*"' | grep -oE 'sha256-[^"]*')
if [ -z "$HASH1" ]; then
  echo "Error: Failed to prefetch $URL"
  exit 1
fi
sed -i "s|hash = \"sha256-[^\"]*\"|hash = \"${HASH1}\"|" "$NIX_FILE"
echo "Fetchurl hash: $HASH1"

# Step 7: Download tarball, extract, and generate package-lock.json
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading tarball into temp directory..."
curl -sL "$URL" | tar xz -C "$TMPDIR" --strip-components=1

echo "Generating package-lock.json (via npm install --package-lock-only)..."
nix shell nixpkgs#nodejs -c bash -c "cd '$TMPDIR' && npm install --package-lock-only"

if [ ! -f "$TMPDIR/package-lock.json" ]; then
  echo "Error: package-lock.json was not generated"
  exit 1
fi
cp "$TMPDIR/package-lock.json" "$(dirname "$NIX_FILE")/package-lock.json"
echo "package-lock.json copied to $(dirname "$NIX_FILE")/package-lock.json"

# Step 8: Compute npmDepsHash from the new package-lock.json
echo "Computing npmDepsHash from package-lock.json..."
HASH2=$(nix run nixpkgs#prefetch-npm-deps -- ./package-lock.json 2>/dev/null)
if [ -z "$HASH2" ]; then
  echo "Error: Failed to compute npmDepsHash"
  exit 1
fi
sed -i "s|npmDepsHash = \"[^\"]*\"|npmDepsHash = \"${HASH2}\"|" "$NIX_FILE"
echo "npmDepsHash: $HASH2"

# Step 9: Done
echo "Successfully updated $PACKAGE from $CURRENT_VERSION to $LATEST_VERSION"
