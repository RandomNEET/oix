{
  osConfig,
  config,
  lib,
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
      };
    };
  };
  config = mkMerge [
    (mkIf (osConfig != null) {
      desktop.themes.enable = mkForce osConfig.desktop.theme.enable;
      desktop.themes.polarity = mkForce osConfig.desktop.theme.polarity;
    })
    (mkIf (!config.desktop.themes.enable) {
      desktop.themes.list = mkForce [ ];
    })
  ];
}
