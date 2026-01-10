{
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) optionalString;
in
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
        programs.tmux = {
          enable = true;
          mouse = true;
          prefix = "C-a";
          keyMode = "vi";
          clock24 = true;
          escapeTime = 10;
          focusEvents = true;
          historyLimit = 100000;
          terminal = "tmux-256color";
          extraConfig = ''
            # Options
            set -g allow-rename off
            set -g status-position bottom
            set -g base-index 1
            set -g pane-base-index 1
            set -g renumber-windows on
            set-window-option -g pane-base-index 1
            set -ga terminal-overrides ",*:Tc"
            set -g allow-passthrough on
            set -ga update-environment TERM
            set -ga update-environment TERM_PROGRAM

            # Tmux binds
            bind r command-prompt "rename-window %%"
            bind R source-file ~/.config/tmux/tmux.conf
            bind w list-windows
            bind * setw synchronize-panes
            bind P set pane-border-status
            bind -n C-M-c kill-pane
            bind x swap-pane -D
            bind z resize-pane -Z

            # Resize panes
            bind -n M-Left resize-pane -L 2
            bind -n M-Right resize-pane -R 2
            bind -n M-Up resize-pane -U 2
            bind -n M-Down resize-pane -D 2

            # Splits
            bind | split-window -h -c "#{pane_current_path}"
            bind - split-window -v -c "#{pane_current_path}"
            bind c new-window -c "#{pane_current_path}"

            # Select windows
            bind -n S-Left  previous-window
            bind -n S-Right next-window

            bind -n C-M-h  previous-window
            bind -n C-M-l next-window

            # vi mode
            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
            bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          '';
          plugins = with pkgs.tmuxPlugins; [
            {
              plugin = minimal-tmux-status;
              extraConfig = ''
                set -g @minimal-tmux-status "bottom"
                set -g @minimal-tmux-show-expanded-icon-for-all-tabs true
                set -g @minimal-tmux-use-arrow true
                set -g @minimal-tmux-right-arrow ""
                set -g @minimal-tmux-left-arrow ""
              ''
              + optionalString hasThemes ''
                set -g @minimal-tmux-fg "#${colors.base00}"
                set -g @minimal-tmux-bg "#${colors.base0E}"
              '';
            }
            {
              plugin = tmux-sessionx;
              extraConfig = ''
                set -g @sessionx-bind 'o'
                set -g @sessionx-prefix on
                set -g @sessionx-x-path '${config.home.homeDirectory}/repo'
                ${optionalString config.programs.fzf.enable "set -g @sessionx-fzf-builtin-tmux 'on'"}
                ${optionalString config.programs.zoxide.enable "set -g @sessionx-zoxide-mode 'on'"}
              '';
            }
            {
              plugin = resurrect;
              extraConfig = ''
                set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
                ${optionalString ((opts.editor or "") == "nvim") "set -g @resurrect-strategy-nvim 'session'"}
              '';
            }
            vim-tmux-navigator
          ];
        };

        home.shellAliases = {
          ta = "tmux attach -t";
          tad = "tmux attach -d -t";
          tkss = "tmux kill-session -t";
          tksv = "tmux kill-server";
          tl = "tmux list-sessions";
          ts = "tmux new-session -s";
        };

        programs.zsh = lib.mkIf config.programs.zsh.enable {
          initContent = ''
            bindkey -s '^t' "tmux\r"
          '';
        };
      }
    )
  ];
}
