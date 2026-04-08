{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasDesktop = config.desktop.enable;
in
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
  home.packages = lib.optionals hasDesktop [
    (pkgs.makeDesktopItem {
      name = "spotify-player";
      desktopName = "spotify-player";
      genericName = "Music Player";
      comment = "A Spotify player in the terminal with full feature parity";
      icon = "spotify-client";
      exec = "spotify_player";
      terminal = true;
      type = "Application";
      categories = [
        "Audio"
        "Music"
        "Player"
        "ConsoleOnly"
      ];
      extraConfig = {
        Keywords = "music;spotify;player;tui;";
      };
    })
  ];
}
