{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.oix.desktop.themes = {
    enable = mkOption {
      type = types.bool;
      default = config.oix.desktop.themes.list != [ ];
      defaultText = lib.literalExpression "config.oix.desktop.themes.list != [ ]";
      readOnly = true;
      description = "Global indicator flag set automatically when `oix.desktop.themes.list` is non-empty.";
    };
    list = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of Base16 scheme names from `pkgs.base16-schemes` to configure via Stylix.
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
}
