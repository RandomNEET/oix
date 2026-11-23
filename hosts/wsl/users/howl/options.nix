{ pkgs, ... }:
{
  defaultPrograms = {
    editor = {
      default = "nvim";
    };
    fileManager = {
      default = "yazi";
    };
  };

  home = {
    packages = with pkgs; [ wl-clipboard ];
  };
}
