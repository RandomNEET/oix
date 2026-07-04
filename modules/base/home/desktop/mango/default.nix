{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  inherit (lib) getExe;
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  colors = config.lib.stylix.colors;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  imports = [
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/i18n/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia
    ../shared/services/udiskie
  ];

  config = lib.mkIf osConfig.desktop.mango.enable {
    wayland.windowManager.mango =
      let
        binds = import ./binds.nix {
          inherit
            config
            lib
            file-manager
            autoclicker
            ;
        };
        autostart = import ./autostart.nix { inherit config lib; };
      in
      {
        enable = true;
        package = pkgs.mango;
        systemd = {
          enable = true;
          xdgAutostart = true;
        };
        settings = {
          inherit (binds)
            bind
            mousebind
            axisbind
            keymode
            ;
          layerrule = (import ./rules.nix).layerrule;
          windowrule = (import ./rules.nix).windowrule;
          env = import ./env.nix;
          exec-once = autostart.exec-once;
        }
        // import ./animations.nix
        // import ./misc.nix
        // lib.optionalAttrs osConfig.desktop.themes.enable {
          rootcolor = "0x${colors.base00}ff";
          bordercolor = "0x${colors.base02}ff";
          dropcolor = "0x${colors.base01}55";
          splitcolor = "0x${colors.base0D}ff";
          focuscolor = "0x${primaryColor}ff";
          urgentcolor = "0x${colors.base08}ff";
        };
      };

    home.packages = with pkgs; [
      libnotify
      wl-clipboard
      wlrctl # mouse control
    ];
  };
}
