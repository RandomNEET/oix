{
  osConfig,
  config,
  mylib,
  ...
}:
let
  bookmarks = import ./bookmarks.nix;
  renderLink = link: ''<a href="${link.url}">${link.label}</a>'';
  renderGroup = group: ''
    <section>
      <h2>${group.label}</h2>
      ${builtins.concatStringsSep "\n" (map renderLink group.links)}
    </section>
  '';
  renderedBookmarks = builtins.concatStringsSep "\n" (map renderGroup bookmarks);

  themesEnabled = osConfig.desktop.themes.enable;
  colors = if themesEnabled then config.lib.stylix.colors else fallbackColors;
  primaryColor =
    if themesEnabled then
      mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme
    else
      fallbackColors.base0E;
  fallbackColors = {
    base00 = "1e1e2e";
    base04 = "a6adc8";
    base05 = "cdd6f4";
    base0C = "94e2d5";
    base0E = "cba6f7";
  };
in
{
  xdg.configFile = {
    "qutebrowser/startpage/index.html".text = ''
      <!doctype html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>~/startpage</title>
          <link rel="stylesheet" href="style.css">
        </head>
        <body>
          <main class="startpage">
            <h1>&gt; cd ~/<span class="cursor">_</span></h1>

            <nav class="bookmarks" aria-label="Bookmarks">
              ${renderedBookmarks}
            </nav>
          </main>
        </body>
      </html>
    '';

    "qutebrowser/startpage/style.css".text = ''
      :root {
        color-scheme: dark;
        --color-bg: #${colors.base00};
        --color-fg: #${colors.base05};
        --color-link: #${colors.base04};
        --color-link-visited: #${colors.base0C};
        --color-link-hover: #${primaryColor};
      }

      * {
        box-sizing: border-box;
      }

      html,
      body {
        min-height: 100vh;
      }

      body {
        display: grid;
        place-items: center;
        margin: 0;
        padding: 2rem;
        background: var(--color-bg);
        color: var(--color-fg);
        font-family: "JetBrainsMono Nerd Font", monospace;
      }

      .startpage {
        width: min(100%, 56rem);
      }

      h1 {
        margin: 0 0 3rem;
        text-align: center;
        font-size: clamp(2rem, 5vw, 2.5rem);
        font-weight: 500;
      }

      .bookmarks {
        display: grid;
        grid-template-columns: repeat(4, minmax(8rem, 1fr));
        gap: 2rem;
      }

      section {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.625rem;
      }

      h2 {
        margin: 0 0 0.5rem;
        color: var(--color-fg);
        font-size: 1.25rem;
        font-weight: 500;
      }

      a {
        color: var(--color-link);
        text-decoration: none;
      }

      a:visited {
        color: var(--color-link-visited);
      }

      a:hover,
      a:focus-visible,
      h2 a:hover,
      h2 a:focus-visible {
        color: var(--color-link-hover);
      }

      h2 a,
      h2 a:visited {
        color: var(--color-fg);
      }

      .cursor {
        animation: blink 1s ease-in-out infinite;
      }

      @keyframes blink {
        50% {
          opacity: 0;
        }
      }

      @media (max-width: 42rem) {
        .bookmarks {
          grid-template-columns: repeat(2, minmax(8rem, 1fr));
        }
      }

      @media (max-width: 22rem) {
        .bookmarks {
          grid-template-columns: 1fr;
        }
      }
    '';
  };
}
