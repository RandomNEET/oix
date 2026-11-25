{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.helix = {
      enable = true;
      defaultEditor = config.oix.defaults.editor == "helix";
      settings = {
        editor = {
          default-yank-register = "+";

          line-number = "relative";
          bufferline = "multiple";
          popup-border = "menu";
          color-modes = true;

          soft-wrap = {
            enable = true;
          };
        };
        keys = {
          normal = {
            space = {
              space = "file_picker";
              "$" = "goto_line_end";
              "0" = "goto_line_start";
            };
          };
        };
      };
      extraPackages = with pkgs; [
        bash-language-server # bash
        clang-tools # c/cpp
        lua-language-server # lua
        marksman # markdown
        nil # nix
        rust-analyzer # rust
        vscode-langservers-extracted # html/css/json/eslint
        yaml-language-server # yaml
      ];
    };
  }
  // {
    oix.defaults.editor = lib.mkDefault "helix";
  }
  // lib.optionalAttrs (osConfig.oix.appearance.themes.enable or false) {
    stylix.targets.helix.enable = true;
  };
}
