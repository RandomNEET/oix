{
  home-manager.sharedModules = [
    (_: {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        icons = "auto";
        theme = "catppuccin";
      };
    })
  ];
}
