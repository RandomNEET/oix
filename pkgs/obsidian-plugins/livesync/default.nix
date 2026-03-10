# https://github.com/vrtmrz/obsidian-livesync
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.52";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-S7qt9soY288UAlXlf2ILi/Dx5mAvk2qYau3ZriQZL/s=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-vN29ZmY+XHNrwVthxE2kdSYInRMBkeDrIdkDWMVSOPk=";
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
