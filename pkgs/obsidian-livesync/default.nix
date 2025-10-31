{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "obsidian-livesync";
  version = "0.25.12";
  src = null;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.12/main.js";
        sha256 = "0134e98953c0e29024c58821b70344a862fdee82eefe9550160677e2bfbeb1eb";
      }
    } $out/main.js

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.12/manifest.json";
        sha256 = "c3ddf0267a7765e5b62bad13b36e1905b976b472564fcc92ad9b147348d779cd";
      }
    } $out/manifest.json

    cp ${
      pkgs.fetchurl {
        url = "https://github.com/vrtmrz/obsidian-livesync/releases/download/0.25.12/styles.css";
        sha256 = "ec29fb248ca163f3bc0037a2d8a76ae70eb3de343747779d58fe16dd588371ca";
      }
    } $out/styles.css
  '';
}
