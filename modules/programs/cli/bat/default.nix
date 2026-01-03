{
  home-manager.sharedModules = [
    (_: {
      programs.bat = {
        enable = true;
        config = {
          style = "plain";
        };
      };
    })
  ];
}
