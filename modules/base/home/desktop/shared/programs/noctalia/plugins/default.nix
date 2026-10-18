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

  themeSwitcherEnabled =
    osConfig.desktop.themes.enable && builtins.length osConfig.desktop.themes.list > 1;
in
{
  config = lib.mkIf osConfig.desktop.enable {
    programs.noctalia.settings = {
      plugins = {
        auto_update = "all";
        enabled = [
          "noctalia/translator"
          "mellotanica/launcher-pass"
          "kenn/keybind-cheatsheet"
          "custom/systemd-service"
        ]
        ++ optional themeSwitcherEnabled "custom/theme-switcher"
        ++ optional osConfig.base.gaming.enable "alexander/game-launcher";
        source = [
          {
            enabled = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            enabled = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
          {
            enabled = true;
            kind = "path";
            location = "${config.home.homeDirectory}/${customPluginsDir}";
            name = "custom";
          }
        ];
      };
      plugin_settings = {
        "mellotanica/launcher-pass" = {
          storePath = config.programs.password-store.settings.PASSWORD_STORE_DIR;
        };
      };
    };

    home = {
      file = {
        "${customPluginsDir}/systemd-service".source = ./systemd-service;
      }
      // optionalAttrs themeSwitcherEnabled {
        "${customPluginsDir}/theme-switcher/plugin.toml".source = ./theme-switcher/plugin.toml;
        "${customPluginsDir}/theme-switcher/launcher.luau".text = import ./theme-switcher/launcher.nix {
          inherit
            osConfig
            config
            lib
            pkgs
            ;
        };
        "${customPluginsDir}/theme-switcher/translations".source = ./theme-switcher/translations;
      };
      packages = with pkgs; [
        gcc # required by alexander/game-launcher
      ];
    };
  };
}
