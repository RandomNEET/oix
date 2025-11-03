{
  pkgs,
  opts,
  ...
}:
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

          oh-my-zsh = {
            enable = opts.zsh.oh-my-zsh.enable or false;
            plugins = opts.zsh.oh-my-zsh.plugins or [ ];
            theme = opts.zsh.oh-my-zsh.theme or "";
            custom = opts.zsh.oh-my-zsh.custom or "";
            extraConfig = opts.zsh.oh-my-zsh.extraConfig or "";
          };
        };
      }
    )
  ];
}
