{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkMerge
    mkIf
    mkForce
    ;
  fontModule = types.submodule {
    options = {
      package = mkOption {
        type = types.package;
        description = "The font package to be installed and used.";
      };
      name = mkOption {
        type = types.str;
        description = "The specific font family name used for configuration files.";
      };
    };
  };
in
{
  options = {
    desktop = {
      themes = {
        enable = mkEnableOption "custom desktop theming. When enabled as a Home Manager module, it can synchronize settings from the NixOS system level";
        list = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            A list of base16-scheme names to be used by the desktop. 
            The first element (index 0) is treated as the primary active theme.

            Note: If NixOS level theme is defined, it will be automatically 
            prepended to this list and deduplicated via the `apply` function.
          '';
          apply =
            list:
            let
              osTheme = osConfig.desktop.theme.baseTheme or null;
            in
            if osTheme != null then lib.unique ([ osTheme ] ++ list) else list;
        };
        polarity = mkOption {
          type = types.enum [
            "either"
            "light"
            "dark"
          ];
          default = "either";
          description = ''
            Forces the theme variant. 'either' follows the theme's default, 
            while 'light' or 'dark' overrides the color scheme preference.
          '';
        };
        fonts = {
          monospace = mkOption {
            type = fontModule;
            default = {
              package = pkgs.nerd-fonts.jetbrains-mono;
              name = "JetBrainsMono Nerd Font";
            };
            description = "The default monospace (fixed-width) font used in terminals and code editors.";
          };
          sansSerif = mkOption {
            type = fontModule;
            default = {
              package = pkgs.noto-fonts-cjk-sans;
              name = "Noto Sans CJK SC";
            };
            description = "The default proportional font without serifs, used for UI elements and general text.";
          };
          serif = mkOption {
            type = fontModule;
            default = {
              package = pkgs.noto-fonts-cjk-serif;
              name = "Noto Serif CJK SC";
            };
            description = "The default proportional font with serifs, used for documents and formal reading.";
          };
          emoji = mkOption {
            type = fontModule;
            default = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
            description = "The font package providing emoji support across the system.";
          };
        };
      };
    };
  };
  config = mkMerge [
    (mkIf (osConfig != null) {
      desktop.themes.enable = mkForce osConfig.desktop.theme.enable;
      desktop.themes.polarity = mkForce osConfig.desktop.theme.polarity;
      desktop.themes.fonts = mkForce osConfig.desktop.theme.fonts;
    })
    (mkIf (!config.desktop.themes.enable) {
      desktop.themes.list = mkForce [ ];
    })
  ];
}
