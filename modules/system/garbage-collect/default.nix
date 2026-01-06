{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
      randomizedDelaySec = "60min";
    };
    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "60min";
    };
  };
  home-manager.sharedModules = [
    (_: {
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        persistent = true;
        randomizedDelaySec = "60min";
      };
    })
  ];
}
