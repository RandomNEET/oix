{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasDesktop = config.desktop.enable;
in
{
  imports = [ ./options.nix ];

  services.mbsync = {
    enable = true;
    postExec =
      "" + lib.optionalString hasDesktop (import ./scripts/notify.nix { inherit config pkgs; });
  };
}
