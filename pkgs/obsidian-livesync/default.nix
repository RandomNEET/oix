{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.40";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-mCbbQeLOiy2+fmnXQpMjIxu8iwQcI3wXm3Ukl6lRGWs=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-+fAEGvPpTUA4NdDxJq0Zg3YucfrwyjVun3F6aMwpe9M=";
      }
    } $out/manifest.json

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/styles.css";
        sha256 = "sha256-O9nrEIKaJ21tu1S9qRFSGeBD5bYdA/VEpByDUH0PM0U=";
      }
    } $out/styles.css
  '';
}
