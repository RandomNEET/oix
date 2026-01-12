{
  lib,
  pkgs,
  opts,
  ...
}:
let
  themes = opts.themes or [ ];
  hasThemes = themes != [ ];
in
{
  home-manager.sharedModules = [
    {
      programs.newsboat = {
        enable = true;
        autoReload = true;
        reloadTime = 60;
        reloadThreads = 5;
        maxItems = 0;
        extraConfig = ''
          cleanup-on-quit yes

          bind-key h quit
          bind-key j down
          bind-key k up
          bind-key l open
          bind-key g home
          bind-key G end
          bind-key S save-all
          bind-key ^p halfpageup
          bind-key ^n halfpagedown
          bind-key m mark-feed-read
        ''
        + lib.optionalString hasThemes ''
          color listnormal         color15 default
          color listnormal_unread  color2  default
          color listfocus_unread   color2  color8
          color listfocus          default color8
          color background         default default
          color article            default default
          color end-of-text-marker color8  default
          color info               color4  color8
          color hint-separator     default color8
          color hint-description   default color8
          color title              color14 color8

          highlight article "^(Feed|Title|Author|Link|Date): .+" color4 default bold
          highlight article "^(Feed|Title|Author|Link|Date):" color14 default bold

          highlight article "\\((link|image|video)\\)" color8 default
          highlight article "https?://[^ ]+" color4 default
          highlight article "\[[0-9]+\]" color6 default bold
        '';
        browser = opts.browser or "${pkgs.xdg-utils}/bin/xdg-open";
        queries = { } // (opts.newsboat.queries or { });
        urls = [ ] ++ (opts.newsboat.urls or [ ]);
      };
    }
  ];
}
