{
  inputs,
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  meta,
  ...
}:
let
  inherit (lib) getExe;
  mangoEnabled = osConfig.desktop.mango.enable;
  file-manager = getExe (import ../shared/scripts/file-manager.nix { inherit config pkgs; });
  autoclicker = getExe (pkgs.callPackage ../shared/scripts/autoclicker.nix { });
  colors = config.lib.stylix.colors;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  imports = lib.optionals mangoEnabled [
    (
      if (meta.channel == "unstable") then
        inputs.mangowm.hmModules.mango
      else
        inputs.mangowm-stable.hmModules.mango
    )
    ../shared/fonts
    ../shared/themes
    ../shared/xdg
    ../shared/i18n/fcitx5
    ../shared/programs/gowall
    ../shared/programs/noctalia
    ../shared/services/udiskie
  ];

  config =
    if mangoEnabled then
      {
        wayland.windowManager.mango =
          let
            binds = import ./binds.nix {
              inherit
                osConfig
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
            settings =
              lib.recursiveUpdate
                (
                  {
                    inherit (binds)
                      bind
                      binds
                      mousebind
                      axisbind
                      key_mode
                      ;
                    layer_rule = (import ./rules.nix).layer_rule;
                    window_rule = (import ./rules.nix).window_rule;
                    env = import ./env.nix;
                    exec_once = autostart.exec_once;
                  }
                  // import ./animations.nix
                  // import ./misc.nix
                )
                (
                  lib.optionalAttrs osConfig.desktop.themes.enable {
                    root_color = "0x${colors.base00}ff";
                    border_color = "0x${colors.base02}ff";
                    drop_color = "0x${colors.base01}55";
                    split_color = "0x${colors.base0D}ff";
                    focus_color = "0x${primaryColor}ff";
                    urgent_color = "0x${colors.base08}ff";
                  }
                );
          };

        home.packages = with pkgs; [
          libnotify
          wl-clipboard
          wlrctl # mouse control
        ];
      }
    else
      { };
}
