{
  home-manager.sharedModules = [
    {
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
    }
  ];
}
