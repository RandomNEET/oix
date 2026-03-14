{ pkgs, ... }:
let
  baseUtils = with pkgs; [
    bash
    zsh
    git
    curl
    wget
    vim
    neovim
    unzip
    util-linux
  ];
  devTools = with pkgs; [
    gcc
    gnumake
    autoconf
    binutils
    pkg-config
    stdenv.cc
    python313
  ];
  allLibs = baseUtils ++ devTools;
in
pkgs.buildFHSEnv {
  name = "fhs";
  targetPkgs = p: (pkgs.appimageTools.defaultFhsEnvArgs.targetPkgs p) ++ allLibs;
  multiPkgs = p: [ p.zlib ];
  profile = ''
    export HOME="$PWD/.fhs"
    mkdir -p "$HOME"
    export SHELL=zsh
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath allLibs}:$LD_LIBRARY_PATH"
  '';
  runScript = "zsh";
  extraOutputsToInstall = [ "dev" ];
}
