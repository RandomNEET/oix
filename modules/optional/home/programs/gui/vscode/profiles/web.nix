{ pkgs }:
{
  extensions = with pkgs.vscode-extensions; [
    ecmel.vscode-html-css
  ];
}
