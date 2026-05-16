{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "60min";
    };
  };
}
