# https://github.com/vrtmrz/obsidian-livesync
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.57";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-rHegmXuqJpRsHgWe/any6MhHDsfrhINpQn73K/WmcDc=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-FBHIQpPn8ak5XJNL/7naA2syCm72oP+gclp38xYDwmw=";
      }
    } $out/manifest.json

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/styles.css";
        sha256 = "sha256-HWLxFH8gMZOgMGjRJCLlKx8cqiK0oIpczh5YJjpmTaM=";
      }
    } $out/styles.css
  '';
}
