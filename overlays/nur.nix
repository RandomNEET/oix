{ inputs }:
final: _prev: {
  nur = import inputs.nur {
    nurpkgs = final;
    pkgs = final;
  };
}
