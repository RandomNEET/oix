#!/usr/bin/env bash
set -euo pipefail

# Color only terminal output; NO_COLOR disables it explicitly.
log() {
  local color=$1
  shift
  if [[ -t 1 && ${TERM:-} != dumb && -z ${NO_COLOR:-} ]]; then
    printf '\033[%sm%s\033[0m\n' "$color" "$*"
  else
    printf '%s\n' "$*"
  fi
}

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
SUCCESSFUL=()
FAILED=()
SKIPPED=()

log '1;36' "Nix Packages Multi-Update Manager"
log 2 "Working Directory: $SCRIPT_DIR"

# Materialize discovery first so a find/sort failure is not silently ignored.
SCRIPT_LIST=$(mktemp)
trap 'rm -f -- "$SCRIPT_LIST"' EXIT
find "$SCRIPT_DIR" -mindepth 2 -type f -name update.sh -not -path '*/.*/*' -print0 |
  sort -z >"$SCRIPT_LIST"

while IFS= read -r -d '' update_script; do
  pkg_dir=$(dirname -- "$update_script")
  package=${pkg_dir#"$SCRIPT_DIR/"}
  if [[ -f $pkg_dir/.ignore ]]; then
    log 33 "Skipping: $package (.ignore)"
    SKIPPED+=("$package")
    continue
  fi

  printf '\n'
  log '1;36' "Running update: $package"
  # Bash deliberately avoids relying on executable bits or changing them.
  if (cd -- "$pkg_dir" && bash "$update_script"); then
    SUCCESSFUL+=("$package")
    log 32 "Success: $package"
  else
    FAILED+=("$package")
    log 31 "Failed: $package" >&2
  fi
done <"$SCRIPT_LIST"

printf '\n'
log '1;36' "Update Summary: ${#SUCCESSFUL[@]} successful, ${#FAILED[@]} failed, ${#SKIPPED[@]} skipped"
for category in SUCCESSFUL FAILED SKIPPED; do
  declare -n packages=$category
  if ((${#packages[@]})); then
    case "$category" in
    SUCCESSFUL) color=32 ;;
    FAILED) color=31 ;;
    SKIPPED) color=33 ;;
    esac
    log "1;$color" "$category:"
    for package in "${packages[@]}"; do log "$color" "  - $package"; done
  fi
done

((${#FAILED[@]} == 0))
