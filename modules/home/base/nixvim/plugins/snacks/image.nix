{ config, ... }:
{
  programs.nixvim = {
    plugins.snacks.settings.image = {
      enabled = builtins.elem config.defaultPrograms.terminal [
        "kitty"
        "ghostty"
        "wezterm"
      ];
    };
  };
}
