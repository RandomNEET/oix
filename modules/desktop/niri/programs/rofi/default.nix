{
  lib,
  pkgs,
  opts,
  ...
}:
{
  home-manager.sharedModules = [
    {
      programs.rofi = {
        enable = true;
        terminal = "${lib.getExe pkgs.${opts.terminal}}";
        plugins = with pkgs; [
          rofi-emoji # https://github.com/Mange/rofi-emoji 🤯
          rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
        ];
        extraConfig = import ./config.nix;
      };
      xdg.configFile =
        let
          baseDir = ./themes;
          content = builtins.readDir baseDir;
          templateFiles = builtins.attrNames (
            lib.attrsets.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".rasi" n) content
          );
          themeDirs = builtins.attrNames (lib.attrsets.filterAttrs (n: v: v == "directory") content);
          mkThemeMapping =
            base:
            (builtins.listToAttrs (
              map (file: {
                name = "rofi/themes/${base}/${file}";
                value = {
                  source = baseDir + "/${file}";
                };
              }) templateFiles
            ))
            // {
              "rofi/themes/${base}/shared/colors.rasi" = {
                source = baseDir + "/${base}/colors.rasi";
              };
              "rofi/themes/${base}/shared/fonts.rasi" = {
                source = baseDir + "/${base}/fonts.rasi";
              };
            };
          allMappings = lib.foldl' (acc: theme: acc // (mkThemeMapping theme)) { } themeDirs;
        in
        allMappings;
    }
  ];
}
