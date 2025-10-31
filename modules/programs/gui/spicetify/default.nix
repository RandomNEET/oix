{ inputs, ... }:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.text;
          colorScheme = "CatppuccinMocha";
          enabledExtensions = with spicePkgs.extensions; [
            shuffle
            keyboardShortcut
          ];
          enabledCustomApps = with spicePkgs.apps; [
            lyricsPlus
            historyInSidebar
          ];
        };
      }
    )
  ];
}
