{ pkgs, opts, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      openssl
      wget
      rsync
      _7zz-rar
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
