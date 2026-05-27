{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./options.nix ];

  services.mbsync = {
    enable = true;
    postExec =
      ""
      + lib.optionalString osConfig.desktop.enable (import ./scripts/notify.nix { inherit config pkgs; });
  };
}
