{
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) mkOrder optionalString;
in
{
  programs.zsh = {
    enable = true;
  };
  home-manager.sharedModules = [
    (
      { config, ... }:
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
            plugins = [
              {
                name = "vi-mode";
                src = pkgs.zsh-vi-mode;
                file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
              }
            ];

            initContent = lib.mkMerge (
              [
                # mkBefore: Early initialization
                (mkOrder 500 "")
                # Before completion initialization
                (mkOrder 550 ''
                  autoload -U up-line-or-beginning-search
                  autoload -U down-line-or-beginning-search
                  zle -N up-line-or-beginning-search
                  zle -N down-line-or-beginning-search
                  function zvm_config() {
                    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
                    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
                    ZVM_VI_HIGHLIGHT_FOREGROUND=black
                    ZVM_VI_HIGHLIGHT_BACKGROUND=white
                  }
                '')
                # default: General configuration
                (mkOrder 1000 ''
                  function search_keybinds() {
                    bindkey -M emacs "^[[A" up-line-or-beginning-search
                    bindkey -M viins "^[[A" up-line-or-beginning-search
                    bindkey -M vicmd "^[[A" up-line-or-beginning-search
                    bindkey -M emacs "^[[B" down-line-or-beginning-search
                    bindkey -M viins "^[[B" down-line-or-beginning-search
                    bindkey -M vicmd "^[[B" down-line-or-beginning-search
                  }
                  zvm_after_init_commands+=(search_keybinds)
                  ${optionalString config.programs.fzf.enable ''
                    function fzf_init() {
                      ${builtins.readFile ./init/fzf.zsh}
                    }
                    zvm_after_init_commands+=(fzf_init)
                  ''}
                  function zvm_after_lazy_keybindings() {
                    zvm_bindkey vicmd 'k' up-line-or-beginning-search
                    zvm_bindkey vicmd 'j' down-line-or-beginning-search
                  }
                '')
                # mkAfter: Last to run configuration
                (mkOrder 1500 ''
                  ${optionalString config.programs.git.enable (builtins.readFile ./init/git.zsh)}
                '')
              ]
              ++ (opts.zsh.initContent or [ ])
            );

            shellGlobalAliases = {
              G = "| grep";
              ".." = "..";
              "..." = "../..";
              "...." = "../../..";
              "....." = "../../../..";
            }
            // (opts.zsh.shellGlobalAliases or { });

            shellAliases = {
              "_" = "sudo ";
              update = "sudo nixos-rebuild switch";
            }
            // (opts.zsh.shellAliases or { });
          };
          fzf.enableZshIntegration = lib.mkForce false; # keybinds overwritten by zsh-vi-mode, source manually instead
        };
      }
    )
  ];
}
