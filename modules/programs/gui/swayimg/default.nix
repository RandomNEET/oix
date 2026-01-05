{
  config,
  lib,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
  colors = config.lib.stylix.colors;
in
{
  home-manager.sharedModules = [
    (_: {
      programs.swayimg = {
        enable = true;
        settings = {
          general = {
            mode = "viewer";
          }
          // lib.optionalAttrs ((opts.desktop or "") == "hyprland") {
            overlay = "yes";
          };
          viewer = {
            scale = "optimal";
            antialiasing = "mks13";
          }
          // lib.optionalAttrs hasThemes {
            window = "#${colors.base00}80";
          };
          font = {
            name = "JetBrainsMono Nerd Font";
            size = 12;
          }
          // lib.optionalAttrs hasThemes {
            name = config.stylix.fonts.monospace.name;
            color = "#${colors.base05}ff";
            shadow = "#${colors.base00}d0";
            background = "#${colors.base00}00";
          };
          "info.viewer" = {
            top_left = "+name,+format,+filesize,+imagesize,+exif";
            top_right = "index";
            bottom_left = "scale,frame";
            bottom_right = "status";
          };
          "info.slideshow" = {
            top_left = "none";
            top_right = "none";
            bottom_left = "none";
            bottom_right = "dir,status";
          };
          "info.gallery" = {
            top_left = "none";
            top_right = "none";
            bottom_left = "none";
            bottom_right = "name,status";
          };
          "keys.viewer" = {
            "Shift+?" = "help";
            "g" = "first_file";
            "Shift+g" = "last_file";
            "p" = "prev_file";
            "n" = "next_file";
            "Shift+p" = "prev_dir";
            "Shift+n" = "next_dir";
            "," = "prev_frame";
            "." = "next_frame";
            "c" = "skip_file";
            "Space" = "animation";
            "Return" = "mode gallery";
            "s" = "mode slideshow";
            "h" = "step_left 10";
            "l" = "step_right 10";
            "k" = "step_up 10";
            "j" = "step_down 10";
            "u" = "step_up 100";
            "d" = "step_down 100";
            "Shift+h" = "step_left 1";
            "Shift+l" = "step_right 1";
            "Shift+k" = "step_up 1";
            "Shift+j" = "step_down 1";
            "Equal" = "zoom +10";
            "Plus" = "zoom +10";
            "i" = "zoom +10";
            "Minus" = "zoom -10";
            "o" = "zoom -10";
            "w" = "zoom width";
            "Shift+d" = ''exec rm -f '%' && echo "File removed: %";'';
            "Shift+y" = ''exec cp "%" ~/tmp;'';
            "z" = "zoom fit";
            "f" = "zoom fill";
            "0" = "zoom real";
            "BackSpace" = "zoom optimal";
            "r" = "rotate_left";
            "Shift+r" = "rand_file";
            "Ctrl+r" = "rotate_right";
            "Shift+Ctrl+r" = "reload";
            "v" = "flip_vertical";
            "x" = "flip_horizontal";
            "Shift+a" = "antialiasing";
            "m" = "info";
            "Escape" = "exit";
            "q" = "exit";
            "ScrollLeft" = "step_right 5";
            "ScrollRight" = "step_left 5";
            "ScrollUp" = "step_up 5";
            "ScrollDown" = "step_down 5";
            "Ctrl+ScrollUp" = "zoom +10";
            "Ctrl+ScrollDown" = "zoom -10";
            "Shift+ScrollUp" = "prev_file";
            "Shift+ScrollDown" = "next_file";
            "Alt+ScrollUp" = "prev_frame";
            "Alt+ScrollDown" = "next_frame";
          };
          "keys.slideshow" = {
            "Shift+?" = "help";
            "g" = "first_file";
            "Shift+g" = "last_file";
            "p" = "prev_file";
            "n" = "next_file";
            "Shift+p" = "prev_dir";
            "Shift+n" = "next_dir";
            "Shift+r" = "rand_file";
            "Space" = "pause";
            "i" = "info";
            "f" = "fullscreen";
            "Return" = "mode";
            "Escape" = "exit";
            "q" = "exit";
          };
          "keys.gallery" = {
            "Shift+?" = "help";
            "Minus" = "thumb -10";
            "Equal" = "thumb +10";
            "g" = "first_file";
            "Shift+g" = "last_file";
            "h" = "step_left";
            "l" = "step_right";
            "k" = "step_up";
            "j" = "step_down";
            "p" = "page_up";
            "n" = "page_down";
            "c" = "skip_file";
            "Return" = "mode viewer";
            "s" = "mode slideshow";
            "Shift+a" = "antialiasing";
            "r" = "reload";
            "m" = "info";
            "Shift+d" = ''exec rm -f '%' && echo "File removed: %"; skip_file'';
            "Shift+y" = ''exec cp "%" ~/tmp;'';
            "Escape" = "exit";
            "q" = "exit";
            "ScrollLeft" = "step_right";
            "ScrollRight" = "step_left";
            "ScrollUp" = "step_up";
            "ScrollDown" = "step_down";
            "Ctrl+ScrollUp" = "thumb +20";
            "Ctrl+ScrollDown" = "thumb -20";
            "MouseLeft" = "mode viewer";
          };
        };
      };
    })
  ];
}
