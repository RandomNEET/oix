{ opts, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.yt-dlp = {
          enable = true;
          settings = {
            embed-metadata = true;
            output = "${config.xdg.userDirs.download}/%(title)s.%(ext)s";
          };
          extraConfig = "" + (opts.yt-dlp.extraConfig or "");
        };
      }
    )
  ];
}
