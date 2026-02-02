{
  config,
  lib,
  mylib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  xdg.configFile =
    let
      content = builtins.readDir ./.;
      rasiFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".rasi" n) content;
      dynamicMappings = lib.mapAttrs' (n: v: {
        name = "rofi/themes/${n}";
        value = {
          source = ./. + "/${n}";
        };
      }) rasiFiles;
    in
    dynamicMappings
    // {
      "rofi/themes/shared/colors.rasi".text =
        if hasThemes then
          ''
            * {
                background:     ${colors.base00}CC;
                background-alt: ${colors.base01}CC;
                foreground:     ${colors.base05}FF;
                selected:       ${primaryColor}FF;
                active:         ${colors.base0B}FF;
                urgent:         ${colors.base0F}FF;
            }
          ''
        else
          ''
            * {
                background:     #1A1A1ACC;
                background-alt: #2A2A2ACC;
                foreground:     #D4D4D4FF;
                selected:       #5A9BCfFF;
                active:         #73C991FF;
                urgent:         #E06C75FF;
            }
          '';
      "rofi/themes/shared/fonts.rasi".text =
        if hasThemes then
          ''
            * {
                font: "${config.stylix.fonts.monospace.name} 10";
            }
          ''
        else
          ''
            * {
                font: "JetBrains Mono Nerd Font 10";
            }
          '';
    };
}
