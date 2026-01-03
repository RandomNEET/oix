{ inputs, ... }:
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
        };
      }
    )
  ];
}
