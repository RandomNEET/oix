{ pkgs, opts, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = opts.docker.enableOnBoot or true;
    daemon = { } // (opts.docker.daemon or { });
    rootless = {
      enable = opts.docker.rootless.enable or false;
    };
    autoPrune = {
      enable = opts.docker.autoPrune.enable or true;
      dates = opts.docker.autoPrune.dates or "weekly";
      flags = opts.docker.autoPrune.flags or [ "--all" ];
      persistent = opts.docker.autoPrune.persistent or true;
      randomizedDelaySec = opts.docker.autoPrune.randomizedDelaySec or "60min";
    };
    extraOptions = opts.docker.extraOptions or "";
    extraPackages = with pkgs; [ ];
  };
}
