{ inputs }:
final: _prev: {
  unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};
}
