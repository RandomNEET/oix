{ pkgs, ... }:
{
  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
      tree_view = true;
      color_scheme = 3;
    };
    package = pkgs.htop-vim;
  };
}
