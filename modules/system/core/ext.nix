{
  lib,
  mylib,
  opts,
  isExt,
  ...
}:
let
  inherit (lib) mkForce;
in
lib.optionalAttrs isExt {
  home-manager.sharedModules = [
    {
      nixpkgs = {
        overlays = mkForce [ ];
        config.allowUnfree = mkForce true;
      };
      home.stateVersion = mylib.channel.getStateVersion opts;
      programs.home-manager.enable = mkForce true;
    }
    { config = lib.mkForce (builtins.removeAttrs (opts.home-manager or { }) [ "enable" ]); }
  ];
}
