{
  home-manager.sharedModules = [
    {
      programs.spotify-player = {
        enable = true;
        settings = {
          playback_window_position = "Top";
          copy_command = {
            command = "wl-copy";
            args = [ ];
          };
        };
      };
    }
  ];
}
