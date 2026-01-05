{
  config,
  lib,
  pkgs,
  opts,
  ...
}:
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
    title = "${colors.base0E};bold"
    input_border = "${colors.base0D}"
    prompt_border = "${colors.base0B}"
    border_type = "rounded"

    prompt_correct = "${colors.base0B}"
    prompt_incorrect = "${colors.base08}"
    prompt_untyped = "${colors.base04}"
    prompt_current_correct = "${colors.base0B};bold"
    prompt_current_incorrect = "${colors.base08};bold"
    prompt_current_untyped = "${colors.base0C};bold"
    prompt_cursor = "${colors.base05};underlined"

    results_overview = "${colors.base0D};bold"
    results_overview_border = "${colors.base0D}"
    results_worst_keys = "${colors.base09};bold"
    results_worst_keys_border = "${colors.base09}"
    results_chart = "${colors.base0E}"
    results_chart_x = "${colors.base0E}"
    results_chart_y = "${colors.base04};italic"
    results_restart_prompt = "${colors.base03};italic"
  '';
in
{
  home-manager.sharedModules = [
    {
      home = {
        packages = with pkgs; [ ttyper ];
        file = {
          ".config/ttyper/config.toml".text = base + theme;
          ".config/ttyper/language/symbol".source = ./symbol;
        };
      };
    }
  ];
}
