{
  osConfig,
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
in

{
  programs.nixvim = {
    plugins.snacks.settings.indent = {
      enabled = true;
      indent = {
        enabled = true;
        char = "▏";
      };
      scope = {
        enabled = true;
        underline = false;
        char = "▎";
      };
    };
    highlightOverride = lib.mkIf osConfig.desktop.themes.enable {
      SnacksIndent = {
        fg = colors.base02;
      };
      SnacksIndentScope = {
        fg = colors.base0C;
      };
    };
  };
}
