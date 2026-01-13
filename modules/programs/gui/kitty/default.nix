{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    {
      programs.kitty = {
        enable = true;
        shellIntegration.enableBashIntegration = true;
        shellIntegration.enableZshIntegration = true;
        actionAliases =
          { }
          // lib.optionalAttrs ((opts.editor or "") == "nvim") {
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
        keybindings = {
          "ctrl+alt+n" = "launch --cwd=current";
          "alt+w" = "copy_and_clear_or_interrupt";
          "ctrl+y" = "paste_from_clipboard";
          "alt+1" = "goto_tab 1";
          "alt+2" = "goto_tab 2";
          "alt+3" = "goto_tab 3";
          "alt+4" = "goto_tab 4";
          "alt+5" = "goto_tab 5";
          "alt+6" = "goto_tab 6";
          "alt+7" = "goto_tab 7";
          "alt+8" = "goto_tab 8";
          "alt+9" = "goto_tab 9";
          "alt+0" = "goto_tab 10";
        }
        // lib.optionalAttrs ((opts.editor or "") == "nvim") {
          "kitty_mod+h" = "kitty_scrollback_nvim";
        };
      };
    }
  ];
}
