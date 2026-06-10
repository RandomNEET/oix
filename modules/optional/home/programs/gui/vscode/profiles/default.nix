{
  lib,
  pkgs,
  userDataDir,
}:
let
  inherit (lib) mkMerge;
  enableUpdateCheck = false;
  enableExtensionUpdateCheck = true;
  global = {
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      esbenp.prettier-vscode

      asvetliakov.vscode-neovim
      yzhang.markdown-all-in-one
      yzane.markdown-pdf
      ms-vscode.hexeditor
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode.remote-explorer
    ];
    userSettings = {
      "chat.disableAIFeatures" = true;
      "workbench.settings.showAISearchToggle" = false;
      "editor.aiStats.enabled" = false;

      vscode-neovim = {
        neovimInitVimPaths = {
          linux = "${userDataDir}/User/vscode-neovim.lua";
        };
      };
      markdown-pdf = {
        displayHeaderFooter = false;
        margin.top = "1cm";
      };
      extensions = {
        experimental = {
          affinity = {
            "asvetliakov.vscode-neovim" = 1;
          };
        };
      };
    };
  };
in
rec {
  default = global // {
    inherit enableUpdateCheck enableExtensionUpdateCheck;
  };
  c-cpp = mkMerge [
    global
    (import ./c-cpp.nix { inherit pkgs; })
  ];
  python = mkMerge [
    global
    (import ./python.nix { inherit pkgs; })
  ];
  web = mkMerge [
    global
    (import ./web.nix { inherit pkgs; })
  ];
  embedded = mkMerge [
    global
    c-cpp
    (import ./embedded.nix { inherit pkgs; })
  ];
}
