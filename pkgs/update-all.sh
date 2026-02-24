#!/usr/bin/env bash

# --- Navigation ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit

# --- State Tracking ---
SUCCESSFUL=()
FAILED=()
SKIPPED=()

echo "=========================================="
echo "   Nix Packages Multi-Update Manager      "
echo "   Working Directory: $SCRIPT_DIR"
echo "=========================================="

# --- Recursive Search ---
while IFS= read -r update_script; do
  pkg_dir=$(dirname "$update_script")

  if [[ "$pkg_dir" == *"hosts"* || "$pkg_dir" == *"modules"* || "$pkg_dir" == *"overlays"* || "$pkg_dir" == "." ]]; then
    continue
  fi

  echo -e "\n[+] Running update in: $pkg_dir"

  (
    cd "$pkg_dir" || exit
    chmod +x update.sh
    ./update.sh
  )

  if [ $? -eq 0 ]; then
    SUCCESSFUL+=("$pkg_dir")
  else
    FAILED+=("$pkg_dir")
  fi

done < <(find . -name "update.sh" -not -path "*/.*")

# --- Final Summary Report ---
echo -e "\n=========================================="
echo "             UPDATE SUMMARY               "
echo "=========================================="

if [ ${#SUCCESSFUL[@]} -ne 0 ]; then
  echo "✅ Successfully updated:"
  for pkg in "${SUCCESSFUL[@]}"; do
    echo "   - $pkg"
  done
fi

if [ ${#FAILED[@]} -ne 0 ]; then
  echo -e "\n❌ Failed updates (check logs above):"
  for pkg in "${FAILED[@]}"; do
    echo "   - $pkg"
  done
fi

if [ ${#SKIPPED[@]} -ne 0 ]; then
  echo -e "\nℹ️  Skipped (no update.sh found):"
  for pkg in "${SKIPPED[@]}"; do
    echo "   - $pkg"
  done
fi

echo -e "\nAll tasks processed."
