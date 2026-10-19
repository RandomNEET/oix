#!/usr/bin/env bash

# Package configuration: change only this section when copying this template.
PUBLISHER="mcu-debug"
EXTENSION="rtos-views"
# End configuration.

# Template body: keep identical within this updater family.
# Requires Bash 4.3+, curl, jq, nix, nix-prefetch-url and GNU coreutils.
# Usage: bash update.sh [sources.json]; relative arguments use the caller's cwd.
set -euo pipefail

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
for dependency in curl jq nix nix-prefetch-url; do
  command -v "$dependency" >/dev/null || fail "Required command not found: $dependency"
done
(($# <= 1)) || fail "Usage: bash update.sh [sources.json]"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TARGET_FILE=$(realpath -- "${1:-$SCRIPT_DIR/sources.json}")
[[ -f $TARGET_FILE ]] || fail "Target file not found: $TARGET_FILE"
TARGET_DIR=$(dirname -- "$TARGET_FILE")
UPDATE_TMP=$(mktemp -d "$TARGET_DIR/.update.XXXXXX")
WORK_FILE=$UPDATE_TMP/sources.json
cleanup() {
  local status=$?
  trap - EXIT
  rm -rf -- "$UPDATE_TMP"
  if ((status)); then log 31 "Update failed: $TARGET_FILE" >&2; fi
  exit "$status"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

validate_sources() {
  jq -e 'type == "object" and all(to_entries[];
    (.key | test("^(universal|linux-x64|linux-arm64)$")) and
    (.value | type == "object" and
      (.version | type == "string" and test("^[0-9]+(\\.[0-9]+)*$")) and
      (.hash | type == "string" and test("^sha256-[A-Za-z0-9+/]{43}=$"))))' "$1" >/dev/null
}
validate_sources "$TARGET_FILE" || fail "Invalid sources JSON: $TARGET_FILE"
printf '{}\n' >"$WORK_FILE"
log 36 "Checking updates: $PUBLISHER.$EXTENSION"
request=$(jq -n --arg id "$PUBLISHER.$EXTENSION" '{filters:[{criteria:[{filterType:7,value:$id}]}],flags:17}')
curl --fail --silent --show-error --location --retry 3 --connect-timeout 20 --max-time 120 \
  -X POST 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
  -H 'Content-Type: application/json' -H 'Accept: application/json;api-version=3.0-preview.1' \
  -d "$request" >"$UPDATE_TMP/response.json"
jq -e --arg id "$PUBLISHER.$EXTENSION" '
  .results[0].extensions[0] |
  ((.publisher.publisherName + "." + .extensionName | ascii_downcase) == ($id | ascii_downcase)) and
  (.versions | type == "array" and length > 0) and
  all(.versions[]; (.version | type == "string" and test("^[0-9]+(\\.[0-9]+)*$")))
' "$UPDATE_TMP/response.json" >/dev/null || fail "Invalid Marketplace response"

# Update all Marketplace targets supported by this repository.
for platform in universal linux-x64 linux-arm64; do
  version=$(jq -r --arg platform "$platform" '
    [.results[0].extensions[0].versions[] |
      select((.targetPlatform // "universal") == $platform) |
      select(any(.properties[]?; .key == "Microsoft.VisualStudio.Code.PreRelease" and .value == "true") | not)] |
    sort_by(.version | split(".") | map(tonumber)) | last | .version // empty
  ' "$UPDATE_TMP/response.json")
  if [[ -z $version ]]; then
    log 33 "$platform: no stable release"
    continue
  fi
  hash=$(jq -r --arg platform "$platform" --arg version "$version" \
    '.[$platform] | select(.version == $version) | .hash // empty' "$TARGET_FILE")
  if [[ -n $hash ]]; then
    log 32 "$platform: $version (hash unchanged)"
  else
    platform_query=""
    [[ $platform == universal ]] || platform_query="?targetPlatform=$platform"
    url="https://$PUBLISHER.gallery.vsassets.io/_apis/public/gallery/publisher/$PUBLISHER/extension/$EXTENSION/$version/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage$platform_query"
    log 36 "$platform: $version (prefetching)"
    raw=$(nix-prefetch-url "$url")
    [[ -n $raw ]] || fail "Empty source hash for $platform"
    hash=$(nix hash to-sri --type sha256 "$raw")
    [[ $hash =~ ^sha256-[A-Za-z0-9+/]{43}=$ ]] || fail "Invalid SHA-256 hash for $platform"
  fi
  jq --arg platform "$platform" --arg version "$version" --arg hash "$hash" \
    '.[$platform] = {version: $version, hash: $hash}' "$WORK_FILE" >"$UPDATE_TMP/next.json"
  mv -- "$UPDATE_TMP/next.json" "$WORK_FILE"
done
validate_sources "$WORK_FILE" || fail "Invalid generated sources JSON"
for platform in linux-x64 linux-arm64; do
  jq -e --arg platform "$platform" 'has($platform) or has("universal")' "$WORK_FILE" >/dev/null ||
    fail "No stable release compatible with $platform"
done
jq -S . "$WORK_FILE" >"$UPDATE_TMP/sorted.json"
jq -S . "$TARGET_FILE" >"$UPDATE_TMP/previous.json"
if cmp -s -- "$UPDATE_TMP/sorted.json" "$UPDATE_TMP/previous.json"; then
  log 32 "Already up to date: $TARGET_FILE"
else
  chmod --reference="$TARGET_FILE" "$UPDATE_TMP/sorted.json"
  mv -f -- "$UPDATE_TMP/sorted.json" "$TARGET_FILE"
  log 32 "Updated: $TARGET_FILE"
fi
