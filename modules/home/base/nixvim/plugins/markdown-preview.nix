{
  osConfig,
  lib,
  meta,
  ...
}:
{
  programs.nixvim =
    lib.mkIf osConfig.desktop.enable {
      plugins.markdown-preview = {
        enable = true;
        settings = {
          auto_close = 1;
          page_title = "「\${name}」";
          port = "8080";
          preview_options = {
            disable_filename = 1;
            disable_sync_scroll = 1;
            sync_scroll_type = "middle";
          };
          theme = "dark";
        };
      };
      keymaps = [
        {
          mode = [
            "n"
          ];
          key = "<leader>mp";
          action = "<cmd>MarkdownPreviewToggle<cr>";
          options = {
            desc = "Open markdown previrew in browser";
          };
        }
      ];
    }
    // lib.optionalAttrs (meta.channel == "unstable") {
      lazyLoad = {
        enable = true;
        settings = {
          ft = "markdown";
        };
      };
    };
}
