{
  home-manager.sharedModules = [
    (_: {
      programs.lazygit = {
        enable = true;
        settings = {
          git = {
            overrideGpg = true;
          };
        };
      };

      home.shellAliases = {
        lg = "lazygit";
      };
    })
  ];
}
