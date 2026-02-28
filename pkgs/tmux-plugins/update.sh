#!/usr/bin/env bash

# --- Configuration ---
# List the plugins inside your default.nix
# Format: "OWNER/REPO:PLUGIN_NAME"
PLUGINS=(
  "vaaleyard/tmux-dotbar:dotbar"
)

TARGET_FILE="default.nix"

if [ ! -f "$TARGET_FILE" ]; then
  echo "[-] Error: $TARGET_FILE not found in current directory."
  exit 1
fi

update_plugin() {
  local entry=$1
  IFS=':' read -r FULL_REPO NAME <<<"$entry"
  IFS='/' read -r OWNER REPO <<<"$FULL_REPO"

  echo "[+] Checking $FULL_REPO for plugin '$NAME'..."

  # 1. Fetch latest release tag
  local release_json
  release_json=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/releases/latest")

  local tag
  tag=$(echo "$release_json" | jq -r '.tag_name')

  if [ "$tag" == "null" ] || [ -z "$tag" ]; then
    echo " [!] Error: No release found for $FULL_REPO."
    return
  fi

  local version
  version=$(echo "$tag" | sed 's/^v//')
  echo " [i] Found version: $version"

  # 2. Calculate SRI hash
  echo " [i] Calculating SRI hash..."
  local url="https://github.com/$OWNER/$REPO/archive/refs/tags/$tag.tar.gz"
  local raw_hash
  raw_hash=$(nix-prefetch-url --unpack "$url" 2>/dev/null)

  if [ -z "$raw_hash" ]; then
    echo " [!] Error: Prefetch failed for $url."
    return
  fi

  local sri_hash
  sri_hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$raw_hash")

  # 3. Targeted Update using sed
  # This searches for the block starting with pluginName = "$NAME"
  # and only replaces version/hash within that context.
  echo " [i] Patching $TARGET_FILE..."

  # Update version
  sed -i "/pluginName = \"$NAME\"/,/hash =/ s|version = \".*\";|version = \"$version\";|" "$TARGET_FILE"
  # Update hash
  sed -i "/pluginName = \"$NAME\"/,/hash =/ s|hash = \".*\";|hash = \"$sri_hash\";|" "$TARGET_FILE"

  echo "[*] Done: $NAME @ $version"
}

# --- Main ---
echo "Starting multi-plugin update for $TARGET_FILE..."
echo "------------------------------------------"

for plugin in "${PLUGINS[@]}"; do
  update_plugin "$plugin"
  echo "------------------------------------------"
done

echo "All updates finished."
