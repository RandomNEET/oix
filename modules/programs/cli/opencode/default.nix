{
  home-manager.sharedModules = [
    (_: {
      programs.opencode = {
        enable = true;
        settings = {
          autoshare = false;
          autoupdate = true;
          keybinds = {
            leader = "ctrl+x";
          };
        };
      };
    })
  ];
}
