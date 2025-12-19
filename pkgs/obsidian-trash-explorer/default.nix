{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-trash-explorer";
  version = "1.2.3";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/proog/obsidian-trash-explorer/releases/download/${version}/main.js";
        sha256 = "sha256-4JDJxOR8tpLnedQJakWN28J9lFq0wSV6I+BquoG/wD0=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/proog/obsidian-trash-explorer/releases/download/${version}/manifest.json";
        sha256 = "sha256-PvnGt8cIpXtgvo9HyZSMh9NrhQQe5K75kc2adPV1kJ8=";
      }
    } $out/manifest.json
  '';
}
