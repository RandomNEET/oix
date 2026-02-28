{ inputs }:
final: prev:
import ../../pkgs {
  lib = prev.lib;
  pkgs = final;
  prev = prev;
}
