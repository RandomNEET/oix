{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.defaultPrograms.editor.nvim.enable ({
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [ vim-startuptime ];
      globals = {
        startuptime_tries = 10;
        startuptime_exe_path = "nvim";
      };
    };
  });
}
