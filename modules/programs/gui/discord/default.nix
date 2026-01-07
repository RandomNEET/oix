{
  home-manager.sharedModules = [
    {
      programs.vesktop = {
        enable = true;
        settings = {
          notifyAboutUpdates = true;
          autoUpdate = false;
          autoUpdateNotification = false;
        };
      };
    }
  ];
}
