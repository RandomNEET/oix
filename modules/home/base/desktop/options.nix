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
      enable = mkEnableOption "the graphical desktop environment and user interface components";
      hyprland = {
        enable = mkEnableOption "the Hyprland tiling Wayland compositor";
        primary = mkOption {
          type = types.bool;
          default = false;
          description = "Designate Hyprland as the primary window manager. Only one compositor can be primary at a time.";
        };
      };
      niri = {
        enable = mkEnableOption "the niri scrollable-tiling Wayland compositor";
        primary = mkOption {
          type = types.bool;
          default = false;
          description = "Designate niri as the primary window manager. Only one compositor can be primary at a time.";
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
      hibernate = mkOption {
        type = types.bool;
        default = false;
        description = "Enable system hibernation features and related power management hooks.";
      };
      wallpaper = {
        enable = mkEnableOption "custom wallpaper management and automatic theme-based color conversion";
        dir = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The root directory for system wallpapers.

            Hierarchy Rules:
            1. Source: "original/" is the source of truth. Place new wallpapers here.
            2. Generated: "themed/" is managed by the autoconvert script. Do not manually edit.
            3. Path Logic:
               - Original: <base> / original / <orientation> / <file>
               - Themed:   <base> / themed   / <theme_name> / <orientation> / <file>

            Valid Orientations: "landscape", "portrait"

            Example Tree:
            wallpapers
            ├── original                  # Source files
            │   └── landscape
            │       └── image.jpg
            └── themed                    # Auto-generated files
                └── catppuccin-mocha      # Target theme palette
                    └── landscape
                        └── image.jpg
          '';
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
            Conflicting Configuration: Multiple window managers set as 'primary'.
            Both Hyprland and niri have `primary` enabled. You must choose only one as your default compositor.
          '';
        }
      ];
    }
    (mkIf (osConfig != null) {
      desktop.enable = mkForce osConfig.desktop.enable;
      desktop.hyprland.enable = mkForce osConfig.desktop.hyprland.enable;
      desktop.niri.enable = mkForce osConfig.desktop.niri.enable;
      desktop.hyprland.primary = mkForce osConfig.desktop.hyprland.primary;
      desktop.niri.primary = mkForce osConfig.desktop.niri.primary;
      desktop.fonts = mkForce osConfig.desktop.fonts;
    })
    (mkIf (!config.desktop.enable) {
      desktop.hyprland.enable = mkForce false;
      desktop.niri.enable = mkForce false;
      desktop.wallpaper.enable = mkForce false;
    })
    (mkIf (!config.desktop.hyprland.enable) {
      desktop.hyprland.primary = mkForce false;
    })
    (mkIf (!config.desktop.niri.enable) {
      desktop.niri.primary = mkForce false;
    })
    (mkIf (!config.desktop.wallpaper.enable) {
      desktop.wallpaper.dir = mkForce null;
    })
  ];
}
