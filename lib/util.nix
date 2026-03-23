{ lib, ... }:
{
  util = {
    scanAndImport =
      path: filterFunc:
      let
        content = builtins.readDir path;
      in
      builtins.map (name: path + "/${name}") (
        lib.attrsets.mapAttrsToList (name: type: name) (lib.attrsets.filterAttrs filterFunc content)
      );
  };
}
