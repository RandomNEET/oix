{
  home-manager.sharedModules = [
    {
      programs.eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        colors = "auto";
        icons = "auto";
        git = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };
    }
  ];
}
