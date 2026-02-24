{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-trash-explorer";
  version = "1.2.4";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/proog/obsidian-trash-explorer/releases/download/${version}/main.js";
        sha256 = "sha256-E66RNLbNzXhHhVyJGUFb/fkgYlJNDglARdsEHiybgIM=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/proog/obsidian-trash-explorer/releases/download/${version}/manifest.json";
        sha256 = "sha256-C8t0mJLi516pniacdbSBFgQNxama/G0HMLZgI4pCzcE=";
      }
    } $out/manifest.json
  '';
}
