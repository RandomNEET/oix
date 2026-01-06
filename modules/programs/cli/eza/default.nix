{
  home-manager.sharedModules = [
    {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        icons = "auto";
      };
    }
  ];
}
