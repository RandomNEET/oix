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

# --- Iteration ---
for dir in */; do
	dir_name=${dir%/}

	if [[ "$dir_name" == "hosts" || "$dir_name" == "modules" || "$dir_name" == "overlays" ]]; then
		continue
	fi

	if [ -f "${dir_name}/update.sh" ]; then
		echo -e "\n[+] Found update script in: $dir_name"

		(
			cd "$dir_name" || exit
			chmod +x update.sh
			./update.sh
		)

		if [ $? -eq 0 ]; then
			SUCCESSFUL+=("$dir_name")
		else
			FAILED+=("$dir_name")
		fi
	else
		SKIPPED+=("$dir_name")
	fi
done

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
