{
  inputs,
  lib,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    (
      { config, pkgs, ... }:
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        themes = opts.themes or [ ];
        hasThemes = themes != [ ];
        themeName = lib.removeSuffix ".yaml" (builtins.baseNameOf config.stylix.base16Scheme);
        theme = "text";
        matchedTextColorScheme =
          if themeName == "catppuccin-mocha" then
            "CatppuccinMocha"
          else if themeName == "catppuccin-macchiato" then
            "CatppuccinMacchiato"
          else if themeName == "catppuccin-latte" then
            "CatppuccinLatte"
          else if themeName == "dracula" then
            "Dracula"
          else if themeName == "gruvbox-dark-hard" then
            "Gruvbox"
          else if themeName == "kanagawa" then
            "Kanagawa"
          else if themeName == "nord" then
            "Nord"
          else if themeName == "rose-pine" then
            "RosePine"
          else if themeName == "rose-pine-moon" then
            "RosePineMoon"
          else if themeName == "rose-pine-dawn" then
            "RosePineDawn"
          else if themeName == "solarized-dark" then
            "Solarized"
          else if themeName == "tokyo-night-dark" then
            "TokyoNight"
          else if themeName == "tokyo-night-storm" then
            "TokyoNightStorm"
          else if themeName == "everforest-dark-hard" then
            "EverforestDarkHard"
          else if themeName == "everforest-dark-medium" then
            "EverforestDarkMedium"
          else if themeName == "everforest-dark-soft" then
            "EverforestDarkSoft"
          else
            "";
      in
      {
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        programs.spicetify = {
          enable = true;
          enabledExtensions = with spicePkgs.extensions; [
            shuffle
            keyboardShortcut
          ];
          enabledCustomApps = with spicePkgs.apps; [
            lyricsPlus
            historyInSidebar
          ];
        }
        // lib.optionalAttrs (hasThemes && (theme == "text") && (matchedTextColorScheme != "")) {
          theme = lib.mkForce spicePkgs.themes.text;
          colorScheme = lib.mkForce matchedTextColorScheme;
        };
      }
    )
  ];
}
