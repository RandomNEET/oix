{
  osConfig,
  config,
  lib,
  mylib,
  ...
}:
let
  inherit (lib) optionalAttrs;
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  programs.atuin = lib.mkMerge [
    {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      daemon.enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        data_dir = "${config.xdg.dataHome}/atuin";
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
        enter_accept = true;
        update_check = false;
        ai = {
          enabled = true;
          opening = {
            send_cwd = true;
          };
        };
      }
      // optionalAttrs config.programs.tmux.enable { tmux.enabled = true; };
    }
    (optionalAttrs osConfig.desktop.themes.enable {
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
    })
  ];
}
