{
  osConfig,
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
let
  inherit (lib) optionalAttrs;
  colors = config.lib.stylix.colors.withHashtag;
  primaryColor = mylib.theme.getThemePrimaryColor colors config.stylix.base16Scheme;
in
{
  programs.television = lib.mkMerge [
    {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        default_channel = "files";
        ui = {
          ui_scale = 100;
          orientation = "landscape";
          input_bar = {
            position = "top";
            border_type = "rounded";
          };
          results_panel = {
            border_type = "rounded";
          };
          preview_panel = {
            size = 60;
            scrollbar = true;
            border_type = "rounded";
          };
        };
      };
    }
    (import ./channels.nix { inherit osConfig config lib; })
    (optionalAttrs config.programs.atuin.enable {
      package = pkgs.symlinkJoin {
        name = "television-without-history-keybinding-${pkgs.television.version}";
        inherit (pkgs.television) version;
        paths = [ pkgs.television ];
        postBuild = ''
          sed -i '/^bindkey .*tv-shell-history$/d' "$out/share/television/completion.zsh"
          sed -i '/^bind -x .*tv_shell_history/d' "$out/share/television/completion.bash"
        '';
      };
    })
    (optionalAttrs (osConfig.oix.desktop.themes.enable or false) {
      settings.ui.theme = "stylix";
      themes.stylix = with colors; {
        background = base00;
        border_fg = base03;
        text_fg = base05;
        dimmed_text_fg = base04;
        input_text_fg = base05;
        result_count_fg = primaryColor;
        result_name_fg = base05;
        result_line_number_fg = base0A;
        result_value_fg = base05;
        selection_fg = base06;
        selection_bg = base02;
        match_fg = primaryColor;
        preview_title_fg = primaryColor;
        channel_mode_fg = base00;
        channel_mode_bg = primaryColor;
        remote_control_mode_fg = base00;
        remote_control_mode_bg = base0A;
        action_picker_mode_fg = base00;
        action_picker_mode_bg = base0E;
        send_to_channel_mode_fg = base0C;
      };
    })
  ];
}
