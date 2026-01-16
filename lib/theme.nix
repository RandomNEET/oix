{ lib }:
rec {
  theme = {
    stripModifiers =
      name:
      let
        modifiers = [
          "dark"
          "light"
          "hard"
          "soft"
          "medium"
          "dim"
          "high"
          "low"
          "storm"
          "moon"
          "latte"
          "frappe"
          "macchiato"
          "mocha"
          "pro"
          "soda"
          "classic"
          "reloaded"
          "alt"
          "alternate"
          "pale"
          "tints"
          "mirage"
          "256"
        ];
        stripOnce = n: lib.foldl' (acc: mod: lib.removeSuffix "-${mod}" acc) n modifiers;
        stripAll =
          n:
          let
            nextName = stripOnce n;
          in
          if nextName == n then n else stripAll nextName;
      in
      stripAll name;

    getBaseName =
      scheme:
      let
        fullName = lib.removeSuffix ".yaml" (builtins.baseNameOf (builtins.toString scheme));
      in
      theme.stripModifiers fullName;

    getThemesArray =
      themesList:
      let
        baseNames = map theme.stripModifiers themesList;
        uniqueThemes = lib.unique baseNames;
      in
      lib.concatStringsSep " " (map (t: ''"${t}"'') uniqueThemes);
  };
}
