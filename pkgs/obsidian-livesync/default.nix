{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.38";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-vwh+nfLsAV9/PIgiCdBcKRKxLykjGHpFHk2X7D1MACI=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-nzuXouC6lzzDBF6cWA9MgwEzkacQuJzRCQ6PMfeTUFQ=";
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
