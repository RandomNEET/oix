{ lib, opts, ... }:
{
  programs.nixvim = lib.mkIf (opts.nixvim.lsp.enable or true) {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          lua_ls.enable = true;
          yamlls.enable = true;
          nil_ls.enable = true;
          marksman.enable = true;
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          bashls.enable = true;
          jsonls.enable = true;
          ts_ls.enable = true;
          html.enable = true;
          vue_ls.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>d" = "open_float";
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gi" = "implementation";
            "gr" = "references";
            "gt" = "type_definition";
            "K" = "hover";

            "<C-k>" = "signature_help";

            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
            "<leader>wa" = "add_workspace_folder";
            "<leader>wr" = "remove_workspace_folder";
          };
        };
      };
    };
  };
}
