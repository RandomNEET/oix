{
  home-manager.sharedModules = [
    {
      programs.bat = {
        enable = true;
        config = {
          style = "plain";
        };
      };
    }
  ];
}
