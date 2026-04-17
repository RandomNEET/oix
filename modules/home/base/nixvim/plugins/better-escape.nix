{ lib, meta, ... }:
{
  programs.nixvim = {
    plugins.better-escape = {
      enable = true;
      settings = {
        mappings = {
          i = {
            j = {
              k = "<Esc>";
              j = "<Esc>";
            };
          };
          c = {
            j = {
              k = "<C-c>";
              j = "<C-c>";
            };
          };
          t = {
            j = {
              k = "<C-\\><C-n>";
            };
          };
          v = {
            j = {
              k = "<Esc>";
            };
          };
          s = {
            j = {
              k = "<Esc>";
            };
          };
        };
        timeout = 300;
      };
    };
  }
  // lib.optionalAttrs (meta.channel == "unstable") {
    lazyLoad = {
      enable = true;
      settings = {
        event = [
          "BufReadPost"
          "BufNewFile"
          "BufWritePre"
        ];
      };
    };
  };
}
