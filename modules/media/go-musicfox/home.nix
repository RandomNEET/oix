{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  config = lib.mkMerge [
    {
      programs.go-musicfox = {
        enable = true;
        settings = {
          startup = {
            enable = true;
            checkUpdate = false;
          };
          main = {
            frameRate = 30;
            visualizer = {
              enable = true;
              style = "oscilloscope";
            };
            notification = {
              enable = true;
              albumCover = true;
            };
            lyric = {
              show = true;
              showTranslation = true;
              cover = {
                show = builtins.elem (config.oix.defaults.terminal or null) [ "kitty" ];
                tmuxPassthrough = config.programs.tmux.enable;
              };
            };
          };
        };
      };
    }
    (lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
      programs.go-musicfox.settings.theme = {
        activeTheme = "stylix";
        inherit primaryColor;
      };
      xdg.configFile."go-musicfox/themes/stylix.toml".source =
        let
          theme = {
            primary = primaryColor;
            secondary = colors.base04;
            accent = colors.base0E;
            success = colors.base0B;
            warning = colors.base0A;
            error = colors.base08;
            info = colors.base0C;
            muted = colors.base03;
            hintKey = colors.base04;
            background = colors.base00;
            foreground = colors.base05;
            border = colors.base03;
            surface = colors.base01;
            highlights = {
              menuTitle = primaryColor;
              menuItem = colors.base05;
              selectedItem = primaryColor;
              menuItemHover = colors.base0C;
              selectedItemHover = colors.base0C;
              title = primaryColor;
              prompt = primaryColor;
              backButton = colors.base04;
              backButtonHover = primaryColor;
              subtitle = colors.base04;
              progressEmpty = colors.base02;
              scrollTrack = colors.base02;
              scrollThumb = colors.base04;
              button = primaryColor;
              buttonBlurred = colors.base04;
            };
            popup = {
              surface = colors.base01;
              border = colors.base03;
            };
            notification = {
              surface = colors.base01;
              infoBorder = colors.base0C;
              successBorder = colors.base0B;
              warningBorder = colors.base0A;
              errorBorder = colors.base08;
            };
            statusBar = {
              bar = colors.base01;
              text = colors.base05;
              breadcrumb = colors.base05;
              breadcrumbSep = colors.base03;
              breadcrumbHover = colors.base0C;
              breadcrumbClick = primaryColor;
              time = colors.base04;
              nugget = colors.base05;
              nuggetLabelFg = colors.base00;
              nuggetLabelBg = primaryColor;
            };
            app = {
              lyricActive = primaryColor;
              lyricTransition = colors.base0E;
              lyricInactive = colors.base04;
              lyricHighlight = colors.base05;
              playbarMode = colors.base0E;
              playbarVolume = colors.base0D;
              playbarPlaying = colors.base0B;
              playbarPaused = colors.base0A;
              playbarHeartLiked = colors.base08;
              playbarHeartUnliked = colors.base04;
              playbarArtist = colors.base04;
              visualizerColorStart = colors.base0C;
              visualizerColorEnd = colors.base0E;
              background = colors.base00;
              contextMenuBg = colors.base01;
              contextMenuBorder = colors.base03;
              spectrumVerticalBg = colors.base00;
              desktopLyricsBg = colors.base00;
              loginError = colors.base08;
              loginSuccess = colors.base0B;
              authStatus = colors.base0D;
              configTableBorder = colors.base03;
              configTableSelectedFg = colors.base00;
              configTableSelectedBg = primaryColor;
            };
          };
        in
        (pkgs.formats.toml { }).generate "go-musicfox-stylix.toml" {
          name = "stylix";
          description = "Stylix Base16 theme";
          dark = theme;
          light = theme;
        };
    })
  ];
}
