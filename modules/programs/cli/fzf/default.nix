{
  home-manager.sharedModules = [
    {
      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        tmux.enableShellIntegration = true;
      };
    }
  ];
}
