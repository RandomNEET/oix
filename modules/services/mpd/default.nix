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
    startWhenNeeded = opts.mpd.startWhenNeeded or false;
    settings = {
      music_directory = opts.mpd.musicDirectory or "${dataDir}/music";
      playlist_directory = opts.mpd.playlistDirectory or "${dataDir}/playlists";
      db_file = opts.mpd.dbFile or "${dataDir}/tag_cache";
      bind_to_address = opts.mpd.network.listenAddress or "127.0.0.1";
      port = opts.mpd.network.port or 6600;
    }
    // (opts.mpd.settings or { });
  };
  systemd.services.mpd.environment = lib.mkIf ((opts.mpd.outputType or "") == "pipewire") {
    XDG_RUNTIME_DIR = "/run/user/${toString opts.users.primary.uid}";
  };
}
