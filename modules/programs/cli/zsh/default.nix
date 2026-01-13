{
  lib,
  pkgs,
  opts,
  ...
}:
let
  inherit (lib) mkOrder;
in
{
  programs.zsh = {
    enable = true;
  };
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.zsh = {
          enable = true;
          defaultKeymap = "viins";
          enableCompletion = true;
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

          initContent = lib.mkMerge (
            [
              # mkBefore: Early initialization
              (mkOrder 500 '''')
              # Before completion initialization
              (mkOrder 550 '''')
              # default: General configuration
              (mkOrder 1000 ''
                function zvm_config() {
                  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
                  ZVM_SYSTEM_CLIPBOARD_ENABLED=true
                  ZVM_VI_HIGHLIGHT_FOREGROUND=black
                  ZVM_VI_HIGHLIGHT_BACKGROUND=white
                }
                source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
              '')
              # Before completion initialization
              (mkOrder 1500 '''')
            ]
            ++ (opts.zsh.initContent or [ ])
          );

          envExtra = '''' + (opts.zsh.envExtra or "");

          shellGlobalAliases = {
            G = "| grep";
          }
          // (opts.zsh.shellGlobalAliases or { });

          shellAliases = {
            update = "sudo nixos-rebuild switch";
          }
          // (opts.zsh.shellAliases or { });
        };
      }
    )
  ];
}
