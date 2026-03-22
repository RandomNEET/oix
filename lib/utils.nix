{ lib, ... }:
{
  utils = {
    scanAndImport =
      path: filterFunc:
      let
        content = builtins.readDir path;
      in
      builtins.map (name: path + "/${name}") (
        lib.attrsets.mapAttrsToList (name: type: name) (lib.attrsets.filterAttrs filterFunc content)
      );
    unstableOnly = lib.optionalAttrs (lib.versionAtLeast lib.version "26.05");
    stableOnly = lib.optionalAttrs (!lib.versionAtLeast lib.version "26.05");
  };
}
