# https://github.com/vrtmrz/obsidian-livesync
{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-livesync";
  version = "0.25.60";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/main.js";
        sha256 = "sha256-Y9Hp7KSIKgxbuAgvz9a7ZOY6VRiAqx7+8InXyo9arhA=";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${version}/manifest.json";
        sha256 = "sha256-6wBBTwdSKEaw/7jH/ysF7z2l3KVkE6ph5++vgFc5nyo=";
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
