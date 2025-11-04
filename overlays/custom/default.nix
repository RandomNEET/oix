{ inputs, opts }:
final: prev:
import ../../pkgs {
  pkgs = final;
  inherit opts;
}
