{
  config,
  lib,
  mylib,
  opts,
  ...
}:
{
  services.mpd = {
    enable = true;
    user = if config.services.pipewire.enable then opts.users.primary.name else "mpd";
    group = "mpd";
    dataDir = "/var/lib/mpd";
    startWhenNeeded = true;
  }
  // mylib.utils.unstableOnly {
    settings = {
      bind_to_address = "127.0.0.1";
      port = 6600;
      music_directory = "${config.services.mpd.dataDir}/music";
      playlist_directory = "${config.services.mpd.dataDir}/playlists";
      db_file = "${config.services.mpd.dataDir}/tag_cache";
    }
    // (opts.mpd.settings or { });
  }
  // mylib.utils.stableOnly {
    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };
    musicDirectory = "${config.services.mpd.dataDir}/music";
    playlistDirectory = "${config.services.mpd.dataDir}/playlists";
    dbFile = "${config.services.mpd.dataDir}/tag_cache";
  }
  // (opts.mpd or { });
  systemd.services.mpd.environment = lib.mkIf config.services.pipewire.enable {
    XDG_RUNTIME_DIR = "/run/user/${toString opts.users.primary.uid}";
  };
}
