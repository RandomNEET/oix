{ pkgs, ... }:
let
  userscriptsDir = ".config/qutebrowser/userscripts";
in
{
  home.file = {
    "${userscriptsDir}/ime-off" = {
      source = import ./ime-off.nix { inherit pkgs; };
      executable = true;
    };
    "${userscriptsDir}/translate" = {
      source = import ./translate.nix { inherit pkgs; };
      executable = true;
    };
  };
}
