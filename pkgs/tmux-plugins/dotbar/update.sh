#!/usr/bin/env bash

# Package configuration: change only this section when copying this template.
TARGET="default.nix"
OWNER="vaaleyard"
REPO="tmux-dotbar"
MODE="release" # release or branch
BRANCH=""
VERSION_PREFIX="0"  # optional; empty produces unstable-YYYY-MM-DD
TAG_PREFIX=""       # removed from release tags for the version field
DEPENDENCIES="none" # none or nuget
DEPS_FILE="deps.json"
# End configuration.

# Template body: keep identical within the same updater family.
# Requires Bash 4.3+, curl, jq, Perl and GNU coreutils.
# Source hashes require nix and nix-prefetch-url; NuGet also needs nix-build.
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
case "$MODE" in
release)
  metadata=$(github releases/latest)
  tag=$(jq -er '.tag_name | select(type == "string" and length > 0)' <<<"$metadata")
  [[ $tag == "$TAG_PREFIX"* ]] || fail "Unexpected release tag: $tag"
  version=${tag#"$TAG_PREFIX"}
  [[ -n $version ]] || fail 'Empty release version'
  # Only these existing expressions are supported; verify the configured prefix.
  expression=$(sed -n 's/^[[:space:]]*tag = \(.*\);/\1/p' "$WORK_FILE")
  # Match literal Nix interpolation, rather than shell expansion.
  # shellcheck disable=SC2016
  case "$expression" in
  'version' | 'finalAttrs.version') [[ -z $TAG_PREFIX ]] || fail 'Tag prefix conflicts with Nix expression' ;;
  '"v${finalAttrs.version}"' | '"v${version}"') [[ $TAG_PREFIX == v ]] || fail 'Expected v tag prefix' ;;
  *) fail "Unsupported tag expression: $expression" ;;
  esac
  revision=$tag
  set_field version "$version"
  ;;
branch)
  branch=$(jq -rn --arg branch "$BRANCH" '$branch | @uri')
  metadata=$(github "commits/$branch")
  revision=$(jq -er '.sha | select(type == "string" and test("^[0-9a-f]{40}$"))' <<<"$metadata")
  date=$(jq -er '.commit.committer.date | capture("^(?<date>[0-9]{4}-[0-9]{2}-[0-9]{2})T").date' <<<"$metadata")
  set_field version "${VERSION_PREFIX:+$VERSION_PREFIX-}unstable-$date"
  set_field rev "$revision"
  ;;
*) fail "Unknown GitHub update mode: $MODE" ;;
esac
revision_url=$(jq -rn --arg revision "$revision" '$revision | @uri')
hash=$(prefetch "https://github.com/$OWNER/$REPO/archive/$revision_url.tar.gz" unpack)
set_field hash "$hash"
case "$DEPENDENCIES" in
none) ;;
nuget)
  # Resolve nixpkgs through this repository's flake.lock, with no lockfile writes.
  require nix-build
  repo_root=$(cd "$SCRIPT_DIR/../.." && pwd)
  [[ -f $repo_root/flake.lock ]] || fail 'Repository flake.lock not found'
  cp -p -- "$TARGET_DIR/$DEPS_FILE" "$UPDATE_TMP/$DEPS_FILE"
  expression=$(jq -rn --arg root "path:$repo_root" --arg package "$WORK_FILE" '
      "let flake = builtins.getFlake " + ($root | tojson) + "; pkgs = import flake.inputs.nixpkgs { system = builtins.currentSystem; }; in (pkgs.callPackage (builtins.toPath " + ($package | tojson) + ") {}).passthru.fetch-deps"')
  fetch_deps=$(nix-build --no-out-link --expr "$expression")
  [[ -x $fetch_deps ]] || fail 'fetch-deps did not produce an executable'
  "$fetch_deps" "$UPDATE_TMP/$DEPS_FILE"
  jq -e 'type == "array" and length > 0 and all(.[];
      (.pname | type == "string" and length > 0) and
      (.version | type == "string" and length > 0) and
      (.hash | type == "string" and test("^sha256-[A-Za-z0-9+/]{43}=$")))' "$UPDATE_TMP/$DEPS_FILE" >/dev/null
  jq 'map(. + {url: ("https://api.nuget.org/v3-flatcontainer/" +
      (.pname | ascii_downcase) + "/" + (.version | ascii_downcase) + "/" +
      (.pname | ascii_downcase) + "." + (.version | ascii_downcase) + ".nupkg")})' \
    "$UPDATE_TMP/$DEPS_FILE" >"$UPDATE_TMP/normalized-deps.json"
  stage_file "$UPDATE_TMP/normalized-deps.json" "$DEPS_FILE"
  ;;
*) fail "Unknown dependency updater: $DEPENDENCIES" ;;
esac
finish
