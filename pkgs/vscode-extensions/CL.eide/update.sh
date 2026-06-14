#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-./default.nix}"
EXT_PUBLISHER="CL"
EXT_NAME="eide"

echo "Fetching latest version for ${EXT_PUBLISHER}.${EXT_NAME}..."

# Query the Marketplace API for the latest version number
RESP=$(curl -sS -X POST "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json;api-version=3.0-preview.1" \
  -d '{
    "filters": [{
      "criteria": [{ "filterType": 7, "value": "'"${EXT_PUBLISHER}.${EXT_NAME}"'" }]
    }],
    "flags": 1
  }')

LATEST_VERSION=$(echo "$RESP" | jq -r '
  .results[0].extensions[0].versions[] |
  select(.properties[]?.key == "Microsoft.VisualStudio.Code.PreRelease") |
  .properties[]?.value != "true" // true
  ' | jq -s '. | sort_by(.version) | last.version')

# Fallback: take the absolute latest version (may include pre-releases)
if [[ -z $LATEST_VERSION || $LATEST_VERSION == "null" ]]; then
  LATEST_VERSION=$(echo "$RESP" | jq -r '.results[0].extensions[0].versions[0].version')
fi

echo "Latest version: $LATEST_VERSION"

# Download the vsix from the SAME URL that Nix uses internally
TMPFILE=$(mktemp -t eide-XXXX.vsix)
trap 'rm -f "$TMPFILE"' EXIT

DOWNLOAD_URL="https://${EXT_PUBLISHER}.gallery.vsassets.io/_apis/public/gallery/publisher/${EXT_PUBLISHER}/extension/${EXT_NAME}/${LATEST_VERSION}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
echo "Downloading $DOWNLOAD_URL ..."
curl -sS -L -o "$TMPFILE" "$DOWNLOAD_URL"

echo "Calculating hash..."
HASH=$(nix hash file --sri --type sha256 "$TMPFILE" 2>/dev/null || {
  # Fallback for non-Nix environments (requires openssl)
  SHA256=$(sha256sum "$TMPFILE" | cut -d ' ' -f1)
  echo "sha256-$(echo -n "$SHA256" | xxd -r -p | base64)"
})

echo "New hash: $HASH"

# Update the Nix file in-place using sed
echo "Updating $FILE ..."
sed -i -E "s|version *= *\"[^\"]*\"|version = \"${LATEST_VERSION}\"|" "$FILE"
sed -i -E "s|hash *= *\"[^\"]*\"|hash = \"${HASH}\"|" "$FILE"

echo "Done."
