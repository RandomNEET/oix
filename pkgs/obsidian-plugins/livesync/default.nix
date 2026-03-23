# https://github.com/vrtmrz/obsidian-livesync
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.54";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-BH3o8jWDv9mpVkeGILz+ILCc15MTTJcO3ns+6yvR498=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-sz/Z1SuCWoNWYl3B0UZ+ERPM4JAh56qH1zQMrCCfFGQ=";
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
