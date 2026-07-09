{ inputs, meta, ... }:
{
  imports = [
    (
      if (meta.channel == "unstable") then
        inputs.nix-index-database.homeModules.nix-index
      else
        inputs.nix-index-database-stable.homeModules.nix-index
    )
  ];

  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      symlinkToCacheHome = true;
    };
    nix-index-database.comma.enable = true;
  };
}
