{
  lib,
  pkgs,
  opts,
  ...
}:
{
  fonts.packages = with pkgs.nerd-fonts; [ jetbrains-mono ];
  home-manager.sharedModules = [
    (_: {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:size=12";
          };
          mouse = {
            hide-when-typing = "yes";
          };
          key-bindings = {
            scrollback-up-half-page = "Control+k";
            scrollback-down-half-page = "Control+j";
          };
        }
        // lib.optionalAttrs ((opts.theme or "") != "") (import ./themes/${opts.theme}.nix);
      };
    })
  ];
}
