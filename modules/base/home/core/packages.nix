{ pkgs, meta, ... }:
{
  home.packages =
    if (meta.platform == "home-manager") then
      with pkgs;
      [
        _7zz-rar
        bubblewrap
        dust
        lsof
        nix-diff
        nvd
        openssl
        rsync
        wget
      ]
    else
      [ ];
}
