{ opts, ... }:
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

          initContent = '''' + (opts.zsh.initContent or "");

          envExtra = '''' + (opts.zsh.envExtra or "");

          shellGlobalAliases = {
            G = "| grep";
          }
          // (opts.zsh.shellGlobalAliases or { });

          shellAliases = {
            update = "sudo nixos-rebuild switch";
          }
          // (opts.zsh.shellAliases or { });

          oh-my-zsh = {
            enable = opts.zsh.oh-my-zsh.enable or true;
            plugins = [ "vi-mode" ] ++ (opts.zsh.oh-my-zsh.plugins or [ ]);
            extraConfig = ''
              export VI_MODE_SET_CURSOR=true
              MODE_INDICATOR="%F{red}<<<%f"
            ''
            + (opts.zsh.oh-my-zsh.extraConfig or "");
            theme = opts.zsh.oh-my-zsh.theme or "";
          };
        };
      }
    )
  ];
}
