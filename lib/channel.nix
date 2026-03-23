{ lib, ... }:
let
  isUnstable = lib.versionAtLeast lib.version "26.05";
in
{
  channel = {
    getStateVersion =
      {
        channel ? "unstable",
        ...
      }:
      if channel == "stable" then "25.11" else "26.05";
    unstableOnly = attrs: lib.optionalAttrs isUnstable attrs;
    stableOnly = attrs: lib.optionalAttrs (!isUnstable) attrs;
  };
}
