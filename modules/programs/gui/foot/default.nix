{
  home-manager.sharedModules = [
    {
      programs.foot = {
        enable = true;
        settings = {
          mouse = {
            hide-when-typing = "yes";
          };
          key-bindings = {
            scrollback-up-half-page = "Control+Shift+k";
            scrollback-down-half-page = "Control+Shift+j";
          };
        };
      };
    }
  ];
}
