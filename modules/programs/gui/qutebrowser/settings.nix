{ opts, ... }:
{
  fonts = {
    default_size = "10pt";
    default_family = [
      "JetBrainsMono Nerd Font"
      "Noto Sans"
      "monospace"
    ];
  };
  window = {
    hide_decoration = opts.qutebrowser.window.hide_decoration or false;
    transparent = opts.qutebrowser.window.transparent or false;
  };
  tabs = {
    show = opts.qutebrowser.tabs.show or "always";
  };
  scrolling = {
    smooth = true;
  };
  colors = {
    webpage = {
      darkmode = {
        enabled = true;
      };
    };
  };
  url = {
    default_page = opts.qutebrowser.url.default_page or "https://start.duckduckgo.com/";
    start_pages = opts.qutebrowser.url.start_pages or "https://start.duckduckgo.com/";
  };
}
