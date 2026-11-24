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
        description = "Package providing the font.";
      };
      name = mkOption {
        type = types.str;
        description = "Name of the font family.";
      };
    };
  };
in
{
  options = {
    desktop = {
      enable = mkEnableOption "graphical desktop environment and Wayland compositor support";
      displayManager = mkOption {
        type = types.enum [
          "ly"
          "none"
        ];
        default = "none";
        description = ''
          Display manager to use for session login.

          - `"ly"`: Enable Ly, a lightweight TUI display manager.
          - `"none"`: Do not enable a display manager.
        '';
      };
      hyprland = {
        enable = mkEnableOption "Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
      };
      niri = {
        enable = mkEnableOption "Niri, a scrollable-tiling Wayland compositor";
      };
      mango = {
        enable = mkEnableOption "Mango, a fast, feature-rich Wayland compositor based on dwl and scenefx";
      };
      plasma = {
        enable = mkEnableOption "the Plasma 6 (KDE 6) desktop environment";
        x11Support = mkEnableOption "X11 server support for Plasma";
      };
      hibernate = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to support system hibernation (suspend-to-disk).
          When enabled, `security.protectKernelImage` is disabled so the kernel can resume from swap.
        '';
      };
      themes = {
        enable = mkEnableOption "system-wide color scheming and typography via Stylix";
        list = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            List of Base16 scheme names from `pkgs.base16-schemes` to configure for the desktop.
            The first element is used as the default active theme, and any remaining elements are generated as Home Manager specialisations for runtime switching.
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
            Color scheme polarity preference passed to Stylix.

            - `"either"`: Follow the color scheme's native polarity.
            - `"light"`: Force a light theme variant.
            - `"dark"`: Force a dark theme variant.
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
          description = ''
            Ordered list of monospace fonts used for terminals and text editors.
            All listed packages are installed and registered in `fonts.fontconfig.defaultFonts.monospace`, with the first entry set as the primary Stylix monospace font.
          '';
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
          description = ''
            Ordered list of sans-serif fonts used for user interface elements and general text.
            All listed packages are installed and registered in `fonts.fontconfig.defaultFonts.sansSerif`, with the first entry set as the primary Stylix sans-serif font.
          '';
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
          description = ''
            Ordered list of serif fonts used for documents and prose.
            All listed packages are installed and registered in `fonts.fontconfig.defaultFonts.serif`, with the first entry set as the primary Stylix serif font.
          '';
        };
        emoji = mkOption {
          type = types.listOf fontModule;
          default = [
            {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            }
          ];
          description = ''
            Ordered list of emoji fonts installed system-wide and registered in `fonts.fontconfig.defaultFonts.emoji`, with the first entry set as the primary Stylix emoji font.
          '';
        };
      };
    };
  };
  config = mkMerge [
    (mkIf (!config.desktop.enable) {
      desktop.hyprland.enable = mkForce false;
      desktop.niri.enable = mkForce false;
      desktop.mango.enable = mkForce false;
      desktop.plasma.enable = mkForce false;
    })
    (mkIf (!config.desktop.plasma.enable) {
      desktop.plasma.x11Support = mkForce false;
    })
    (mkIf (!config.desktop.themes.enable) {
      desktop.themes.list = mkForce [ ];
    })
  ];
}
