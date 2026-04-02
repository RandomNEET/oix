{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
      persistent = true;
      randomizedDelaySec = "60min";
    };
  };
}
