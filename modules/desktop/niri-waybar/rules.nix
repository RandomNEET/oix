{
  layer-rules = [
    {
      matches = [ { namespace = "swww-daemon"; } ];
      place-within-backdrop = true;
    }
  ];

  window-rules = [
    {
      geometry-corner-radius = {
        top-left = 10.0;
        top-right = 10.0;
        bottom-left = 10.0;
        bottom-right = 10.0;
      };
      clip-to-geometry = true;
    }

    {
      matches = [
        {
          app-id = "firefox";
          title = "^Picture-in-Picture$";
        }
      ];
      open-floating = true;
    }

    {
      matches = [
        { app-id = "kitty"; }
        { app-id = "foot"; }
        { app-id = "footclient"; }
        { app-id = "editor"; }
        { app-id = "terminalFileManager"; }
        { app-id = "Spotify"; }
        { app-id = "steam"; }
        { app-id = "code"; }
        { app-id = "obsidian"; }
      ];
      draw-border-with-background = false;
      opacity = 0.95;
    }
  ];
}
