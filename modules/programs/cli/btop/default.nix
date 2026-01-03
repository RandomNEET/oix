{
  home-manager.sharedModules = [
    (_: {
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
        };
      };
    })
  ];
}
