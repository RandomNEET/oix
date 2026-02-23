{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.vscode = {
          enable = true;
          package = pkgs.vscode;
          mutableExtensionsDir = true;
          profiles = {
            default = {
              enableUpdateCheck = false;
              enableExtensionUpdateCheck = true;
              extensions = with pkgs.vscode-extensions; [
                github.copilot
                asvetliakov.vscode-neovim

                ms-vscode-remote.remote-ssh
                ms-vscode-remote.remote-ssh-edit
                ms-vscode.remote-explorer
                ms-vscode.hexeditor

                bbenoist.nix
                ecmel.vscode-html-css
                ms-python.python
                vue.volar
                esbenp.prettier-vscode

                yzhang.markdown-all-in-one
                yzane.markdown-pdf
              ];
              userMcp = {
                servers = {
                  Github = {
                    url = "https://api.githubcopilot.com/mcp/";
                  };
                };
              };
              userSettings = {
                vscode-neovim = {
                  neovimInitVimPaths = {
                    linux = "${config.xdg.configHome}/Code/vscode-neovim.lua";
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
          };
        };
        home.file.".config/Code/vscode-neovim.lua".text = ''
          vim.opt.clipboard = "unnamedplus"
        '';
      }
    )
  ];
}
