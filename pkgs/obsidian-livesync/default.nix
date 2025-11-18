{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "obsidian-livesync";
  version = "0.25.30";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.30/main.js";
        sha256 = "sha256-Yj9B4Gzzzwx6awDmVY0MHdqgOO+l9s9FKC34wJ/5HQE=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.30/manifest.json";
        sha256 = "sha256-YKUlXvykYvvObxt0V3p19YcL0S9KDV9jeSfEoaWRICM=";
      }
    } $out/manifest.json

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.30/styles.css";
        sha256 = "sha256-O9nrEIKaJ21tu1S9qRFSGeBD5bYdA/VEpByDUH0PM0U=";
      }
    } $out/styles.css
  '';
}
