{ inputs }:
final: prev:
import ../../pkgs {
  config = final.config;
  lib = prev.lib;
  pkgs = final;
}
