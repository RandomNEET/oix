{
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      randomizedDelaySec = "30min";
    };
    optimise = {
      automatic = true;
      persistent = true;
      dates = "weekly";
    };
  };
  home-manager.sharedModules = [
    (_: {
      nix.gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
        randomizedDelaySec = "30min";
      };
    })
  ];
}
