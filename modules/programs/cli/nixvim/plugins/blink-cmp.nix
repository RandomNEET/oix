{ lib, opts, ... }:
{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "super-tab";
        };
        sources = {
          providers = {
          }
          // lib.optionalAttrs ((opts.nixvim.copilot.enable or true) && (opts.nixvim.copilot.cmp or false)) {
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
          };
          default = [
            "lsp"
            "path"
            "buffer"
          ]
          ++ lib.optional (
            (opts.nixvim.copilot.enable or true) && (opts.nixvim.copilot.cmp or false)
          ) "copilot";
        };
        cmdline = lib.mkIf (opts.nixvim.noice.enable or true) {
          enabled = false;
        };
      };
    };
    plugins.blink-cmp-copilot.enable =
      (opts.nixvim.copilot.enable or true) && (opts.nixvim.copilot.cmp or false);
  };
}
