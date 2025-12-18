{ lib, opts, ... }:
let
  copilotCmpEnabled = (opts.nixvim.copilot.enable or false) && (opts.nixvim.copilot.cmp or false);
in
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
          // lib.optionalAttrs copilotCmpEnabled {
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
          ++ lib.optional copilotCmpEnabled "copilot";
        };
        cmdline = lib.mkIf copilotCmpEnabled {
          enabled = false;
        };
      };
    };
    plugins.blink-cmp-copilot.enable = copilotCmpEnabled;
  };
}
