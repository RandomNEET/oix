{ lib, opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.kitty = {
          enable = true;
          shellIntegration.enableBashIntegration = true;
          shellIntegration.enableZshIntegration = true;
          settings = {
            kitty_mod = "ctrl+shift";
            clear_all_shortcuts = true;
            confirm_os_window_close = 0;
            close_on_child_death = true;
            mouse_hide_wait = 3;
            enable_audio_bell = false;
            update_check_interval = 0;
            # Cursor
            cursor_trail = 1;
            cursor_trail_decay = "0.1 0.4";
            cursor_trail_start_threshold = "4";
            # Remote control
            allow_remote_control = true;
            listen_on = "unix:\${XDG_RUNTIME_DIR}/kitty";
          }
          // lib.optionalAttrs ((opts ? editor) && (opts.editor == "nvim")) {
            scrollback_pager = "nvim --cmd 'set eventignore=FileType' +'nnoremap q ZQ' +'call nvim_open_term(0, {})' +'set nomodified nolist' +'$' -";
          }
          // (opts.kitty.settings or { });
          keybindings = {
            "kitty_mod+c" = "copy_to_clipboard";
            "kitty_mod+v" = "paste_from_clipboard";
            "kitty_mod+up" = "scroll_line_up";
            "kitty_mod+k" = "scroll_line_up";
            "kitty_mod+page_up" = "scroll_page_up";
            "kitty_mod+page_down" = "scroll_page_down";
            "kitty_mod+home" = "scroll_home";
            "kitty_mod+end" = "scroll_end";
            "kitty_mod+/" = "search_scrollback";
            "kitty_mod+h" = "show_scrollback";
            "kitty_mod+equal" = "change_font_size all +2.0";
            "kitty_mod+minus" = "change_font_size all -2.0";
            "kitty_mod+backspace" = "change_font_size all 0";
            "kitty_mod+e" = "open_url_with_hints";
          }
          // lib.optionalAttrs config.programs.tmux.enable {
            "kitty_mod+t" = "launch --type=overlay --cwd=current tmux";
          };
        };
      }
    )
  ];
}
