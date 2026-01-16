{ config, lib, ... }:
let
  inherit (lib) optionals;
in
{
  programs.nixvim = {
    autoCmd =
      [ ]
      # Auto inactive fcitx5 when leaving insert mode
      ++ optionals (config.i18n.inputMethod.type == "fcitx5") [
        {
          event = [
            "InsertLeave"
            "ModeChanged"
          ];
          pattern = "*";
          callback = {
            __raw = ''
              function()
                vim.schedule(function()
                  local state = tonumber(vim.fn.system("fcitx5-remote"))
                  if state ~= 1 then
                    vim.fn.system("fcitx5-remote -c")
                  end
                end)
              end
            '';
          };
        }
      ];
  };
}
