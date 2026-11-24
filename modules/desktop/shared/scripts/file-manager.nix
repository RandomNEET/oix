{ config, pkgs, ... }:
let
  terminal = import ./terminal.nix { inherit config; };
  args = ''${terminal.classFlag} "fileManager"'';
in
pkgs.writeShellScriptBin "file-manager" ''
  case "$1" in
    yazi) exec ${terminal.exe} ${args} -e yazi ;;
    thunar) exec thunar ;;
  esac
''
