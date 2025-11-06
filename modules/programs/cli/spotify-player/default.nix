{
  lib,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.spotify-player = {
        enable = true;
        settings = {
        }
        // lib.optionalAttrs ((opts.theme or "") != "") {
          theme = opts.theme;
        };
      };
      home.file.".config/spotify-player/theme.toml".source = ./theme.toml;
    })
  ];
}
