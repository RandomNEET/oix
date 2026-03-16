{ pkgs, opts, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      dust
      lsof
      rsync
      wget
      _7zz-rar
      openssl
      nix-diff
    ]
    ++ (opts.packages pkgs).system or [ ];
  home-manager.sharedModules = [
    {
      home.packages = with pkgs; [ ] ++ (opts.packages pkgs).home or [ ];
    }
  ];
}
