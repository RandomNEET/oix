{ lib, opts, ... }:
let
  displays = opts.display or [ ];
  primaryLandscape = lib.findFirst (d: d.orientation == "landscape") (lib.head displays) displays;
  otherDisplays = lib.filter (d: d.output != primaryLandscape.output) displays;
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
                blur_size = 3;
                blur_passes = 2;
                noise = 1.17e-2;
                contrast = 1.0;
                brightness = 1.0;
                vibrancy = 0.21;
                vibrancy_darkness = 0.0;
              }
              // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
                color = "rgb(36, 39, 58)";
              }
            )
          ]
          ++ (map (d: {
            monitor = d.output;
            color = "rgb(0, 0, 0)";
          }) otherDisplays);

          input-field = [
            (
              {
                monitor = primaryLandscape.output;
                size = "250, 50";
                outline_thickness = 3;
                fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
                fail_transition = 300;
                fade_on_empty = false;
                placeholder_text = "Password...";
                dots_size = 0.2;
                dots_spacing = 0.64;
                dots_center = true;
                position = "0, 140";
                halign = "center";
                valign = "bottom";
              }
              // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
                outer_color = "rgb(198, 160, 246)";
                inner_color = "rgb(36, 39, 58)";
                font_color = "rgb(198, 160, 246)";
                fail_color = "rgb(237, 135, 150)";
              }
            )
          ];

          label = [
            (
              {
                monitor = primaryLandscape.output;
                text = "$TIME";
                font_size = 64;
                font_family = "JetBrains Mono Nerd Font 10";
                position = "0, 16";
                valign = "center";
                halign = "center";
              }
              // lib.optionalAttrs ((opts.theme or "") == "catppuccin-mocha") {
                color = "rgb(198, 160, 246)";
              }
            )
          ];
        };
      };
    })
  ];
}
