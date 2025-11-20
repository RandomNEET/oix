{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "obsidian-catppuccin";
  version = "2.0.3";
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "obsidian";
    rev = version;
    sha256 = "sha256-9fSFj9Tzc2aN9zpG5CyDMngVcwYEppf7MF1ZPUWFyz4=";
  };
  dontUnpack = false;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
