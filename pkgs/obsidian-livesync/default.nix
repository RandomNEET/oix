{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "obsidian-livesync";
  version = "0.25.27";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.27/main.js";
        sha256 = "sha256-qgh7hJG0bZ3q39m/YjtfVh6hzvmJ8AlSUQk0vfW+z6o=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.27/manifest.json";
        sha256 = "sha256-4THjpQbFNUk8fgrXcYbZGkEALQkDWpAXa9Xjk0kbK3g=";
      }
    } $out/manifest.json

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.27/styles.css";
        sha256 = "sha256-O9nrEIKaJ21tu1S9qRFSGeBD5bYdA/VEpByDUH0PM0U=";
      }
    } $out/styles.css
  '';
}
