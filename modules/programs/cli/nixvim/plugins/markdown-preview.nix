{
  config,
  lib,
  opts,
  ...
}:
{
  programs.nixvim = lib.mkIf ((opts.browser or "") != "" && config.programs.${opts.browser}.enable) {
    plugins.markdown-preview = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings = {
          ft = "markdown";
        };
      };
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
  };
}
