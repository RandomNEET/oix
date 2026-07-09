{
  osConfig,
  config,
  lib,
  mylib,
}:
let
  themesEnabled = osConfig.desktop.themes.enable;
  themeName =
    if themesEnabled then mylib.theme.getBase16Scheme config.stylix.base16Scheme else "default";
  matchedPredefinedScheme =
    if themesEnabled then
      if themeName == "ayu" then
        "Ayu"
      else if themeName == "catppuccin-mocha" then
        "Catppuccin"
      else if themeName == "dracula" then
        "Dracula"
      else if themeName == "eldritch" then
        "Eldritch"
      else if themeName == "gruvbox-dark-hard" then
        "Gruvbox"
      else if themeName == "kanagawa" then
        "Kanagawa"
      else if themeName == "nord" then
        "Nord"
      else if themeName == "rose-pine" then
        "Rose Pine"
      else if themeName == "tokyo-night-dark" then
        "Tokyo Night"
      else
        ""
    else
      "Noctalia";
in
{
  mode = "dark";
  source = "builtin";
  builtin = if themesEnabled then matchedPredefinedScheme else "Noctalia";
  templates = {
    builtin_ids = [ ];
    community_ids = [ ];
    enable_builtin_templates = false;
    enable_community_templates = false;
  };
}
