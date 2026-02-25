{
  layer-rules = [
    {
      matches = [ { namespace = "^noctalia-wallpaper*"; } ];
      place-within-backdrop = true;
    }
  ];

  window-rules = [
    {
      geometry-corner-radius = {
        top-left = 20.0;
        top-right = 20.0;
        bottom-left = 20.0;
        bottom-right = 20.0;
      };
      clip-to-geometry = true;
    }

    {
      matches = [
        { app-id = "^(org\.qutebrowser\.qutebrowser)$"; }
        { app-id = "^(firefox)$"; }
      ];
      opacity = 1.00;
    }

    {
      matches = [
        { app-id = "^(kitty|foot|footclient)$"; }
        { app-id = "^(editor)$"; }
        { app-id = "^(terminalFileManager)$"; }
        { app-id = "^(code)$"; }
        { app-id = "^(spotify)$"; }
        { app-id = "^(steam)$"; }
        { app-id = "^(org\.gnupg\.pinentry-qt)$"; }
      ];
      opacity = 0.95;
    }

    {
      matches = [
        {
          app-id = "^(firefox)$";
          title = "^Picture-in-Picture$";
        }
      ];
      open-floating = true;
    }
  ];
}
