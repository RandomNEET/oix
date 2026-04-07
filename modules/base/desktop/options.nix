{
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
    mkForce
    mkIf
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
      enable = mkEnableOption "the desktop environment and related window managers";
      hyprland = {
        enable = mkEnableOption "the Hyprland tiling Wayland compositor";
        primary = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to designate Hyprland as the primary window manager for the system session.";
        };
      };
      niri = {
        enable = mkEnableOption "the niri scrollable-tiling Wayland compositor";
        primary = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to designate niri as the primary window manager for the system session.";
        };
      };
      theme = {
        enable = mkEnableOption "the centralized desktop ricing and theming system";
        baseTheme = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "The base16-scheme to apply across the desktop.";
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
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(config.desktop.hyprland.primary && config.desktop.niri.primary);
          message = ''
            Conflicting configuration: Both Hyprland and niri are set as 'primary'.
            Only one window manager can be designated as the primary session at a time.
          '';
        }
      ];
    }
    (mkIf (!config.desktop.enable) {
      desktop.hyprland.enable = mkForce false;
      desktop.niri.enable = mkForce false;
    })
    (mkIf (!config.desktop.hyprland.enable) {
      desktop.hyprland.primary = mkForce false;
    })
    (mkIf (!config.desktop.niri.enable) {
      desktop.niri.primary = mkForce false;
    })
    (mkIf (!config.desktop.theme.enable) {
      desktop.theme.baseTheme = mkForce null;
    })
  ];
}
