# Requirements: virtualisation.podman.enable = true;
{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.virtualisation.podman.enable {
    services.podman = {
      enable = true;
      package = osConfig.virtualisation.podman.package;
      autoUpdate.enable = true;
      settings = {
        containers = {
          engine = {
            compose_providers = [ "${pkgs.podman-compose}/bin/podman-compose" ];
          };
        };
      };
    };
    home.packages = with pkgs; [ podman-compose ];
  };
}
