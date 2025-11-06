{
  lib,
  pkgs,
  opts,
  ...
}:
with pkgs.vscode-extensions;
[
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
]
++ lib.optionals ((opts.theme or "") == "catppuccin-mocha") [
  pkgs.vscode-extensions.catppuccin.catppuccin-vsc
  pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
]
