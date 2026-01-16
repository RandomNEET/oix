{ lib }:
let
  files = builtins.filter (f: f != "default.nix") (builtins.attrNames (builtins.readDir ./.));
  importedFiles = builtins.map (f: import (./. + "/${f}") { inherit lib; }) files;
in
builtins.foldl' lib.recursiveUpdate { } importedFiles
