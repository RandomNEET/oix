{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionalAttrs;
in
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/programs/fcitx5
  ];

  config = lib.mkIf osConfig.desktop.plasma.enable {
    programs.plasma = {
      enable = true;
      startup = {
        startupScript =
          { }
          // optionalAttrs osConfig.desktop.hyprland.enable {
            stop-hyprpolkitagent = "systemctl --user stop hyprpolkitagent.service";
          }
          // optionalAttrs (osConfig.desktop.niri.enable || osConfig.desktop.mango.enable) {
            stop-lxqt-policykit-agent = "systemctl --user stop lxqt-policykit-agent.service";
          };
      };
      configFile = {
        kwinrc.Plugins.krohnkiteEnabled = true;
      };
    };
    home.packages = with pkgs; [ kdePackages.krohnkite ];

    stylix.targets.kde.enable = lib.mkIf osConfig.desktop.themes.enable true;
  };
}
