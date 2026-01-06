{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
        colors = config.lib.stylix.colors;
      in
      {
        programs.swaylock = {
          enable = true;
          settings = {
            scaling = "fill";
            font = "JetBrains Mono Nerd Font";
            font-size = 24;
            indicator-radius = 60;
            indicator-thickness = 10;
            indicator-idle-visible = true;
            show-failed-attempts = true;
          }
          // lib.optionalAttrs ((opts.swaylock.image or "") != "") {
            image = opts.swaylock.image;
          }
          // lib.optionalAttrs hasThemes {
            font = config.stylix.fonts.monospace.name;
            color = colors.base00;
            inside-color = colors.base00;
            line-color = colors.base0E;
            ring-color = colors.base0D;
            text-color = colors.base05;
            text-wrong-color = colors.base08;
            bs-hl-color = colors.base08;
            key-hl-color = colors.base0B;
          };
        };
      }
    )
  ];
}
