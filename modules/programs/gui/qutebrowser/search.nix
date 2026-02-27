{ opts, ... }:
(
  {
    DEFAULT = "https://duckduckgo.com/?q={}";
    d = "https://duckduckgo.com/?q={}";
    g = "https://www.google.com/search?hl=en&q={}";
    w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
    te = "https://translate.google.com/?sl=auto&tl=en&text={}&op=translate";
    tz = "https://translate.google.com/?sl=auto&tl=zh-CN&text={}&op=translate";
    aw = "https://wiki.archlinux.org/?search={}";
    nw = "https://wiki.nixos.org/index.php?search={}";
    mn = "https://mynixos.com/search?q={}";
    ng = "https://noogle.dev/q?term={}";
    nou = "https://search.nixos.org/options?channel=unstable&query={}";
    nos = "https://search.nixos.org/options?channel=25.11&query={}";
    npu = "https://search.nixos.org/packages?channel=unstable&query={}";
    nps = "https://search.nixos.org/packages?channel=25.11&query={}";
    hmu = "https://home-manager-options.extranix.com/?query={}&release=master";
    hms = "https://home-manager-options.extranix.com/?query={}&release=release-25.11";
  }
  // opts.qutebrowser.searchEngines or { }
)
