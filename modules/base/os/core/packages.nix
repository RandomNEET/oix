{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    dust
    lsof
    rsync
    wget
    _7zz-rar
    openssl
  ];
}
