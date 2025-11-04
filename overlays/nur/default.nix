{ inputs, opts }:
final: prev: {
  nur = import inputs.nur {
    nurpkgs = final;
    pkgs = final;
  };
}
