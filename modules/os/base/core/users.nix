{
  users.mutableUsers = false;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
  nix.settings.trusted-users = [ "@wheel" ];
}
