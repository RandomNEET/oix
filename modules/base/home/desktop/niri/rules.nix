[
  {
    layer-rule._children = [
      {
        match._props = {
          namespace = "^(noctalia-wallpaper)$";
        };
      }
      { place-within-backdrop = true; }
    ];
  }

  {
    window-rule._children = [
      {
        background-effect._children = [
          { blur = true; }
          { xray = false; }
        ];
      }
    ];
  }

  {
    window-rule._children = [
      {
        geometry-corner-radius._args = [
          20.0
          20.0
          20.0
          20.0
        ];
      }
      { clip-to-geometry = true; }
    ];
  }

  {
    window-rule._children = [
      {
        match._props = {
          app-id = "^(dev.noctalia.Noctalia)$";
        };
      }
      { open-floating = true; }
    ];
  }

  {
    window-rule._children = [
      {
        match._props = {
          app-id = "^(org.qutebrowser.qutebrowser)$";
        };
      }
      {
        match._props = {
          app-id = "^(firefox)$";
        };
      }
      { opacity = 1.0; }
    ];
  }

  {
    window-rule._children = [
      {
        match._props = {
          app-id = "^(kitty|foot|footclient)$";
        };
      }
      {
        match._props = {
          app-id = "^(editor)$";
        };
      }
      {
        match._props = {
          app-id = "^(fileManager)$";
        };
      }
      {
        match._props = {
          app-id = "^(code)$";
        };
      }
      {
        match._props = {
          app-id = "^(spotify)$";
        };
      }
      {
        match._props = {
          app-id = "^(steam)$";
        };
      }
      {
        match._props = {
          app-id = "^(org.gnupg.pinentry-qt)$";
        };
      }
      { opacity = 0.8; }
    ];
  }

  {
    window-rule._children = [
      {
        match._props = {
          app-id = "^(terminal filechooser)$";
        };
      }
      { opacity = 0.8; }
      { open-floating = true; }
    ];
  }
]
