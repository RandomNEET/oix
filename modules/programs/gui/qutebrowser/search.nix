{ opts, ... }:
(
  {
    DEFAULT = "https://duckduckgo.com/?q={}";
    d = "https://duckduckgo.com/?q={}";
    g = "https://www.google.com/search?hl=en&q={}";
    w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
    dl = "https://www.deepl.com/translator#-/-/{}";
    aw = "https://wiki.archlinux.org/?search={}";
    nw = "https://wiki.nixos.org/index.php?search={}";
    mn = "https://mynixos.com/search?q={}";
    hm = "https://home-manager-options.extranix.com/?query={}";
    ng = "https://noogle.dev/q?term={}";
    nps = "https://search.nixos.org/packages?channel=25.05&query={}";
    npu = "https://search.nixos.org/packages?channel=unstable&query={}";
  }
  // opts.qutebrowser.searchEngines or { }
)
