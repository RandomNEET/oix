{ pkgs, ... }:
{
  defaultPrograms = {
    editor = "nvim";
    fileManager = "yazi";
  };

  home = {
    packages = with pkgs; [ wl-clipboard ];
  };
}
