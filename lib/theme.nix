{ lib }:
rec {
  theme = {
    getBase16Scheme = scheme: lib.removeSuffix ".yaml" (builtins.baseNameOf (builtins.toString scheme));

    getThemesArray =
      themesList:
      let
        uniqueThemes = lib.unique themesList;
      in
      lib.concatStringsSep " " (map (t: ''"${t}"'') uniqueThemes);

    themeRepresentations = {
      "catppuccin-mocha" = "base0E";
      "gruvbox-dark-hard" = "base09";
      "kanagawa" = "base0D";
      "nord" = "base0C";
      "tokyo-night-dark" = "base0D";
    };
    getThemePrimaryColor =
      schemeObj: schemePath:
      let
        rawSlug = theme.getBase16Scheme schemePath;
        slug = builtins.unsafeDiscardStringContext rawSlug;
        colorKey = theme.themeRepresentations.${slug} or "base0D";
      in
      schemeObj.${colorKey};
  };
}
