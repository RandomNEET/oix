{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
        colors = config.lib.stylix.colors;

        base = ''
          default_language = "english1000"
        '';

        theme = lib.optionalString hasThemes ''
          [theme]
          default = "none"
          border_type = "rounded"
          title = "${colors.base0E};bold"
          input_border = "${colors.base0D}"
          prompt_border = "${colors.base02}"
          prompt_correct = "${colors.base0B}"
          prompt_incorrect = "${colors.base08}"
          prompt_untyped = "${colors.base03}"
          prompt_current_correct = "${colors.base0B};bold;underlined"
          prompt_current_incorrect = "${colors.base08};bold;underlined"
          prompt_current_untyped = "${colors.base05};bold"
          prompt_cursor = "${colors.base05};underlined"
          results_overview = "${colors.base0B};bold"
          results_chart = "${colors.base0D}"
          results_chart_y = "${colors.base03};italic"
        '';
      in
      {
        home = {
          packages = with pkgs; [ ttyper ];
          file = {
            ".config/ttyper/config.toml".text = base + theme;
            ".config/ttyper/language/symbol".source = ./symbol;
          };
        };
      }
    )
  ];
}
