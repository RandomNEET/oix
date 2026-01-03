{
  config,
  lib,
  opts,
  ...
}:
let
  colors = config.lib.stylix.colors;
  displays = opts.display or [ ];
  primaryLandscape = lib.findFirst (d: d.orientation == "landscape") (lib.head displays) displays;
  otherDisplays = lib.filter (d: d.output != primaryLandscape.output) displays;

  hexToRgb =
    hex:
    let
      r = builtins.fromTOML "v=0x${lib.substring 0 2 hex}";
      g = builtins.fromTOML "v=0x${lib.substring 2 2 hex}";
      b = builtins.fromTOML "v=0x${lib.substring 4 2 hex}";
    in
    "rgb(${toString r.v}, ${toString g.v}, ${toString b.v})";
in
{
  home-manager.sharedModules = [
    (_: {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
          };

          background = [
            (
              {
                monitor = primaryLandscape.output;
              }
              // lib.optionalAttrs ((opts.hyprlock.background or "") != "") {
                path = opts.hyprlock.background;
                new_optimizations = true;
                blur_size = "3";
                blur_passes = "2";
                noise = "0.0117";
                contrast = "1.0";
                brightness = "1.0";
                vibrancy = "0.21";
                vibrancy_darkness = "0.0";
              }
              // lib.optionalAttrs ((opts.hyprlock.background or "") == "") {
                color = hexToRgb colors.base00;
              }
            )
          ]
          ++ (map (d: {
            monitor = d.output;
            color = "rgb(0, 0, 0)";
          }) otherDisplays);

          input-field = [
            {
              monitor = primaryLandscape.output;
              size = "250, 50";
              outline_thickness = "3";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              fail_transition = "300";
              fade_on_empty = false;
              placeholder_text = "Password...";
              dots_size = "0.2";
              dots_spacing = "0.64";
              dots_center = true;
              position = "0, 140";
              halign = "center";
              valign = "bottom";
              outer_color = hexToRgb colors.base0E;
              inner_color = hexToRgb colors.base00;
              font_color = hexToRgb colors.base0E;
              fail_color = hexToRgb colors.base08;
            }
          ];

          label = [
            {
              monitor = primaryLandscape.output;
              text = "$TIME";
              font_size = "64";
              font_family = "JetBrains Mono Nerd Font 10";
              position = "0, 16";
              valign = "center";
              halign = "center";
              color = hexToRgb colors.base0E;
            }
          ];
        };
      };
    })
  ];
}
