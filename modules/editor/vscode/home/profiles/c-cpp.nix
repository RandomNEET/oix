{ pkgs }:
{
  extensions = with pkgs.vscode-extensions; [
    ms-vscode.cpptools-extension-pack
    hars.cppsnippets
  ];
}
