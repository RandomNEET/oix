{ opts, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = opts.nix.gc.dates or "weekly";
      options = opts.nix.gc.options or "--delete-older-than 1w";
      persistent = opts.nix.gc.persistent or true;
      randomizedDelaySec = opts.nix.gc.randomizeDelaySec or "60min";
    };
    optimise = {
      automatic = true;
      dates = opts.nix.optimise or "weekly";
      persistent = opts.nix.optimise.persistent or true;
      randomizedDelaySec = opts.nix.optimise.randomizeDelaySec or "60min";
    };
  };
}
