{ lib, opts, ... }:
{
  services.mpd = rec {
    enable = true;

    user =
      if ((opts.mpd.outputType or "") == "pipewire") then
        opts.users.primary.name
      else
        (opts.mpd.user or "mpd");
    group = opts.mpd.group or "mpd";

    dataDir = opts.mpd.dataDir or "/var/lib/mpd";
    musicDirectory = opts.mpd.musicDirectory or "${dataDir}/music";
    playlistDirectory = opts.mpd.playlistDirectory or "${dataDir}/playlists";
    dbFile = opts.mpd.dbFile or "${dataDir}/tag_cache";

    network = {
      listenAddress = opts.mpd.network.listenAddress or "127.0.0.1";
      port = opts.mpd.network.port or 6600;
    };
    credentials = opts.mpd.credentials or [ ];

    fluidsynth = opts.mpd.fluidsynth or false;
    startWhenNeeded = opts.mpd.startWhenNeeded or false;

    extraConfig = '''' + (opts.mpd.extraConfig or "");
  };

  systemd.services.mpd.environment = lib.mkIf ((opts.mpd.outputType or "") == "pipewire") {
    XDG_RUNTIME_DIR = "/run/user/${toString opts.users.primary.uid}";
  };
}
