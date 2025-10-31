{
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
  home-manager.sharedModules = [
    (_: {
      programs.vscode = {
        enable = true;
        package = pkgs.vscode;
        mutableExtensionsDir = true;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            github.copilot
            github.copilot-chat
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode.remote-explorer
            ms-vscode.hexeditor
            asvetliakov.vscode-neovim

            esbenp.prettier-vscode
            yzhang.markdown-all-in-one

            bbenoist.nix
            ecmel.vscode-html-css
            ms-python.python
            vue.volar

            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
          ];
          userMcp = {
            servers = {
              Github = {
                url = "https://api.githubcopilot.com/mcp/";
              };
            };
          };
        };
      };
    })
  ];
}
