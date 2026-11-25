{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
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
  options.oix.appearance.fonts = {
    enable = mkOption {
      type = types.bool;
      default =
        with config.oix.appearance.fonts;
        monospace != [ ] || sansSerif != [ ] || serif != [ ] || emoji != [ ];
      defaultText = lib.literalExpression ''
        with config.oix.appearance.fonts;
        monospace != [ ] || sansSerif != [ ] || serif != [ ] || emoji != [ ]
      '';
      readOnly = true;
      description = "Global indicator flag set automatically when `modules/appearance/fonts` is imported and at least one font category is non-empty.";
    };
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
}
