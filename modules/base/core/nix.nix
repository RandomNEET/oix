{ meta, ... }:
{
  nix = {
    settings = {
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      randomizedDelaySec = "60min";
    };
    registry = {
      oix = {
        to = {
          type = "path";
          path = meta.flake;
        };
      };
    };
  };
}
