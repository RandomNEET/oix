{ pkgs, ... }:
{
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
    };
  };
}
