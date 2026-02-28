#!/usr/bin/env bash

# --- Configuration List ---
# Format: "OWNER/REPO:TARGET_FILE:BRANCH"
# If BRANCH is omitted, it defaults to 'master'.
REPOS=(
  "KZDKM/hyprspace:hyprspace.nix:main"
)

# --- Function: Update a single repository ---
update_repo() {
  local entry=$1

  # Parse the entry
  IFS=':' read -r FULL_REPO TARGET_FILE BRANCH <<<"$entry"
  IFS='/' read -r OWNER REPO <<<"$FULL_REPO"
  BRANCH=${BRANCH:-master}

  # Check if the target nix file exists
  if [ ! -f "$TARGET_FILE" ]; then
    echo "[-] Skipping: $TARGET_FILE not found."
    return
  fi

  echo "[+] Processing $OWNER/$REPO ($TARGET_FILE)..."

  # 1. Fetch the latest commit metadata from GitHub API
  # If you hit rate limits, use: curl -H "Authorization: token YOUR_TOKEN" ...
  local commit_json
  commit_json=$(curl -s "https://api.github.com/repos/$OWNER/$REPO/commits/$BRANCH")

  local rev
  rev=$(echo "$commit_json" | jq -r '.sha')

  local commit_date
  commit_date=$(echo "$commit_json" | jq -r '.commit.committer.date' | cut -d'T' -f1)

  if [ "$rev" == "null" ] || [ -z "$rev" ]; then
    echo " [!] Error: Failed to fetch commit info for $FULL_REPO on branch '$BRANCH'."
    return
  fi

  local version="0-unstable-$commit_date"
  echo " [i] Latest commit: $rev ($commit_date)"

  # 2. Calculate the SRI hash for Nix fetchFromGitHub
  echo " [i] Calculating SRI hash..."
  local raw_hash
  raw_hash=$(nix-prefetch-url --unpack "https://github.com/$OWNER/$REPO/archive/$rev.tar.gz" 2>/dev/null)

  if [ -z "$raw_hash" ]; then
    echo " [!] Error: Failed to prefetch the source."
    return
  fi

  local sri_hash
  sri_hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$raw_hash")

  # 3. Apply changes to the .nix file using sed
  echo " [i] Writing to $TARGET_FILE..."

  # Matches: version = "...";
  sed -i "s|version = \".*\";|version = \"$version\";|" "$TARGET_FILE"
  # Matches: rev = "...";
  sed -i "s|rev = \".*\";|rev = \"$rev\";|" "$TARGET_FILE"
  # Matches: hash = "...";
  sed -i "s|hash = \".*\";|hash = \"$sri_hash\";|" "$TARGET_FILE"

  echo "[*] Update successful: $version"
}

# --- Main Execution Loop ---
echo "Starting update process..."
echo "------------------------------------------"

for entry in "${REPOS[@]}"; do
  update_repo "$entry"
  echo "------------------------------------------"
done

echo "All tasks completed."
