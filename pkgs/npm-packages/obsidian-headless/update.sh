#!/usr/bin/env bash
set -euo pipefail

NIX_FILE="${NIX_FILE:-./default.nix}"

# ---- helpers ----
sed_i() { if sed --version 2>/dev/null | grep -q GNU; then sed -i "$@"; else sed -i '' "$@"; fi; }
info() { echo -e "\033[0;36m[*]\033[0m $*"; }
ok() { echo -e "\033[0;32m[+]\033[0m $*"; }
die() {
  echo -e "\033[0;31m[-]\033[0m $*"
  exit 1
}

# ---- extract version & url ----
VERSION=$(grep -oE 'version\s*=\s*"[^"]*"' "$NIX_FILE" | head -1 | grep -oE '"[^"]*"' | tr -d '"')
URL=$(grep -oE 'url\s*=\s*"[^"]*"' "$NIX_FILE" | head -1 | grep -oE '"[^"]*"' | tr -d '"')
URL_REAL=$(echo "$URL" | sed "s/\${version}/$VERSION/g")
info "version=$VERSION  url=$URL_REAL"

# ====== Step 1: fetchurl hash ======
info "Prefetching tarball..."
HASH1=$(nix store prefetch-file "$URL_REAL" --json 2>/dev/null | grep -oE '"hash":"[^"]*"' | grep -oE 'sha256-[^"]*')
[ -z "$HASH1" ] && die "Failed to prefetch $URL_REAL"
sed_i "s|hash = \"sha256-[^\"]*\"|hash = \"${HASH1}\"|" "$NIX_FILE"
ok "fetchurl hash -> $HASH1"

# ====== Step 2: npmDepsHash (prefetch-npm-deps, no build) ======
info "Computing npmDepsHash from package-lock.json..."
HASH2=$(nix run nixpkgs#prefetch-npm-deps -- ./package-lock.json 2>/dev/null)
[ -z "$HASH2" ] && die "Failed to run prefetch-npm-deps"
sed_i "s|npmDepsHash = \"[^\"]*\"|npmDepsHash = \"${HASH2}\"|" "$NIX_FILE"
ok "npmDepsHash -> $HASH2"

ok "Done"
