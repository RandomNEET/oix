{ config, ... }:
{
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor = {
        base-directory = config.xdg.userDirs.download;
      };
    };
  };
}
