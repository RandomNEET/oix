{ config, pkgs, ... }:
let
  terminal = import ../misc/terminal.nix { inherit config; };
  args = ''${terminal.classFlag} "fileManager"'';
in
pkgs.writeShellScriptBin "file-manager" ''
  case "$1" in
    dolphin) exec dolphin ;;
    yazi) exec ${terminal.exe} ${args} -e yazi ;;
  esac
''
