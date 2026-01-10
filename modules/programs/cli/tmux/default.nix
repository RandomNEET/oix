{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) optionalString;
  check =
    pname: builtins.any (p: (builtins.isAttrs p) && (lib.getName p == pname)) config.home.packages;
in
{
  home-manager.sharedModules = [
    (
      { osConfig, config, ... }:
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
              plugin = dotbar;
              extraConfig = ''
                set -g @tmux-dotbar-position "bottom"
                set -g @tmux-dotbar-justify "absolute-centre"
                set -g @tmux-dotbar-left "true"
                set -g @tmux-dotbar-right true
                set -g @tmux-dotbar-ssh-enabled true
                set -g @tmux-dotbar-ssh-icon-only true
                set -g @tmux-dotbar-ssh-icon '󰌘'
              ''
              + optionalString hasThemes ''
                set -g @tmux-dotbar-bg "#${colors.base00}"
                set -g @tmux-dotbar-fg "#${colors.base04}"
                set -g @tmux-dotbar-fg-current "#${colors.base05}"
                set -g @tmux-dotbar-fg-session "#${colors.base03}"
                set -g @tmux-dotbar-fg-prefix "#${colors.base0E}"
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
              plugin = tmux-floax;
              extraConfig = ''
                set -g @floax-bind 'p'
                set -g @floax-bind-menu 'P'
              ''
              + optionalString hasThemes ''
                set -g @floax-border-color "#${colors.base0B}"
                set -g @floax-text-color "#${colors.base0D}"
              '';
            }
            {
              plugin = resurrect;
              extraConfig = ''
                set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
                set -g @resurrect-processes '
                  ${optionalString ((opts.editor or "") == "nvim") ''"~nvim->nvim"''}
                  ${optionalString config.programs.yazi.enable ''"~yazi->yazi"''}
                  ${optionalString config.programs.opencode.enable ''"~opencode->opencode"''}
                  ${optionalString config.programs.aerc.enable ''"~aerc->aerc"''}
                  ${optionalString config.programs.lazygit.enable ''"lazygit"''}
                  ${optionalString config.programs.btop.enable ''"btop"''}
                  ${optionalString osConfig.programs.htop.enable ''"htop"''}
                  "~man"
                  less more tail top ssh
                '
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
