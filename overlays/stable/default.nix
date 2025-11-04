{ inputs, opts }:
final: prev: {
  stable = inputs."nixpkgs-stable".legacyPackages.${final.stdenv.hostPlatform.system};
}
