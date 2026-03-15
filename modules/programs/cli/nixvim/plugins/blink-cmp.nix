{ config, lib, ... }:
{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          use_nvim_cmp_as_default = true;
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution = {
                enabled = false;
              };
            };
          };
          documentation = {
            auto_show = true;
          };
        };
        keymap = {
          preset = "super-tab";
        };
        signature = {
          enabled = true;
        };
        sources = {
          default = (lib.optional config.programs.nixvim.plugins.lsp.enable "lsp") ++ [
            "buffer"
            "snippets"
            "path"
          ];
        };
      };
    };
  };
}
