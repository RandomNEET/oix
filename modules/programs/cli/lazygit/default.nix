{
  home-manager.sharedModules = [
    {
      programs.lazygit = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {
          git = {
            overrideGpg = true;
          };
        };
      };
    }
  ];
}
