{ pkgs, opts, ... }:
{
  virtualisation.docker = {
    enable = true;

    enableOnBoot = opts.docker.enableOnBoot or true;
    storageDriver = opts.docker.storageDriver or null;
    listenOptions = opts.docker.listenOptions or [ "/run/docker.sock" ];
    logDriver = opts.docker.logDriver or "journald";

    autoPrune = {
      enable = opts.docker.autoPrune.enable or false;
      dates = opts.docker.autoPrune.dates or "weekly";
      flags = opts.docker.autoPrune.flags or [ ];
      persistent = opts.docker.autoPrune.persistent or true;
      randomizedDelaySec = opts.docker.autoPrune.randomizedDelaySec or "0";
    };

    daemon = {
      settings = opts.docker.daemon.settings or { };
    };

    rootless = {
      enable = opts.docker.rootless.enable or false;
      setSocketVariable = opts.docker.rootless.setSocketVariable or false;
    };

    extraOptions = opts.docker.extraOptions or "";
    extraPackages = with pkgs; [ ];
  };

  users = {
    users = {
      ${opts.username} = {
        extraGroups = [ "docker" ];
      };
    };
  };
}
