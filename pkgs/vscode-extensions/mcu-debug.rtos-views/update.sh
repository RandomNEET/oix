#!/usr/bin/env bash

# Package configuration: change only this section when copying this template.
TARGET="default.nix"
PUBLISHER="mcu-debug"
EXTENSION="rtos-views"
# End configuration.

# Template body: keep identical within the same updater family.
# Requires Bash 4.3+, curl, jq, Perl and GNU coreutils.
# Source hashes require nix and nix-prefetch-url.
# Usage: bash update.sh [target.nix]; relative arguments use the caller's cwd.
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

fail() {
  log 31 "Error: $*" >&2
  exit 1
}
require() {
  local command
  for command in "$@"; do
    command -v "$command" >/dev/null || fail "Required command not found: $command"
  done
}
require curl jq perl
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TARGET_FILE=$(realpath -- "${1:-${NIX_FILE:-$SCRIPT_DIR/$TARGET}}")
[[ -f $TARGET_FILE ]] || fail "Target file not found: $TARGET_FILE"
TARGET_DIR=$(dirname -- "$TARGET_FILE")
UPDATE_TMP=$(mktemp -d "$TARGET_DIR/.update.XXXXXX")
WORK_FILE=$UPDATE_TMP/default.nix
STAGED_FILES=("$WORK_FILE")
DESTINATIONS=("$TARGET_FILE")
COMMITTING=0
cleanup() {
  local status=$? i
  trap - EXIT
  if ((COMMITTING)); then
    for i in "${!DESTINATIONS[@]}"; do
      if [[ -f $UPDATE_TMP/backup/$i ]]; then
        mv -f -- "$UPDATE_TMP/backup/$i" "${DESTINATIONS[i]}" || status=1
      else
        rm -f -- "${DESTINATIONS[i]}" || status=1
      fi
    done
  fi
  rm -rf -- "$UPDATE_TMP"
  if ((status)); then log 31 "Update failed: $TARGET_FILE" >&2; fi
  exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
cp -p -- "$TARGET_FILE" "$WORK_FILE"
log 36 "Checking updates: $(basename -- "$TARGET_DIR")"
http() { curl --fail --silent --show-error --location --retry 3 "$@"; }
# Supply GITHUB_TOKEN through the environment, never hardcode or log it.
github() {
  local headers=(-H 'Accept: application/vnd.github+json')
  if [[ -n ${GITHUB_TOKEN:-} ]]; then
    headers+=(-H "Authorization: Bearer $GITHUB_TOKEN")
  fi
  http "${headers[@]}" "https://api.github.com/repos/$OWNER/$REPO/$1"
}
field() {
  FIELD=$1 perl -0777 -ne '
    my @values = /^\h*\Q$ENV{FIELD}\E\h*=\h*"([^"\n]*)"\h*;/mg;
    die "Expected one literal $ENV{FIELD} assignment\n" unless @values == 1;
    print $values[0];
  ' "${2:-$WORK_FILE}"
}
set_field() {
  FIELD=$1 VALUE=$2 perl -0777 -i -pe '
    die "Unsafe assignment value\n" if $ENV{VALUE} =~ /["\n\r\\]/ or index($ENV{VALUE}, chr(36)."{") >= 0;
    my $n = s/(^\h*\Q$ENV{FIELD}\E\h*=\h*)"[^"\n]*"(\h*;)/$1."\"".$ENV{VALUE}."\"".$2/mge;
    die "Expected one $ENV{FIELD} assignment, found $n\n" unless $n == 1;
  ' "${3:-$WORK_FILE}"
}
validate_hash() {
  [[ $1 =~ ^sha256-[A-Za-z0-9+/]{43}=$ ]] || fail "Invalid SHA-256 SRI hash"
}
prefetch() {
  local raw hash args=()
  [[ ${2:-} != unpack ]] || args+=(--unpack)
  log 36 "Prefetching: $1" >&2
  raw=$(nix-prefetch-url "${args[@]}" "$1")
  [[ -n $raw ]] || fail "Empty source hash"
  hash=$(nix hash to-sri --type sha256 "$raw")
  validate_hash "$hash"
  printf '%s\n' "$hash"
}
stage_file() {
  STAGED_FILES+=("$1")
  DESTINATIONS+=("$TARGET_DIR/$2")
}
finish() {
  local i changed=0
  for i in "${!DESTINATIONS[@]}"; do
    if ! cmp -s -- "${STAGED_FILES[i]}" "${DESTINATIONS[i]}"; then changed=1; fi
  done
  if ((! changed)); then
    log 32 "Already up to date: $TARGET_FILE"
    return
  fi
  mkdir "$UPDATE_TMP/backup"
  for i in "${!DESTINATIONS[@]}"; do
    if [[ -f ${DESTINATIONS[i]} ]]; then cp -p -- "${DESTINATIONS[i]}" "$UPDATE_TMP/backup/$i"; fi
  done
  COMMITTING=1
  for i in "${!DESTINATIONS[@]}"; do mv -f -- "${STAGED_FILES[i]}" "${DESTINATIONS[i]}"; done
  COMMITTING=0
  log 32 "Updated: $TARGET_FILE"
}

require nix nix-prefetch-url
request=$(jq -n --arg id "$PUBLISHER.$EXTENSION" '{filters:[{criteria:[{filterType:7,value:$id}]}],flags:17}')
response=$(http -X POST 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
  -H 'Content-Type: application/json' -H 'Accept: application/json;api-version=3.0-preview.1' -d "$request")
# Marketplace returns newest first. Properties are requested via flags:17.
version=$(jq -er '[.results[0].extensions[0].versions[] |
  select((.targetPlatform // "universal") == "universal") |
  select(any(.properties[]?; .key == "Microsoft.VisualStudio.Code.PreRelease" and .value == "true") | not)
][0].version | select(type == "string" and length > 0)' <<<"$response")
hash=$(prefetch "https://$PUBLISHER.gallery.vsassets.io/_apis/public/gallery/publisher/$PUBLISHER/extension/$EXTENSION/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage")
set_field version "$version"
set_field hash "$hash"
finish
