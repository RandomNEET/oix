#!/usr/bin/env bash

# Change to script directory
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR" || exit

# State tracking arrays
SUCCESSFUL=()
FAILED=()
SKIPPED=()

echo "Nix Packages Multi-Update Manager"
echo "Working Directory: $SCRIPT_DIR"

# Search for update scripts recursively
while IFS= read -r update_script; do
  pkg_dir=$(dirname "$update_script")

  if [[ $pkg_dir == *"hosts"* || $pkg_dir == *"modules"* || $pkg_dir == *"overlays"* || $pkg_dir == "." ]]; then
    continue
  fi

  if [[ -f "$pkg_dir/.ignore" ]]; then
    echo "Ignoring directory: $pkg_dir (found .ignore)"
    SKIPPED+=("$pkg_dir (.ignore)")
    continue
  fi

  echo ""
  echo "Running update in: $pkg_dir"

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

# Summary report
echo ""
echo "Update Summary"

if [ ${#SUCCESSFUL[@]} -ne 0 ]; then
  echo "Successfully updated:"
  for pkg in "${SUCCESSFUL[@]}"; do
    echo "  - $pkg"
  done
fi

if [ ${#FAILED[@]} -ne 0 ]; then
  echo ""
  echo "Failed updates (check logs above):"
  for pkg in "${FAILED[@]}"; do
    echo "  - $pkg"
  done
fi

if [ ${#SKIPPED[@]} -ne 0 ]; then
  echo ""
  echo "Skipped (found .ignore):"
  for pkg in "${SKIPPED[@]}"; do
    echo "  - $pkg"
  done
fi

echo ""
echo "All tasks processed."
