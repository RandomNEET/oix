{
  lib,
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
          stateVersion = if (opts.channel or "unstable") == "stable" then "25.11" else "26.05";
        }
        // (opts.home or { });
      programs.home-manager.enable = mkForce true;
    }
  ];
}
