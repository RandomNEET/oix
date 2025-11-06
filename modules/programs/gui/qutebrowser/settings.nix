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
  completion = {
    open_categories =
      opts.qutebrowser.completion.open_categories or [
        "searchengines"
        "quickmarks"
        "bookmarks"
        "history"
        "filesystem"
      ];
    show = opts.qutebrowser.completion.show or "always";
    shrink = opts.qutebrowser.completion.shrink or false;
    height = opts.qutebrowser.completion.height or "50%";
    use_best_match = opts.qutebrowser.completion.use_best_match or false;
    web_history = {
      exclude = [ ] ++ (opts.qutebrowser.completion.web_history.exclude or [ ]);
      max_items = opts.qutebrowser.completion.web_history.max_items or (-1);
    };
  };
  content = {
    fullscreen.window = opts.qutebrowser.content.fullscreen.window or false;
    blocking = {
      enabled = opts.qutebrowser.content.blocking.enabled or true;
      method = opts.qutebrowser.content.blocking.method or "auto";
      hosts = {
        block_subdomains = opts.qutebrowser.content.blocking.block_subdomains or true;
        lists = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
        ]
        ++ (opts.qutebrowser.content.blocking.hosts.lists or [ ]);
      };
      whitelist = [ ] ++ (opts.qutebrowser.content.blocking.whitelist or [ ]);
    };
  };
  url = {
    default_page = opts.qutebrowser.url.default_page or "https://start.duckduckgo.com/";
    start_pages = opts.qutebrowser.url.start_pages or "https://start.duckduckgo.com/";
  };
}
