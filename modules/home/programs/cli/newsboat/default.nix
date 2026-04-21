{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  hasDesktop = osConfig.desktop.enable;
  hasThemes = osConfig.desktop.themes.enable;
in
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
    browser = "${lib.getExe pkgs.${config.defaultPrograms.browser}}";
  };
  home.packages = lib.optionals hasDesktop [
    (pkgs.makeDesktopItem {
      name = "newsboat";
      desktopName = "Newsboat";
      genericName = "RSS/Atom Reader";
      comment = "Read RSS and Atom feeds in the terminal";
      icon = "newsboat";
      exec = "newsboat";
      terminal = true;
      type = "Application";
      categories = [
        "Network"
        "ConsoleOnly"
      ];
      extraConfig = {
        Keywords = "RSS;Atom;Feed;Reader;News";
      };
    })
  ];
}
