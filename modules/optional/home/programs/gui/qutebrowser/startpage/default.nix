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
  appearance = import ../appearance.nix { inherit osConfig config mylib; };
  inherit (appearance)
    colors
    primaryColor
    polarity
    hexToRgba
    ;
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
          <link id="theme" rel="stylesheet" href="style.css">
          <script src="theme.js" defer></script>
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
        color-scheme: ${polarity};
        --color-bg: #${colors.base00};
        --color-fg: #${colors.base05};
        --color-link: #${colors.base04};
        --color-link-visited: #${colors.base0C};
        --color-link-hover: #${primaryColor};
        --color-glow: ${hexToRgba primaryColor 0.12};
        --color-glow-secondary: ${hexToRgba colors.base0C 0.08};
      }
      ${builtins.readFile ./style.css}
    '';
    "qutebrowser/startpage/theme.js".source = ./theme.js;
  };
}
