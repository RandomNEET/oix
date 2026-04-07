{ config, lib, ... }:
{
  programs.spotify-player = {
    enable = true;
    settings = {
      playback_window_position = "Top";
      copy_command = {
        command = "wl-copy";
        args = [ ];
      };
      device = {
        audio_cache = false;
        normalization = false;
      };
      notify_transient = true;
    };
  };
  home =
    { }
    // lib.optionalAttrs config.desktop.enable {
      file.".local/share/applications/spotify-player.desktop".text = ''
        [Desktop Entry]
        Name=spotify-player
        GenericName=Music Player
        Comment=A Spotify player in the terminal with full feature parity
        Categories=Audio;Music;Player;ConsoleOnly;
        Type=Application
        Icon=spotify-client
        Terminal=true
        Exec=spotify_player
        Keywords=music;spotify;player;tui;
      '';
    };
}
