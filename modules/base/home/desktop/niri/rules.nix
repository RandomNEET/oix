{
  layer-rules = [
    {
      matches = [ { namespace = "^(noctalia-wallpaper)$"; } ];
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
      matches = [ { app-id = "^(dev.noctalia.Noctalia.Settings)$"; } ];
      open-floating = true;
    }

    {
      matches = [
        { app-id = "^(org.qutebrowser.qutebrowser)$"; }
        { app-id = "^(firefox)$"; }
      ];
      opacity = 1.00;
    }

    {
      matches = [
        { app-id = "^(kitty|foot|footclient)$"; }
        { app-id = "^(editor)$"; }
        { app-id = "^(fileManager)$"; }
        { app-id = "^(code)$"; }
        { app-id = "^(spotify)$"; }
        { app-id = "^(steam)$"; }
        { app-id = "^(org.gnupg.pinentry-qt)$"; }
      ];
      opacity = 0.80;
    }

    {
      matches = [
        { app-id = "^(terminal filechooser)$"; }
      ];
      opacity = 0.80;
      open-floating = true;
    }

    {
      matches = [
        { title = "^(QtPass)$"; }
      ];
      opacity = 0.80;
      open-floating = true;
    }
  ];
}
