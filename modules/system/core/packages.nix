{ pkgs, opts, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    with pkgs;
    [
      dust
      lsof
      rsync
      wget
      _7zz-rar
      openssl
    ]
    ++ (opts.packages pkgs).system or [ ];
  home-manager.sharedModules = [
    {
      home.packages =
        with pkgs;
        [
          nix-diff
          nvd
        ]
        ++ (opts.packages pkgs).home or [ ];
    }
  ];
}
