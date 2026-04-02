# https://github.com/vrtmrz/obsidian-livesync
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.56";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-cuvvN24GCMC/V2w292TrGkypPlzcrzcDUeJc7e1cvRM=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-PE6kuSkKJIYUsoEbhu4ENC6WumruT7Hp1Pf9BdKJx0c=";
      }
    } $out/manifest.json

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/styles.css";
        sha256 = "sha256-SKokAKsGwX0YAoczW+1++6ukiOc9QAi8NB8LJsrox8E=";
      }
    } $out/styles.css
  '';
}
