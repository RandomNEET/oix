{
  home-manager.sharedModules = [
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    }
  ];
}
