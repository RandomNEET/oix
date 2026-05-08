{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [ vim-startuptime ];
    globals = {
      startuptime_tries = 10;
      startuptime_exe_path = "nvim";
    };
  };
}
