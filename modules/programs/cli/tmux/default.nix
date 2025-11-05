{
  lib,
  pkgs,
  opts,
  ...
}:
let
  theme = lib.optionalAttrs ((opts.theme or "") != "") (import ./${opts.theme}.nix { inherit pkgs; });
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
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
          plugins = with pkgs.tmuxPlugins; [ vim-tmux-navigator ] ++ (theme.plugins or [ ]);
          extraConfig = ''
            # Options
            set -g @catppuccin_flavour 'mocha'
            set -g allow-rename off
            set -g status-position top
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

            # Select panes
            bind h select-pane -L
            bind l select-pane -R
            bind k select-pane -U
            bind j select-pane -D

            # Resize panes
            # bind -n M-h resize-pane -L 2
            # bind -n M-l resize-pane -R 2
            # bind -n M-k resize-pane -U 2
            # bind -n M-j resize-pane -D 2
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
          ''
          + (theme.extraConfig or "");
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
