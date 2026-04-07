{ lib, meta, ... }:
{
  documentation = {
    enable = true;
    man = {
      enable = true;
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      cache = {
        enable = true;
        generateAtRuntime = true;
      };
    };
  };
}
