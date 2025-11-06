{
  lib,
  opts,
  ...
}:
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
        }
        // lib.optionalAttrs ((opts.theme or "") != "") {
          colors = import ./themes/${opts.theme}.nix;
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
