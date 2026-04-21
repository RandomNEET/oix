{
  config,
  lib,
  meta,
  ...
}:
{
  programs.nixvim = lib.mkIf config.programs.lazygit.enable {
    plugins.lazygit = {
      enable = true;
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          cmd = "LazyGit";
        };
      };
    };
    keymaps = [
      {
        mode = [
          "n"
        ];
        key = "<leader>lg";
        action = "<cmd>LazyGit<cr>";
        options = {
          desc = "Open lazygit";
        };
      }
    ];
  };
}
