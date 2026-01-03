{ lib, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.fzf = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          tmux.enableShellIntegration = true;
        };

        programs.zsh = lib.mkIf config.programs.zsh.enable {
          initContent = ''
            bindkey '^f' "fzf-file-widget"
          '';
        };
      }
    )
  ];
}
