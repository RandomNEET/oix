{ inputs }:
final: prev: {
  unstable = inputs.nixpkgs.legacyPackages.${final.stdenv.hostPlatform.system};
}
