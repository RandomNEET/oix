{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "obsidian-trash-explorer";
  version = "1.2.3";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/proog/obsidian-trash-explorer/releases/download/1.2.3/main.js";
        sha256 = "0gf0py0vlsp04dx2bhdlbaa7vhnvim2nl2flg7kr5dkwwk2ck470";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/proog/obsidian-trash-explorer/releases/download/1.2.3/manifest.json";
        sha256 = "17whfpsp96ndj7wsxr0y0j2nplw7ijacjiwgprh7p988qyvwdy9y";
      }
    } $out/manifest.json
  '';
}
