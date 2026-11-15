{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _7zz-rar
    bubblewrap
    dust
    lsof
    nix-diff
    nvd
    openssl
    rsync
    wget
  ];
}
