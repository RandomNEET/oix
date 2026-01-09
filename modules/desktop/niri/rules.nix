''
  layer-rule {
      match namespace="swww-daemon"
      place-within-backdrop true
  }

  window-rule {
      geometry-corner-radius 10
      clip-to-geometry true
  }

  window-rule {
      match app-id=r#"firefox"# title="^Picture-in-Picture$"
      open-floating true
  }

  window-rule {
      draw-border-with-background false
      match app-id="kitty"
      match app-id="foot"
      match app-id="footclient"
      match app-id="editor"
      match app-id="terminalFileManager"
      match app-id="Spotify"
      match app-id="steam"
      match app-id="code"
      match app-id="obsidian"
      opacity 0.95
  }
''
