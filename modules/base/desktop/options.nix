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
    mkMerge
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
      hibernate = mkOption {
        type = types.bool;
        default = false;
        description = "Enable system hibernation features and related power management hooks.";
      };
      themes = {
        enable = mkEnableOption "the centralized desktop ricing and theming system";
        list = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            A list of base16-scheme names to be used by the desktop. 
            The first element (index 0) is treated as the primary active theme.
          '';
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
      };
      fonts = {
        monospace = mkOption {
          type = types.listOf fontModule;
          default = [
            {
              package = pkgs.nerd-fonts.jetbrains-mono;
              name = "JetBrainsMono Nerd Font";
            }
            {
              package = pkgs.sarasa-gothic;
              name = "Sarasa Mono SC";
            }
          ];
          description = "The default monospace (fixed-width) font used in terminals and code editors.";
        };
        sansSerif = mkOption {
          type = types.listOf fontModule;
          default = [
            {
              package = pkgs.ibm-plex;
              name = "IBM Plex Sans";
            }
            {
              package = pkgs.sarasa-gothic;
              name = "Sarasa Gothic SC";
            }
          ];
          description = "The default proportional font without serifs, used for UI elements and general text.";
        };
        serif = mkOption {
          type = types.listOf fontModule;
          default = [
            {
              package = pkgs.ibm-plex;
              name = "IBM Plex Serif";
            }
            {
              package = pkgs.sarasa-gothic;
              name = "Sarasa Gothic SC";
            }
          ];
          description = "The default proportional font with serifs, used for documents and formal reading.";
        };
        emoji = mkOption {
          type = types.listOf fontModule;
          default = [
            {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            }
          ];
          description = "The font package providing emoji support across the system.";
        };
      };
    };
  };
  config = mkMerge [
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
    (mkIf (!config.desktop.themes.enable) {
      desktop.themes.list = mkForce [ ];
    })
  ];
}
