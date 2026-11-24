{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _7zz-rar
    dust
    lsof
    nix-diff
    nvd
    openssl
    rsync
    wget
  ];
}
