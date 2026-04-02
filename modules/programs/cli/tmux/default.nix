{
  lib,
  pkgs,
  mylib,
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
        hasThemes = opts ? themes;
        colors = config.lib.stylix.colors.withHashtag;
        primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
        resurrectDir = "${config.xdg.stateHome}/tmux/resurrect";
        resurrect-cmd-fix = import ./scripts/resurrect-cmd-fix.nix { inherit pkgs resurrectDir; };
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
            set -s set-clipboard on
            set -as terminal-features ',xterm-kitty:clipboard'
            set -ga terminal-overrides ",*:Tc"
            set -g allow-passthrough on
            set -ga update-environment TERM
            set -ga update-environment TERM_PROGRAM
            set -g base-index 1
            set -g pane-base-index 1
            set-window-option -g pane-base-index 1
            set -g renumber-windows on
            set -g allow-rename off
            set -g status-position bottom

            # Tmux binds
            bind r command-prompt "rename-window %%"
            bind R source-file ${config.xdg.configHome}/tmux/tmux.conf
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
                set -g @tmux-dotbar-justify left
                set -g @tmux-dotbar-left true
                set -g @tmux-dotbar-right false
                set -g @tmux-dotbar-session-position right
                set -g @tmux-dotbar-ssh-enabled true
                set -g @tmux-dotbar-ssh-icon-only true
                set -g @tmux-dotbar-ssh-icon '󰌘'
              ''
              + optionalString hasThemes ''
                set -g @tmux-dotbar-bg "${colors.base00}"
                set -g @tmux-dotbar-fg "${colors.base03}"
                set -g @tmux-dotbar-fg-current "${colors.base05}"
                set -g @tmux-dotbar-fg-session "${colors.base03}"
                set -g @tmux-dotbar-fg-prefix "${primaryColor}"
              '';
            }
            {
              plugin = tmux-sessionx;
              extraConfig = ''
                set -g @sessionx-bind 'o'
                set -g @sessionx-prefix 'on'
                set -g @sessionx-x-path '${config.home.homeDirectory}/repo'
                set -g @sessionx-tmuxinator-mode 'on'
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
                set -g @floax-border-color "${primaryColor}"
                set -g @floax-text-color "${colors.base0D}"
              '';
            }
            {
              plugin = resurrect;
              extraConfig = ''
                set -g @resurrect-dir '${resurrectDir}'
                set -g @resurrect-hook-post-save-layout '${resurrect-cmd-fix}'
                set -g @resurrect-processes '
                  ${optionalString ((opts ? editor) && (opts.editor == "nvim")) ''"~nvim->nvim"''}
                  ${optionalString config.programs.yazi.enable ''"~yazi->yazi"''}
                  ${optionalString config.programs.opencode.enable ''"~opencode->opencode"''}
                  ${optionalString config.programs.aerc.enable ''"~aerc->aerc"''}
                  ${optionalString config.programs.lazygit.enable ''"lazygit"''}
                  ${optionalString config.programs.btop.enable ''"btop"''}
                  ${optionalString config.programs.htop.enable ''"htop"''}
                  "~man"
                  less more tail top ssh
                '
                ${optionalString (
                  (opts ? editor) && (opts.editor == "nvim")
                ) "set -g @resurrect-strategy-nvim 'session'"}
              '';
            }
            vim-tmux-navigator
          ];
          tmuxinator.enable = true;
        };

        home.shellAliases = {
          # tmux
          ta = "tmux attach -t";
          tad = "tmux attach -d -t";
          tkss = "tmux kill-session -t";
          tksv = "tmux kill-server";
          tl = "tmux list-sessions";
          to = "tmux new-session -A -s";
          ts = "tmux new-session -s";
          # tmuxinator
          txs = "tmuxinator start";
          txo = "tmuxinator open";
          txn = "tmuxinator new";
          txl = "tmuxinator list";
        };
      }
    )
  ];
}
