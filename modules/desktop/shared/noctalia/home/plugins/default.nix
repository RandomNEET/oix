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
    (osConfig.oix.appearance.themes.enable or false)
    && builtins.length (osConfig.oix.appearance.themes.list or [ ]) > 1;
in
{
  config = lib.mkIf (osConfig.oix.desktop.enable or false) {
    programs.noctalia.settings = {
      plugins = {
        enabled = [
          "noctalia/translator"
          "mellotanica/launcher-pass"
          "kenn/keybind-cheatsheet"
          "custom/systemd-service"
        ]
        ++ optional themeSwitcherEnabled "custom/theme-switcher"
        ++ optional (osConfig.oix.gaming.enable or false) "alexander/game-launcher";
        auto_update = "all";
        source = [
          {
            enabled = true;
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
          }
          {
            enabled = true;
            name = "community";
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
          }
          {
            enabled = true;
            name = "custom";
            kind = "path";
            location = "${config.home.homeDirectory}/${customPluginsDir}";
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
