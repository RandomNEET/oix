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
        "custom/keybind-cheatsheet"
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
        "${customPluginsDir}/theme-switcher/theme-switcher.luau".text =
          import ./theme-switcher/theme-switcher.nix
            {
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
