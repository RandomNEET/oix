{ lib }:
rec {
  theme = {
    modifiers = [
      "dark"
      "light"
      "hard"
      "soft"
      "medium"
      "latte"
      "frappe"
      "macchiato"
      "mocha"
      "storm"
      "moon"
    ];

    bashModifiers = lib.concatStringsSep "|" theme.modifiers;

    getBaseName =
      name:
      let
        stripOnce = n: lib.foldl' (acc: mod: lib.removeSuffix "-${mod}" acc) n theme.modifiers;
        stripAll =
          n:
          let
            nextName = stripOnce n;
          in
          if nextName == n then n else stripAll nextName;
      in
      stripAll name;

    getBase16Scheme =
      scheme:
      let
        fullName = lib.removeSuffix ".yaml" (builtins.baseNameOf (builtins.toString scheme));
      in
      theme.getBaseName fullName;

    getThemesArray =
      themesList:
      let
        baseNames = map theme.getBaseName themesList;
        uniqueThemes = lib.unique baseNames;
      in
      lib.concatStringsSep " " (map (t: ''"${t}"'') uniqueThemes);
  };
}
