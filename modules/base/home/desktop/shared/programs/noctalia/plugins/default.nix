{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional optionalAttrs;
  customPluginsDir = ".local/state/noctalia/plugins/custom";

  hasThemes = osConfig.desktop.themes.enable;
in
{
  config = lib.mkIf osConfig.desktop.enable {
    programs.noctalia.settings.plugins = {
      enabled = [
        "noctalia/translator"
      ]
      ++ optional hasThemes "custom/theme-switcher";
      source = [
        {
          enabled = true;
          kind = "git";
          location = "https://github.com/noctalia-dev/official-plugins";
          name = "official";
          auto_update = false;
        }
        {
          enabled = true;
          kind = "git";
          location = "https://github.com/noctalia-dev/community-plugins";
          name = "community";
          auto_update = false;
        }
        {
          enabled = true;
          kind = "path";
          location = "${config.home.homeDirectory}/${customPluginsDir}";
          name = "custom";
          auto_update = false;
        }
      ];
    };

    home.file =
      { }
      // optionalAttrs hasThemes {
        "${customPluginsDir}/theme-switcher/plugin.toml".source = ./theme-switcher/plugin.toml;
        "${customPluginsDir}/theme-switcher/launcher.luau".text = import ./theme-switcher/launcher.nix {
          inherit
            osConfig
            config
            lib
            pkgs
            ;
        };
      };
  };
}
