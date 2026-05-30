{
  config,
  lib,
  pkgs,
  ...
}:
let
  userscriptsDir = ".config/qutebrowser/userscripts";
in
{
  home.file = {
    "${userscriptsDir}/dump-cookies" = {
      source = import ./dump-cookies.nix { inherit config pkgs; };
      executable = true;
    };
    "${userscriptsDir}/ime-off" = {
      source = import ./ime-off.nix { inherit config pkgs; };
      executable = true;
    };
    "${userscriptsDir}/translate" = {
      source = import ./translate.nix { inherit pkgs; };
      executable = true;
    };
  }
  // lib.optionalAttrs config.programs.mpv.enable {
    "${userscriptsDir}/view-in-mpv" = {
      source = import ./view-in-mpv.nix { inherit pkgs; };
      executable = true;
    };
  };
}
