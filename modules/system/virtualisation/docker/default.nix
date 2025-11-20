{ pkgs, opts, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = opts.virtualisation.docker.enableOnBoot or true;
    daemon = { } // (opts.virtualisation.docker.daemon or { });
    rootless = {
      enable = opts.virtualisation.docker.rootless.enable or false;
    };
    autoPrune = {
      enable = opts.virtualisation.docker.autoPrune.enable or true;
      dates = opts.virtualisation.docker.autoPrune.dates or "weekly";
      flags = opts.virtualisation.docker.autoPrune.flags or [ "--all" ];
      persistent = opts.virtualisation.docker.autoPrune.persistent or true;
      randomizedDelaySec = opts.virtualisation.docker.autoPrune.randomizedDelaySec or "60min";
    };
    extraOptions = opts.virtualisation.docker.extraOptions or "";
    extraPackages = with pkgs; [ ];
  };
}
