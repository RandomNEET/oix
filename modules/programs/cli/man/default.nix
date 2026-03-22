{ mylib, ... }:
{
  documentation = {
    enable = true;
    man = {
      enable = true;
    }
    // mylib.utils.unstableOnly {
      cache = {
        enable = true;
        generateAtRuntime = true;
      };
    };
  };
  home-manager.sharedModules = [
    {
      programs.man = {
        enable = true;
        generateCaches = true;
      };
    }
  ];
}
