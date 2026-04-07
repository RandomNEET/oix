{
  osConfig,
  config,
  lib,
  pkgs,
  meta,
  ...
}:
let
  inherit (lib) mkOrder optionalString;
in
{
  programs = {
    zsh = {
      enable = true;
      defaultKeymap = "viins";
      enableCompletion = true;
      completionInit = ''
        autoload -U compinit && compinit
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      '';
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreAllDups = true;
        ignoreDups = true;
        saveNoDups = true;
        size = 100000;
      };
      setOptions = [
        "AUTO_CD"
        "AUTO_PUSHD"
        "PUSHD_IGNORE_DUPS"
        "PUSHD_SILENT"
        "CORRECT"
        "EXTENDED_GLOB"
        "GLOB_DOTS"
      ];
      plugins = [ ];

      initContent = lib.mkMerge [
        # mkBefore: Early initialization
        (mkOrder 500 "")
        # Before completion initialization
        (mkOrder 550 ''
          autoload -U up-line-or-beginning-search
          autoload -U down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search
          function search_keybinds() {
            bindkey -M emacs "^[[A" up-line-or-beginning-search
            bindkey -M viins "^[[A" up-line-or-beginning-search
            bindkey -M vicmd "^[[A" up-line-or-beginning-search
            bindkey -M emacs "^[[B" down-line-or-beginning-search
            bindkey -M viins "^[[B" down-line-or-beginning-search
            bindkey -M vicmd "^[[B" down-line-or-beginning-search
          }
        '')
        # default: General configuration
        (mkOrder 1000 ''
          if [[ -n "$NVIM" ]]; then
            bindkey -e
            search_keybinds
            ${optionalString config.programs.fzf.enable (builtins.readFile ./init/fzf.zsh)}
          else
            function zvm_config() {
              ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
              ZVM_SYSTEM_CLIPBOARD_ENABLED=true
              ZVM_VI_HIGHLIGHT_FOREGROUND=black
              ZVM_VI_HIGHLIGHT_BACKGROUND=white
            }
            source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
            zvm_after_init_commands+=(search_keybinds)
            function zvm_after_lazy_keybindings() {
              zvm_bindkey vicmd 'k' up-line-or-beginning-search
              zvm_bindkey vicmd 'j' down-line-or-beginning-search
            }
            ${optionalString config.programs.fzf.enable ''
              function fzf_init() {
                ${builtins.readFile ./init/fzf.zsh}
              }
              zvm_after_init_commands+=(fzf_init)
            ''}
          fi
        '')
        # mkAfter: Last to run configuration
        (mkOrder 1500 "")
      ];

      shellGlobalAliases = {
        G = "| grep";
        ".." = "..";
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
      };

      shellAliases = {
        "_" = "sudo ";
        update =
          if osConfig.programs.nh.enable then
            "nh os switch -H ${meta.hostname}"
          else
            "nh home switch -c ${meta.username}-${meta.hostname}";
      };
    };
    fzf.enableZshIntegration = lib.mkForce false; # keybinds overwritten by zsh-vi-mode, source manually instead
  };
}
