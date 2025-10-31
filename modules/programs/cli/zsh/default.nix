{
  pkgs,
  opts,
  ...
}:
{
  programs.zsh.enable = true;
  users.users.${opts.username}.shell = pkgs.zsh;
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.zsh = {
          enable = true;
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

          initExtra = opts.zsh.initContent or '''';

          envExtra = opts.zsh.envExtra or '''';

          shellGlobalAliases =
            opts.zsh.shellGlobalAliases or {
              G = "| grep";
            };

          shellAliases =
            opts.zsh.shellAliases or {
              update = "sudo nixos-rebuild switch";
            };

          oh-my-zsh =
            opts.zsh.oh-my-zsh or {
              enable = true;
              plugins = [ "vi-mode" ];
              theme = "simple";
            };
        };
      }
    )
  ];
}
