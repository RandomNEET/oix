{ pkgs, opts, ... }:
{
  home-manager.sharedModules = [
    (_: {
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
        '';
        browser = opts.newsboat.browser or opts.browser or "${pkgs.xdg-utils}/bin/xdg-open";
        queries = opts.newsboat.queries or { };
        urls = opts.newsboat.urls or [ ];
      };
    })
  ];
}
