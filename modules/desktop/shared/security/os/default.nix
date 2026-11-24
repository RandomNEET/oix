{
  imports = [ ./options.nix ];

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
}
