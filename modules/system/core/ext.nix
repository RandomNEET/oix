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
      home =
        (opts.home or { })
        // {
          stateVersion = mylib.channel.getStateVersion opts;
        }
        // (opts.home or { });
      programs.home-manager.enable = mkForce true;
    }
  ];
}
