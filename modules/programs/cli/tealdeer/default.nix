{
  home-manager.sharedModules = [
    {
      programs.tealdeer = {
        enable = true;
        enableAutoUpdates = true;
        settings = {
          display = {
            compact = false;
            use_pager = true;
          };
        };
      };
    }
  ];
}
