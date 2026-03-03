{ pkgs, opts, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      _7zz-rar
      dust
      lsof
      openssl
      rsync
      wget
    ]
    ++ builtins.map (name: builtins.getAttr name pkgs) (opts.packages.system or [ ]);
  home-manager.sharedModules = [
    {
      home.packages =
        with pkgs;
        [ ] ++ builtins.map (name: builtins.getAttr name pkgs) (opts.packages.home or [ ]);
    }
  ];
}
