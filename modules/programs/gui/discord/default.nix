{
  home-manager.sharedModules = [
    {
      programs.vesktop = {
        enable = true;
        settings = {
          appBadge = false;
          arRPC = true;
          checkUpdates = false;
          customTitleBar = false;
          disableMinSize = true;
          minimizeToTray = false;
          tray = false;
          splashBackground = "#000000";
          splashColor = "#ffffff";
          splashTheming = true;
          staticTitle = true;
          hardwareAcceleration = true;
          discordBranch = "stable";
        };
        vencord = {
          settings = {
            autoUpdate = false;
            autoUpdateNotification = false;
            notifyAboutUpdates = false;
            useQuickCss = true;
            disableMinSize = true;
            plugins = {
              MessageLogger = {
                enabled = true;
                ignoreSelf = true;
              };
              FakeNitro.enabled = true;
            };
          };
        };
      };
    }
  ];
}
