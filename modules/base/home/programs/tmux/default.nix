{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  meta,
  ...
}:
let
  inherit (lib) optionalString;
  themesEnabled = osConfig.desktop.themes.enable;
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
  resurrectDir = "${config.xdg.stateHome}/tmux/resurrect";
  resurrect-cmd-fix = import ./scripts/resurrect-cmd-fix.nix { inherit pkgs resurrectDir; };
in
{
  programs = {
    tmux = {
      enable = true;
      mouse = true;
      prefix = "C-a";
      keyMode = "vi";
      clock24 = true;
      escapeTime = 10;
      focusEvents = true;
      historyLimit = 100000;
      terminal = "tmux-256color";
      secureSocket = true;
      extraConfig = ''
        # Options
        set -s set-clipboard on
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -g extended-keys on
        set -g extended-keys-format csi-u
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set -g renumber-windows on
        set -g status-position bottom
        set -g allow-rename off

        # Tmux binds
        bind ^X lock-server
        bind ^C new-window -c "$HOME"
        bind ^D detach
        bind H previous-window
        bind L next-window
        bind N previous-window
        bind n next-window
        bind r command-prompt "rename-window %%"
        bind R source-file ${config.xdg.configHome}/tmux/tmux.conf
        bind ^A last-window
        bind ^W list-windows
        bind w list-windows
        bind z resize-pane -Z
        bind ^L refresh-client
        bind | split-window
        bind s split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind '"' choose-window
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind -r -T prefix , resize-pane -L 20
        bind -r -T prefix . resize-pane -R 20
        bind -r -T prefix - resize-pane -D 7
        bind -r -T prefix = resize-pane -U 7
        bind : command-prompt
        bind * setw synchronize-panes
        bind c kill-pane
        bind x swap-pane -D
        bind S choose-session
        bind K send-keys "clear"\; send-keys "Enter"

        # Vi mode
        bind-key [ copy-mode
        bind-key -T copy-mode-vi v send-keys -X begin-selection
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
            set -g @tmux-dotbar-bold-current-window true
            set -g @tmux-dotbar-rounded true
            set -g @tmux-dotbar-ssh-enabled true
            set -g @tmux-dotbar-ssh-icon-only true
            set -g @tmux-dotbar-ssh-icon '󰌘'
          ''
          + optionalString themesEnabled ''
            set -g @tmux-dotbar-bg "${colors.base00}"
            set -g @tmux-dotbar-fg "${colors.base03}"
            set -g @tmux-dotbar-fg-current "${primaryColor}"
            set -g @tmux-dotbar-fg-session "${colors.base03}"
            set -g @tmux-dotbar-fg-prefix "${primaryColor}"
          '';
        }
        {
          plugin = tmux-floax;
          extraConfig = ''
            set -g @floax-bind 'p'
            set -g @floax-bind-menu 'P'
          ''
          + optionalString themesEnabled ''
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
              ${optionalString config.programs.nixvim.enable ''"~nvim->nvim"''}
              ${optionalString config.programs.helix.enable ''"~hx->hx"''}
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
              config.defaultPrograms.editor == "nvim"
            ) "set -g @resurrect-strategy-nvim 'session'"}
          '';
        }
        vim-tmux-navigator
      ];
      tmuxinator.enable = true;
    };
    sesh = {
      enable = true;
      enableTmuxIntegration = true;
      enableAlias = true;
      icons = true;
      tmuxKey = "o";
      settings = {
        blacklist = [ "scratch" ];
        sort_order = [
          "tmux"
          "config"
          "tmuxinator"
          "zoxide"
        ];
        session = [
          {
            name = "oix";
            path = meta.flake;
            icon = "";
          }
        ];
      };
    };
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
// lib.optionalAttrs osConfig.desktop.themes.enable {
  stylix.targets.tmux.enable = true;
}
