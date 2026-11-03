{
  osConfig,
  config,
  lib,
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
      programs.atuin = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        daemon.enable = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://api.atuin.sh";
          search_mode = "fuzzy";
          enter_accept = false;
          update_check = false;
        }
        // lib.optionalAttrs config.programs.tmux.enable { tmux.enabled = true; };
      };
    }
    (lib.mkIf osConfig.desktop.themes.enable {
      programs.atuin = {
        settings.theme.name = "stylix";
        themes.stylix = {
          theme.name = "stylix";
          colors = with colors; {
            Base = base05;
            Title = primaryColor;
            Important = primaryColor;
            Guidance = base0C;
            Annotation = base03;
            AlertInfo = base0B;
            AlertWarn = base0A;
            AlertError = base08;
          };
        };
      };
    })
  ];
}
