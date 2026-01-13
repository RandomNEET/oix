{
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) optionalAttrs;
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.kitty = {
          enable = true;
          shellIntegration.enableBashIntegration = true;
          shellIntegration.enableZshIntegration = true;
          actionAliases =
            { }
            // optionalAttrs ((opts.editor or "") == "nvim") {
              "kitty_scrollback_nvim" =
                "kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py --config readonly --nvim-args -n -c 'nnoremap q ZQ'";
            };
          settings = {
            cursor_trail = 3; # Fancy cursor movements (especially in nixvim)
            cursor_trail_decay = "0.08 0.3"; # Animation speed
            cursor_trail_start_threshold = "4";
            strip_trailing_spaces = "smart";
            copy_on_select = "yes";
            confirm_os_window_close = 0;
            scrollback_lines = 10000;
            enable_audio_bell = false;
            mouse_hide_wait = 60;
            update_check_interval = 0;
            # Remote control
            allow_remote_control = "yes";
            listen_on = "unix:/run/user/${toString opts.users.primary.uid}/kitty";
            # Tabs
            tab_title_template = "{index}";
            active_tab_font_style = "normal";
            inactive_tab_font_style = "normal";
            tab_bar_style = "powerline";
            tab_powerline_style = "round";
          };
          keybindings =
            { }
            // optionalAttrs config.programs.tmux.enable {
              "ctrl+alt+t" = "launch --type=overlay --cwd=current tmux";
            }
            // optionalAttrs ((opts.editor or "") == "nvim") {
              "kitty_mod+h" = "kitty_scrollback_nvim";
            };
        };
      }
    )
  ];
}
