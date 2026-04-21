{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  hasDesktop = osConfig.desktop.enable;
in
{
  imports = [ ./options.nix ];

  services.mbsync = {
    enable = true;
    postExec =
      "" + lib.optionalString hasDesktop (import ./scripts/notify.nix { inherit config pkgs; });
  };
}
